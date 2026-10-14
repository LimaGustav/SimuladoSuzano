using Nortrans.Contracts;
using Nortrans.Services;
using Xunit;

namespace Nortrans.Tests;

public sealed class CustomsValuationServiceTests : ResultReportingTestBase
{
    private readonly ICustomsValuationService _valuation = new CustomsValuationService();
    private static readonly DateTime Date = new(2026, 4, 17, 0, 0, 0, DateTimeKind.Utc);

    [Theory]
    [InlineData("null request", 0)]
    [InlineData("empty lines", 1)]
    [InlineData("negative FOB", 2)]
    [InlineData("negative freight", 3)]
    [InlineData("negative insurance", 4)]
    [Trait("Module 3", "6.1 - Valuation input validation")]
    public Task Value_Rejects_Each_Invalid_Request(string _, int invalidCase) => ReportAsync($"{nameof(Value_Rejects_Each_Invalid_Request)}[{invalidCase}]", () =>
    {
        var request = invalidCase switch
        {
            0 => null,
            1 => new ValuationRequest(Date, "CRC", 0, 0, []),
            2 => Request(fob: -1),
            3 => Request(freight: -1),
            4 => Request(insurance: -1),
            _ => throw new ArgumentOutOfRangeException(nameof(invalidCase))
        };
        AssertRejected(_valuation.Value(request));
    });

    [Fact]
    [Trait("Module 3", "6.2 - CRC and insurance")]
    public Task Value_Leaves_Crc_Unconverted_And_Distinguishes_Null_Insurance() => ReportAsync(nameof(Value_Leaves_Crc_Unconverted_And_Distinguishes_Null_Insurance), () =>
    {
        var notional = _valuation.Value(Request(fob: 10_000, freight: 2_000, insurance: null));
        var line = Assert.Single(notional.Lines);
        Assert.Equal(10_000, line.FobCentimos);
        Assert.Equal(2_000, line.ApportionedFreightCentimos);
        Assert.Equal(125, line.ApportionedInsuranceCentimos);
        Assert.Equal(12_125, line.CustomsValueCentimos);
        Assert.Contains(FindingCodes.NotionalInsuranceApplied, notional.Findings);

        var declaredZero = _valuation.Value(Request(fob: 10_000, freight: 2_000, insurance: 0));
        Assert.Equal(0, Assert.Single(declaredZero.Lines).ApportionedInsuranceCentimos);
        Assert.DoesNotContain(FindingCodes.NotionalInsuranceApplied, declaredZero.Findings);
    });

    [Fact]
    [Trait("Module 3", "6.3 - Freight and insurance apportionment")]
    public Task Value_Apportions_By_Weight_Then_Value_Then_Equality_With_Deterministic_Residues() => ReportAsync(nameof(Value_Apportions_By_Weight_Then_Value_Then_Equality_With_Deterministic_Residues), () =>
    {
        var weighted = _valuation.Value(new ValuationRequest(Date, "CRC", 10, 5,
        [
            Line(2, fob: 100, weight: 1),
            Line(1, fob: 100, weight: 2)
        ]));
        Assert.Equal(4, weighted.Lines.Single(x => x.LineNumber == 2).ApportionedFreightCentimos);
        Assert.Equal(6, weighted.Lines.Single(x => x.LineNumber == 1).ApportionedFreightCentimos);
        Assert.Equal(2, weighted.Lines.Single(x => x.LineNumber == 2).ApportionedInsuranceCentimos);
        Assert.Equal(3, weighted.Lines.Single(x => x.LineNumber == 1).ApportionedInsuranceCentimos);

        var byValue = _valuation.Value(new ValuationRequest(Date, "CRC", 1, 0,
        [Line(2, fob: 1, weight: 0), Line(1, fob: 2, weight: 0)]));
        Assert.Contains(FindingCodes.ApportionedByValue, byValue.Findings);
        Assert.Equal(0, byValue.Lines.Single(x => x.LineNumber == 2).ApportionedFreightCentimos);
        Assert.Equal(1, byValue.Lines.Single(x => x.LineNumber == 1).ApportionedFreightCentimos);

        var equal = _valuation.Value(new ValuationRequest(Date, "CRC", 1, 0,
        [Line(2, fob: 0, weight: 0), Line(1, fob: 0, weight: 0)]));
        Assert.Contains(FindingCodes.ApportionedEqually, equal.Findings);
        Assert.Equal(0, equal.Lines.Single(x => x.LineNumber == 2).ApportionedFreightCentimos);
        Assert.Equal(1, equal.Lines.Single(x => x.LineNumber == 1).ApportionedFreightCentimos);
    });

    [Fact]
    [Trait("Module 3", "6.4 - Valuation totals")]
    public Task Value_Makes_Each_Line_And_Total_The_Exact_Sum_Of_Parts() => ReportAsync(nameof(Value_Makes_Each_Line_And_Total_The_Exact_Sum_Of_Parts), () =>
    {
        var result = _valuation.Value(new ValuationRequest(Date, "CRC", 101, 51,
        [Line(1, 100, 1), Line(2, 200, 2)]));

        foreach (var line in result.Lines)
            Assert.Equal(line.FobCentimos + line.ApportionedFreightCentimos + line.ApportionedInsuranceCentimos, line.CustomsValueCentimos);
        Assert.Equal(result.Lines.Sum(x => x.CustomsValueCentimos), result.TotalCustomsValueCentimos);
    });

    [Fact]
    [Trait("Module 3", "6.5 - FX fallback")]
    public Task Value_Uses_Only_Available_Fx_Rates_And_Rejects_Missing_Rates() => ReportAsync(nameof(Value_Uses_Only_Available_Fx_Rates_And_Rejects_Missing_Rates), () =>
    {
        // These currency/date pairs are intentionally absent from the supplied FX table.
        var result = _valuation.Value(new ValuationRequest(new DateTime(1900, 1, 1, 0, 0, 0, DateTimeKind.Utc), "ZZZ", 0, 0, [Line(1, 100, 1)]));
        Assert.Equal(0, result.TotalCustomsValueCentimos);
        Assert.Empty(result.Lines);
        Assert.Contains(FindingCodes.FxRateNotFound, result.Findings);
    });

    private static ValuationRequest Request(long fob = 100, long freight = 0, long? insurance = 0)
        => new(Date, "CRC", freight, insurance, [Line(1, fob, 1)]);

    private static DeclarationLine Line(int number, long fob, int weight)
        => new(number, "010121", "CR", fob, weight, false, null);

    private static void AssertRejected(CustomsValuation result)
    {
        Assert.Equal(0, result.TotalCustomsValueCentimos);
        Assert.Empty(result.Lines);
        Assert.Equal(1, result.Findings.Count(x => x == FindingCodes.InvalidRequest));
    }
}
