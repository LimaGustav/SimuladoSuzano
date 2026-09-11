using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// Harmonized System code service. See "Module 2", section 7.
/// </summary>
public sealed class HsCodeService : IHsCodeService
{
    public bool IsValidHsCode(string? input) => throw new NotImplementedException();

    public HsBreakdown? Breakdown(string? input) => throw new NotImplementedException();

    public string FormatDotted(string? input) => throw new NotImplementedException();

    public HsLookup? Lookup(string? input) => throw new NotImplementedException();

    public IReadOnlyList<HsLookup> Search(string? term) => throw new NotImplementedException();
}
