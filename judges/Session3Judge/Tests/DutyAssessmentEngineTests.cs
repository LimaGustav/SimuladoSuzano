using Nortrans.Contracts;
using Nortrans.Services;
using Xunit;

namespace Nortrans.Tests;

public sealed class DutyAssessmentEngineTests : ResultReportingTestBase
{
    private readonly IDutyAssessmentEngine _engine = new DutyAssessmentEngine();
    private static readonly DateTime Date = new(2026, 4, 17, 0, 0, 0, DateTimeKind.Utc);

    [Theory]
    [InlineData("null request", 0)]
    [InlineData("null valuation", 1)]
    [InlineData("empty valuation", 2)]
    [Trait("Module 3", "7.1 - Assessment input validation")]
    public Task Assess_Rejects_Each_Invalid_Request_Without_Throwing(string _, int invalidCase) => ReportAsync($"{nameof(Assess_Rejects_Each_Invalid_Request_Without_Throwing)}[{invalidCase}]", () =>
    {
        var request = invalidCase switch
        {
            0 => null,
            1 => new DutyAssessmentRequest(Date, CustomsRegime.General, null!, [Line(1)]),
            2 => new DutyAssessmentRequest(Date, CustomsRegime.General, new CustomsValuation(0, [], []), []),
            _ => throw new ArgumentOutOfRangeException(nameof(invalidCase))
        };
        AssertRejected(_engine.Assess(request));
    });

    [Fact]
    [Trait("Module 3", "7.2 - Courier de minimis")]
    public Task Assess_Applies_De_Minimis_First_And_Includes_The_Threshold() => ReportAsync(nameof(Assess_Applies_De_Minimis_First_And_Includes_The_Threshold), () =>
    {
        var atLimit = _engine.Assess(Request(CustomsRegime.Courier, 3_000_000, Line(1, "not-a-hs-code")));
        Assert.All(atLimit.Lines, line => Assert.Equal(0, line.TotalChargesCentimos));
        Assert.Equal(0, atLimit.GrandTotalChargesCentimos);
        Assert.Contains(FindingCodes.DeMinimisApplied, atLimit.Findings);
        Assert.DoesNotContain(FindingCodes.HsCodeNotInTariff, atLimit.Findings);

        var aboveLimit = _engine.Assess(Request(CustomsRegime.Courier, 3_000_001, Line(1, "not-a-hs-code")));
        Assert.DoesNotContain(FindingCodes.DeMinimisApplied, aboveLimit.Findings);

        var general = _engine.Assess(Request(CustomsRegime.General, 1, Line(1, "not-a-hs-code")));
        Assert.DoesNotContain(FindingCodes.DeMinimisApplied, general.Findings);
    });

    [Fact]
    [Trait("Module 3", "7.3 - Missing tariff rows")]
    public Task Assess_Continues_With_Zero_Dai_And_Sct_For_An_Unknown_Hs_Code() => ReportAsync(nameof(Assess_Continues_With_Zero_Dai_And_Sct_For_An_Unknown_Hs_Code), () =>
    {
        var result = _engine.Assess(Request(CustomsRegime.General, 100_000, Line(1, "999999")));
        var line = Assert.Single(result.Lines);
        Assert.Equal(0, line.AppliedDaiRateBasisPoints);
        Assert.Equal(0, line.ImportDutyCentimos);
        Assert.Equal(0, line.SelectiveConsumptionTaxCentimos);
        Assert.Contains(FindingCodes.HsCodeNotInTariff, line.Findings);
        Assert.Equal(line.ImportDutyCentimos + line.Law6946Centimos + line.SelectiveConsumptionTaxCentimos + line.AntiDumpingCentimos + line.ValueAddedTaxCentimos, line.TotalChargesCentimos);
    });

    [Fact]
    [Trait("Module 3", "7.4 - Tax bases and totals")]
    public Task Assess_Uses_The_Documented_Tax_Bases_And_Exact_Aggregates() => ReportAsync(nameof(Assess_Uses_The_Documented_Tax_Bases_And_Exact_Aggregates), () =>
    {
        var result = _engine.Assess(Request(CustomsRegime.General, 10_000,
            Line(1, "999999"), Line(2, "999999"), values: [4_000, 6_000]));

        foreach (var line in result.Lines)
        {
            Assert.Equal(line.CustomsValueCentimos / 100, line.Law6946Centimos);
            Assert.Equal(RoundAway((line.CustomsValueCentimos + line.ImportDutyCentimos + line.Law6946Centimos + line.SelectiveConsumptionTaxCentimos) * 13, 100), line.ValueAddedTaxCentimos);
            Assert.Equal(line.ImportDutyCentimos + line.Law6946Centimos + line.SelectiveConsumptionTaxCentimos + line.AntiDumpingCentimos + line.ValueAddedTaxCentimos, line.TotalChargesCentimos);
        }
        Assert.Equal(result.Lines.Sum(x => x.CustomsValueCentimos), result.TotalCustomsValueCentimos);
        Assert.Equal(result.Lines.Sum(x => x.ImportDutyCentimos), result.TotalImportDutyCentimos);
        Assert.Equal(result.Lines.Sum(x => x.Law6946Centimos), result.TotalLaw6946Centimos);
        Assert.Equal(result.Lines.Sum(x => x.SelectiveConsumptionTaxCentimos), result.TotalSelectiveConsumptionTaxCentimos);
        Assert.Equal(result.Lines.Sum(x => x.AntiDumpingCentimos), result.TotalAntiDumpingCentimos);
        Assert.Equal(result.Lines.Sum(x => x.ValueAddedTaxCentimos), result.TotalValueAddedTaxCentimos);
        Assert.Equal(result.Lines.Sum(x => x.TotalChargesCentimos), result.GrandTotalChargesCentimos);
    });

    [Fact]
    [Trait("Module 3", "7.5 - Public contract safety")]
    public Task Public_Calculation_Contracts_Expose_Only_Integer_Monetary_Amounts() => ReportAsync(nameof(Public_Calculation_Contracts_Expose_Only_Integer_Monetary_Amounts), () =>
    {
        var contractTypes = typeof(DutyAssessment).Assembly.GetTypes()
            .Where(type => type.Namespace == typeof(DutyAssessment).Namespace && type.IsPublic);

        foreach (var property in contractTypes.SelectMany(type => type.GetProperties()))
        {
            Assert.NotEqual(typeof(decimal), property.PropertyType);
            Assert.NotEqual(typeof(double), property.PropertyType);
            Assert.NotEqual(typeof(float), property.PropertyType);
        }
    });

    private static DutyAssessmentRequest Request(CustomsRegime regime, long total, DeclarationLine first, DeclarationLine? second = null, long[]? values = null)
    {
        var lines = second is null ? new[] { first } : new[] { first, second };
        var lineValues = values ?? [total];
        var valuedLines = lines.Select((line, index) => new LineValuation(line.LineNumber, lineValues[index], 0, 0, lineValues[index])).ToArray();
        return new DutyAssessmentRequest(Date, regime, new CustomsValuation(lineValues.Sum(), valuedLines, []), lines);
    }

    private static DeclarationLine Line(int number, string hsCode = "999999")
        => new(number, hsCode, "ZZ", 0, 1, false, null);

    private static void AssertRejected(DutyAssessment result)
    {
        Assert.Equal(0, result.GrandTotalChargesCentimos);
        Assert.Empty(result.Lines);
        Assert.Equal(1, result.Findings.Count(x => x == FindingCodes.InvalidRequest));
    }

    private static long RoundAway(long numerator, long denominator)
        => numerator >= 0 ? (numerator + denominator / 2) / denominator : (numerator - denominator / 2) / denominator;
}
