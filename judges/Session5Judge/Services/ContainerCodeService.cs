using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// ISO 6346 container code service. See "Module 2", section 5.
/// </summary>
public sealed class ContainerCodeService : IContainerCodeService
{
    public bool IsValidContainerNumber(string? input)
    {
        var value = Normalise(input);
        return value.Length == 11 && char.IsDigit(value[10]) && ComputeCheckDigit(value[..10]) == value[10] - '0';
    }

    public int ComputeCheckDigit(string? first10)
    {
        var value = CodeText.Normalise(first10);
        if (!IsDataPart(value)) return -1;
        var sum = 0;
        for (var i = 0; i < 10; i++) sum += CharacterValue(value[i]) * (1 << i);
        var remainder = sum % 11;
        return remainder == 10 ? 0 : remainder;
    }

    public string Normalise(string? raw)
    {
        var value = CodeText.Normalise(raw);
        return value.Length == 11 ? value : string.Empty;
    }

    public ContainerCategory GetCategory(string? input)
    {
        var value = CodeText.Normalise(input);
        if (value.Length < 4) return ContainerCategory.Unknown;
        return value[3] switch { 'U' => ContainerCategory.FreightContainer, 'J' => ContainerCategory.DetachableEquipment, 'Z' => ContainerCategory.TrailerOrChassis, _ => ContainerCategory.Unknown };
    }

    public string FormatContainerNumber(string? input)
    {
        var value = Normalise(input);
        return IsValidContainerNumber(value) ? $"{value[..4]} {value.Substring(4, 6)} {value[10]}" : string.Empty;
    }

    public ContainerOwner? LookupOwner(string? input)
    {
        var value = CodeText.Normalise(input);
        if (value.Length < 4) return null;
        // The supplied registry contains the four-character owner/category identifier
        // (for example MSCU). Accept a three-character registry too for portability.
        if (TradeData.Owners.TryGetValue(value[..4], out var owner)) return owner;
        return TradeData.Owners.TryGetValue(value[..3], out owner) ? owner : null;
    }

    public SizeTypeInfo? LookupSizeType(string? sizeTypeCode)
    {
        var value = CodeText.Normalise(sizeTypeCode);
        return value.Length == 4 && TradeData.SizeTypes.TryGetValue(value, out var info) ? info : null;
    }

    private static bool IsDataPart(string value) => value.Length == 10 && value[..3].All(char.IsLetter) && value[3] is 'U' or 'J' or 'Z' && CodeText.IsDigits(value[4..]);
    private static int CharacterValue(char character)
    {
        if (char.IsDigit(character)) return character - '0';
        var offset = character - 'A';
        return 10 + offset + ((offset + 9) / 10); // 11, 22 and 33 are skipped.
    }
}
