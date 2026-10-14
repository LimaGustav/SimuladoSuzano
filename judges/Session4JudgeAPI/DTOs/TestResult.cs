namespace Session4JudgeAPI.DTOs;

public class TestResult
{
    public string TestName { get; set; } = "";
    public string Endpoint { get; set; } = "";
    public bool Passed { get; set; }
    public int? ExpectedStatusCode { get; set; }
    public int? ActualStatusCode { get; set; }
    public string Message { get; set; } = "";
    public DateTime ExecutedAt { get; set; }
}

