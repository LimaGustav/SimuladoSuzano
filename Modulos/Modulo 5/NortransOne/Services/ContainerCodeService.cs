using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// ISO 6346 container code service. See "Module 2", section 5.
/// </summary>
public sealed class ContainerCodeService : IContainerCodeService
{
    public bool IsValidContainerNumber(string? input) => throw new NotImplementedException();

    public int ComputeCheckDigit(string? first10) => throw new NotImplementedException();

    public string Normalise(string? raw) => throw new NotImplementedException();

    public ContainerCategory GetCategory(string? input) => throw new NotImplementedException();

    public string FormatContainerNumber(string? input) => throw new NotImplementedException();

    public ContainerOwner? LookupOwner(string? input) => throw new NotImplementedException();

    public SizeTypeInfo? LookupSizeType(string? sizeTypeCode) => throw new NotImplementedException();
}
