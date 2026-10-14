using Nortrans.Contracts;
using Nortrans.Services;
using Xunit;

namespace Nortrans.Tests;

public sealed class ChargeableWeightCalculatorTests : ResultReportingTestBase
{
    private readonly IChargeableWeightCalculator _calculator = new ChargeableWeightCalculator();

    [Theory]
    [InlineData(0, 0, 0, 0, 0)]
    [InlineData(1, 0, 100, 100, 100)]
    [InlineData(1, 100, 100, 100, -1)]
    [InlineData(0, 100, 100, 100, 100)]
    [Trait("Module 3", "5.1 - Air input validation")]
    public Task AirChargeableWeight_Rejects_Each_Invalid_Piece(int quantity, int length, int width, int height, int grossWeight) => ReportAsync($"{nameof(AirChargeableWeight_Rejects_Each_Invalid_Piece)}[{quantity},{length},{width},{height},{grossWeight}]", () =>
    {
        var invalidResult = _calculator.AirChargeableWeight([new CargoPiece(quantity, length, width, height, grossWeight)]);
        Assert.Equal(0, invalidResult.GrossWeightGrams);
        Assert.Equal(0, invalidResult.VolumetricWeightGrams);
        Assert.Equal(0, invalidResult.ChargeableWeightGrams);
        Assert.Equal(1, invalidResult.Findings.Count(x => x == FindingCodes.InvalidPiece));
        Assert.DoesNotContain(FindingCodes.NoPiecesSupplied, invalidResult.Findings);
    });

    [Fact]
    [Trait("Module 3", "5.1 - Air input validation")]
    public Task AirChargeableWeight_Reports_No_Pieces_For_Null_Or_Empty_List() => ReportAsync(nameof(AirChargeableWeight_Reports_No_Pieces_For_Null_Or_Empty_List), () =>
    {
        Assert.Equal(new[] { FindingCodes.NoPiecesSupplied }, _calculator.AirChargeableWeight(null).Findings);
        Assert.Equal(new[] { FindingCodes.NoPiecesSupplied }, _calculator.AirChargeableWeight([]).Findings);
    });

    [Fact]
    [Trait("Module 3", "5.2 - Air chargeable weight")]
    public Task AirChargeableWeight_Uses_Only_Valid_Pieces_And_The_Greater_Weight() => ReportAsync(nameof(AirChargeableWeight_Uses_Only_Valid_Pieces_And_The_Greater_Weight), () =>
    {
        var mixed = _calculator.AirChargeableWeight([
            new CargoPiece(1, 600, 500, 500, 10_000), // 25,000g volumetric
            new CargoPiece(1, -1, 100, 100, 100),
            new CargoPiece(2, 100, 100, 100, 2_000) // 4,000g gross
        ]);
        Assert.Equal(14_000, mixed.GrossWeightGrams);
        Assert.Equal(25_334, mixed.VolumetricWeightGrams);
        Assert.Equal(25_500, mixed.ChargeableWeightGrams);
        Assert.Contains(FindingCodes.InvalidPiece, mixed.Findings);

        var grossDominates = _calculator.AirChargeableWeight([new CargoPiece(1, 100, 100, 100, 5_001)]);
        Assert.Equal(5_001, grossDominates.GrossWeightGrams);
        Assert.Equal(167, grossDominates.VolumetricWeightGrams);
        Assert.Equal(5_500, grossDominates.ChargeableWeightGrams);

        var tie = _calculator.AirChargeableWeight([new CargoPiece(1, 600, 100, 100, 1_000)]);
        Assert.Equal(1_000, tie.GrossWeightGrams);
        Assert.Equal(1_000, tie.VolumetricWeightGrams);
        Assert.Equal(1_000, tie.ChargeableWeightGrams);
    });

    [Fact]
    [Trait("Module 3", "5.3 - Air rounding and aggregation")]
    public Task AirChargeableWeight_Rounds_Per_Piece_Then_To_500_Grams_And_Avoids_Overflow() => ReportAsync(nameof(AirChargeableWeight_Rounds_Per_Piece_Then_To_500_Grams_And_Avoids_Overflow), () =>
    {
        // 3,000,000 / 6,000 = 500g: already a 500g multiple.
        var exact = _calculator.AirChargeableWeight([new CargoPiece(1, 300, 100, 100, 1)]);
        Assert.Equal(500, exact.ChargeableWeightGrams);

        // 12,003,000 / 6,000 = 2,000.5g; midpoint must round away from zero.
        var midpoint = _calculator.AirChargeableWeight([new CargoPiece(1, 1_200_300, 10, 1, 1)]);
        Assert.Equal(2_001, midpoint.VolumetricWeightGrams);
        Assert.Equal(2_500, midpoint.ChargeableWeightGrams);

        var quantities = _calculator.AirChargeableWeight([
            new CargoPiece(2, 600, 100, 100, 1_000),
            new CargoPiece(3, 300, 100, 100, 500),
            new CargoPiece(1, 100, 100, 100, 2_001)
        ]);
        Assert.Equal(5_501, quantities.GrossWeightGrams);
        Assert.Equal(4_001, quantities.VolumetricWeightGrams);
        Assert.Equal(6_000, quantities.ChargeableWeightGrams);

        var large = _calculator.AirChargeableWeight([new CargoPiece(1, 100_000, 100_000, 100_000, 1)]);
        Assert.Equal(166_666_667, large.VolumetricWeightGrams);
        Assert.Equal(166_667_000, large.ChargeableWeightGrams);
    });

    [Fact]
    [Trait("Module 3", "5.4 - Ocean revenue tons")]
    public Task OceanRevenueTons_Validates_Aggregates_And_Applies_Minimum() => ReportAsync(nameof(OceanRevenueTons_Validates_Aggregates_And_Applies_Minimum), () =>
    {
        var missing = _calculator.OceanRevenueTons(null);
        Assert.Equal(new[] { FindingCodes.NoPiecesSupplied }, missing.Findings);

        var allInvalid = _calculator.OceanRevenueTons([new CargoPiece(1, 0, 1, 1, 1)]);
        Assert.Equal(0, allInvalid.VolumeThousandthsM3);
        Assert.Equal(0, allInvalid.WeightThousandthsTonne);
        Assert.Equal(0, allInvalid.RevenueTonThousandths);
        Assert.Equal(new[] { FindingCodes.InvalidPiece }, allInvalid.Findings);

        var volumeDominates = _calculator.OceanRevenueTons([new CargoPiece(1, 2_000, 1_000, 1_000, 1_000)]);
        Assert.Equal(2_000, volumeDominates.VolumeThousandthsM3);
        Assert.Equal(1, volumeDominates.WeightThousandthsTonne);
        Assert.Equal(2_000, volumeDominates.RevenueTonThousandths);

        var weightDominates = _calculator.OceanRevenueTons([new CargoPiece(1, 100, 100, 100, 2_000_000)]);
        Assert.Equal(1, weightDominates.VolumeThousandthsM3);
        Assert.Equal(2_000, weightDominates.WeightThousandthsTonne);
        Assert.Equal(2_000, weightDominates.RevenueTonThousandths);

        var minimum = _calculator.OceanRevenueTons([new CargoPiece(1, 100, 100, 100, 500)]);
        Assert.Equal(1_000, minimum.RevenueTonThousandths);
    });

    [Fact]
    [Trait("Module 3", "5.5 - Ocean rounding order")]
    public Task OceanRevenueTons_Rounds_After_Aggregation() => ReportAsync(nameof(OceanRevenueTons_Rounds_After_Aggregation), () =>
    {
        // Each piece is 0.5 thousandths m3, but the consignment is 1.0 thousandth.
        var result = _calculator.OceanRevenueTons([
            new CargoPiece(1, 1_000, 1, 500, 500),
            new CargoPiece(1, 1_000, 1, 500, 500)
        ]);
        Assert.Equal(1, result.VolumeThousandthsM3);
        Assert.Equal(1, result.WeightThousandthsTonne);
        Assert.Equal(1_000, result.RevenueTonThousandths);
    });
}
