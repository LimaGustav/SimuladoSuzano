using Nortrans.Contracts;

namespace Nortrans.Services;

/// <summary>
/// Duty and tax assessment engine. See "Module 3", section 7.
/// </summary>
public sealed class DutyAssessmentEngine : IDutyAssessmentEngine
{
    public DutyAssessment Assess(DutyAssessmentRequest? request) => throw new NotImplementedException();
}
