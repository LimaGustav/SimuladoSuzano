using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// Air and ocean chargeable weight calculator. See "Module 3", section 5.
/// </summary>
public sealed class ChargeableWeightCalculator : IChargeableWeightCalculator
{
    public ChargeableWeight AirChargeableWeight(IReadOnlyList<CargoPiece>? pieces)
        => throw new NotImplementedException();

    public OceanMeasure OceanRevenueTons(IReadOnlyList<CargoPiece>? pieces)
        => throw new NotImplementedException();
}
