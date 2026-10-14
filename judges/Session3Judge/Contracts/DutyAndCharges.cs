namespace Nortrans.Contracts;

// =====================================================================================
//  Nortrans Cargo & Customs — Duty & Charges Engine contracts.
//  This project is FIXED. Do not modify it. Implement against it in the Services project.
//
//  Money is always an integer number of minor units. Colón amounts are céntimos.
//  Rates are basis points: 1 bp = 0.01 %. Weights are grams, dimensions millimetres.
//  All instants are UTC. No member ever throws.
// =====================================================================================

/// <summary>Finding codes attached to a calculation result. Compare as ordinal strings.</summary>
public static class FindingCodes
{
    public const string NoPiecesSupplied = "NO_PIECES_SUPPLIED";
    public const string InvalidPiece = "INVALID_PIECE";
    public const string InvalidRequest = "INVALID_REQUEST";
    public const string FxRateNotFound = "FX_RATE_NOT_FOUND";
    public const string NotionalInsuranceApplied = "NOTIONAL_INSURANCE_APPLIED";
    public const string ApportionedByValue = "APPORTIONED_BY_VALUE";
    public const string ApportionedEqually = "APPORTIONED_EQUALLY";
    public const string DeMinimisApplied = "DE_MINIMIS_APPLIED";
    public const string HsCodeNotInTariff = "HS_CODE_NOT_IN_TARIFF";
    public const string PreferenceApplied = "PREFERENCE_APPLIED";
    public const string PreferenceDeniedNoCertificate = "PREFERENCE_DENIED_NO_CERTIFICATE";
    public const string PreferenceDeniedCertificateExpired = "PREFERENCE_DENIED_CERTIFICATE_EXPIRED";
    public const string Law6946Exempt = "LAW6946_EXEMPT";
    public const string AntidumpingApplied = "ANTIDUMPING_APPLIED";
}

/// <summary>Customs regime the declaration is filed under.</summary>
public enum CustomsRegime
{
    /// <summary>Ordinary import. De minimis never applies.</summary>
    General = 0,

    /// <summary>Courier consignment. Eligible for the de minimis threshold.</summary>
    Courier,

    /// <summary>Temporary admission.</summary>
    TemporaryAdmission,

    /// <summary>Re-import of goods previously exported.</summary>
    Reimport
}

// ------------------------------------------------------------------ Part 1

/// <summary>One line of a packing list. GrossWeightGrams is the weight of a single piece.</summary>
public sealed record CargoPiece(
    int Quantity,
    int LengthMm,
    int WidthMm,
    int HeightMm,
    int GrossWeightGrams);

/// <summary>Result of an air chargeable weight calculation. All values in grams.</summary>
public sealed record ChargeableWeight(
    int GrossWeightGrams,
    int VolumetricWeightGrams,
    int ChargeableWeightGrams,
    IReadOnlyList<string> Findings);

/// <summary>Result of an ocean weight-or-measure calculation. All values in thousandths.</summary>
/// <param name="VolumeThousandthsM3">Volume in thousandths of a cubic metre.</param>
/// <param name="WeightThousandthsTonne">Gross weight in thousandths of a metric tonne.</param>
/// <param name="RevenueTonThousandths">The greater of the two, with a minimum of 1000.</param>
public sealed record OceanMeasure(
    long VolumeThousandthsM3,
    long WeightThousandthsTonne,
    long RevenueTonThousandths,
    IReadOnlyList<string> Findings);

/// <summary>Chargeable weight calculator for air and ocean consignments.</summary>
public interface IChargeableWeightCalculator
{
    /// <summary>Air chargeable weight, using the IATA divisor of 6000 cm³ per kilogram and
    /// rounding up to the next whole 500 grams.</summary>
    ChargeableWeight AirChargeableWeight(IReadOnlyList<CargoPiece>? pieces);

    /// <summary>Ocean revenue tons: the greater of cubic metres and metric tonnes, minimum one.</summary>
    OceanMeasure OceanRevenueTons(IReadOnlyList<CargoPiece>? pieces);
}

// ------------------------------------------------------------------ Part 2

/// <summary>One line of the commercial invoice, before valuation.</summary>
/// <param name="LineNumber">One-based line number as it appears on the invoice.</param>
/// <param name="HsCode">Harmonized System code; only the first six digits are used for the tariff.</param>
/// <param name="OriginCountry">ISO 3166-1 alpha-2 country of origin.</param>
/// <param name="FobAmountMinor">FOB value of the line, in the invoice currency's minor unit.</param>
/// <param name="GrossWeightGrams">Gross weight of the line.</param>
/// <param name="HasOriginCertificate">Whether a certificate of origin was presented.</param>
/// <param name="CertificateIssuedUtc">Issue date of that certificate, or null.</param>
public sealed record DeclarationLine(
    int LineNumber,
    string HsCode,
    string OriginCountry,
    long FobAmountMinor,
    int GrossWeightGrams,
    bool HasOriginCertificate,
    DateTime? CertificateIssuedUtc);

/// <summary>A declaration presented for valuation.</summary>
/// <param name="DeclarationDateUtc">Date the declaration is filed; drives the FX and tariff lookups.</param>
/// <param name="InvoiceCurrency">ISO 4217 code of the invoice, for example USD. CRC needs no conversion.</param>
/// <param name="FreightAmountMinor">International freight, in the invoice currency's minor unit.</param>
/// <param name="InsuranceAmountMinor">Declared insurance, or null when none was declared.</param>
/// <param name="Lines">The invoice lines. Must not be empty.</param>
public sealed record ValuationRequest(
    DateTime DeclarationDateUtc,
    string InvoiceCurrency,
    long FreightAmountMinor,
    long? InsuranceAmountMinor,
    IReadOnlyList<DeclarationLine> Lines);

/// <summary>Valuation of one line. All amounts in céntimos.</summary>
public sealed record LineValuation(
    int LineNumber,
    long FobCentimos,
    long ApportionedFreightCentimos,
    long ApportionedInsuranceCentimos,
    long CustomsValueCentimos);

/// <summary>Valuation of the whole declaration. All amounts in céntimos.</summary>
public sealed record CustomsValuation(
    long TotalCustomsValueCentimos,
    IReadOnlyList<LineValuation> Lines,
    IReadOnlyList<string> Findings);

/// <summary>CIF customs valuation service.</summary>
public interface ICustomsValuationService
{
    /// <summary>Values a declaration and apportions freight and insurance across its lines.</summary>
    CustomsValuation Value(ValuationRequest? request);
}

// ------------------------------------------------------------------ Part 3

/// <summary>A valued declaration presented for assessment.</summary>
/// <param name="DeclarationDateUtc">Date the declaration is filed.</param>
/// <param name="Regime">Customs regime; only Courier is eligible for de minimis.</param>
/// <param name="Valuation">Result of <see cref="ICustomsValuationService.Value"/>.</param>
/// <param name="Lines">The same invoice lines that were valued, in the same order.</param>
public sealed record DutyAssessmentRequest(
    DateTime DeclarationDateUtc,
    CustomsRegime Regime,
    CustomsValuation Valuation,
    IReadOnlyList<DeclarationLine> Lines);

/// <summary>Charges assessed on one line. All amounts in céntimos.</summary>
public sealed record LineAssessment(
    int LineNumber,
    long CustomsValueCentimos,
    int AppliedDaiRateBasisPoints,
    long ImportDutyCentimos,
    long Law6946Centimos,
    long SelectiveConsumptionTaxCentimos,
    long AntiDumpingCentimos,
    long ValueAddedTaxCentimos,
    long TotalChargesCentimos,
    IReadOnlyList<string> Findings);

/// <summary>Charges assessed on the whole declaration. All amounts in céntimos.</summary>
public sealed record DutyAssessment(
    long TotalCustomsValueCentimos,
    long TotalImportDutyCentimos,
    long TotalLaw6946Centimos,
    long TotalSelectiveConsumptionTaxCentimos,
    long TotalAntiDumpingCentimos,
    long TotalValueAddedTaxCentimos,
    long GrandTotalChargesCentimos,
    IReadOnlyList<LineAssessment> Lines,
    IReadOnlyList<string> Findings);

/// <summary>Duty and tax assessment engine.</summary>
public interface IDutyAssessmentEngine
{
    /// <summary>Assesses every charge due on a valued declaration.</summary>
    DutyAssessment Assess(DutyAssessmentRequest? request);
}
