namespace ResultsApi.Models;

public sealed class TestResultRequest
{
    public string TestName { get; init; } = string.Empty;
    public string Outcome { get; init; } = string.Empty;
    public long DurationMs { get; init; }
    public string? Error { get; init; }
    public DateTimeOffset OccurredAtUtc { get; init; }
    public string Competitor { get; set; }
}
