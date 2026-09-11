namespace Nortrans.Contracts;

// =====================================================================================
//  Nortrans Cargo & Customs — Trade Codes Library contracts.
//  This project is FIXED. Do not modify it. Implement against it in the Services project.
// =====================================================================================

/// <summary>Category of a container, taken from the fourth letter of its ISO 6346 number.</summary>
public enum ContainerCategory
{
    /// <summary>The fourth character is missing or is not U, J or Z.</summary>
    Unknown = 0,

    /// <summary>Fourth letter U — freight container.</summary>
    FreightContainer,

    /// <summary>Fourth letter J — detachable freight container equipment.</summary>
    DetachableEquipment,

    /// <summary>Fourth letter Z — trailer or chassis.</summary>
    TrailerOrChassis
}

/// <summary>The registered owner behind the first three letters of a container number.</summary>
/// <param name="Prefix">The three-letter owner prefix, upper case.</param>
/// <param name="OwnerName">The registered owner name as published in iso6346-owner-codes.csv.</param>
/// <param name="CountryCode">ISO 3166-1 alpha-2 country of the owner.</param>
public sealed record ContainerOwner(string Prefix, string OwnerName, string CountryCode);

/// <summary>Information behind a four-character ISO 6346 size and type code.</summary>
/// <param name="Code">The size/type code itself, upper case.</param>
/// <param name="LengthFt">Nominal external length in feet.</param>
/// <param name="Height">Nominal external height as published, for example 8'6".</param>
/// <param name="TypeGroup">Type group, for example General purpose.</param>
/// <param name="TypeDescription">Full type description as published.</param>
/// <param name="Refrigerated">True when the type group is a refrigerated container.</param>
public sealed record SizeTypeInfo(
    string Code,
    int LengthFt,
    string Height,
    string TypeGroup,
    string TypeDescription,
    bool Refrigerated);

/// <summary>
/// Container code service, ISO 6346. No member ever throws: malformed input produces the
/// documented rejection value.
/// </summary>
public interface IContainerCodeService
{
    /// <summary>True only when the normalised input is a structurally correct container number
    /// whose last digit matches the computed check digit.</summary>
    bool IsValidContainerNumber(string? input);

    /// <summary>Check digit 0-9 for the first ten characters, or -1 when the normalised input is
    /// not exactly three letters, a valid category letter and six digits.</summary>
    int ComputeCheckDigit(string? first10);

    /// <summary>Normalised input when it is exactly eleven characters after normalisation; the empty
    /// string otherwise. The check digit is not verified.</summary>
    string Normalise(string? raw);

    /// <summary>Category taken from the fourth character, or Unknown.</summary>
    ContainerCategory GetCategory(string? input);

    /// <summary>The number grouped as "MSCU 123456 2", or the empty string when the number is
    /// not valid.</summary>
    string FormatContainerNumber(string? input);

    /// <summary>Registered owner of the three-letter prefix, or null when it is not published.</summary>
    ContainerOwner? LookupOwner(string? input);

    /// <summary>Size and type information for a four-character size/type code, or null when the
    /// code is not published.</summary>
    SizeTypeInfo? LookupSizeType(string? sizeTypeCode);
}

/// <summary>The four parts of a Serial Shipping Container Code.</summary>
/// <param name="ExtensionDigit">First digit of the code, 0-9.</param>
/// <param name="CompanyPrefix">GS1 company prefix, 6 to 10 digits.</param>
/// <param name="SerialReference">Serial reference digits between the prefix and the check digit.</param>
/// <param name="CheckDigit">Last digit of the code, 0-9.</param>
public sealed record SsccParts(
    int ExtensionDigit,
    string CompanyPrefix,
    string SerialReference,
    int CheckDigit);

/// <summary>
/// Serial Shipping Container Code service, GS1 General Specifications. No member ever throws.
/// </summary>
public interface ISsccService
{
    /// <summary>True only when the normalised input is exactly eighteen digits and the last digit
    /// matches the computed check digit.</summary>
    bool IsValidSscc(string? input);

    /// <summary>Check digit 0-9 for the seventeen data digits, or -1 when the normalised input is
    /// not exactly seventeen digits.</summary>
    int ComputeCheckDigit(string? first17);

    /// <summary>The code as "(00) 3 0614141 1234567890 2", or the empty string when the code is
    /// not valid.</summary>
    string FormatSscc(string? input);

    /// <summary>Builds a complete valid code, or the empty string when the arguments cannot
    /// produce one.</summary>
    string BuildSscc(int extensionDigit, string? companyPrefix, long serialReference);

    /// <summary>The four parts of the code, or null when the code is not valid.</summary>
    SsccParts? Parse(string? input);
}

/// <summary>Structural breakdown of a Harmonized System classification.</summary>
/// <param name="Chapter">First two digits.</param>
/// <param name="Heading">First four digits.</param>
/// <param name="Subheading">First six digits.</param>
/// <param name="NationalLine">Digits 7 and 8, or the empty string when the code is six digits.</param>
/// <param name="StatisticalLine">Digits 9 and 10, or the empty string when the code is shorter.</param>
/// <param name="Section">Harmonized System section number the chapter belongs to.</param>
public sealed record HsBreakdown(
    string Chapter,
    string Heading,
    string Subheading,
    string NationalLine,
    string StatisticalLine,
    int Section);

/// <summary>A description found for a Harmonized System code.</summary>
/// <param name="Code">The code the description belongs to, four or six digits.</param>
/// <param name="Level">Either "heading" or "subheading", as published in hs-headings.csv.</param>
/// <param name="Description">The published description.</param>
public sealed record HsLookup(string Code, string Level, string Description);

/// <summary>
/// Harmonized System code service. No member ever throws.
/// </summary>
public interface IHsCodeService
{
    /// <summary>True only when the normalised input is 6, 8 or 10 digits, the chapter is in range,
    /// and both the heading and the subheading are published.</summary>
    bool IsValidHsCode(string? input);

    /// <summary>Structural breakdown of a valid code, or null.</summary>
    HsBreakdown? Breakdown(string? input);

    /// <summary>The code with dots after the 4th, 6th and 8th digit, or the empty string when
    /// the code is not valid.</summary>
    string FormatDotted(string? input);

    /// <summary>Description of the subheading, falling back to the heading, or null when
    /// neither is published.</summary>
    HsLookup? Lookup(string? input);

    /// <summary>Every published row whose description contains the term, case-insensitive,
    /// ordered by code ascending. Never null.</summary>
    IReadOnlyList<HsLookup> Search(string? term);
}
