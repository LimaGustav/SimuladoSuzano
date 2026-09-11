using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// GS1 Serial Shipping Container Code service. See "Module 2", section 6.
/// </summary>
public sealed class SsccService : ISsccService
{
    public bool IsValidSscc(string? input) => throw new NotImplementedException();

    public int ComputeCheckDigit(string? first17) => throw new NotImplementedException();

    public string FormatSscc(string? input) => throw new NotImplementedException();

    public string BuildSscc(int extensionDigit, string? companyPrefix, long serialReference)
        => throw new NotImplementedException();

    public SsccParts? Parse(string? input) => throw new NotImplementedException();
}
