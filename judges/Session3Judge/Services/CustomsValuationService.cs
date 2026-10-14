using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// CIF customs valuation service. See "Module 3", section 6.
/// </summary>
public sealed class CustomsValuationService : ICustomsValuationService
{
    public CustomsValuation Value(ValuationRequest? request) => throw new NotImplementedException();
}
