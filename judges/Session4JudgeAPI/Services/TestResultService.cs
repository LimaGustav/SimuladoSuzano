using Microsoft.IdentityModel.Tokens;
using Session4JudgeAPI.DTOs;

namespace Session4JudgeAPI.Services;

/// <summary>
/// Singleton service that keeps test results in memory across all requests.
/// </summary>
public class TestResultService
{
    private readonly List<TestResult> _results = new();
    private readonly object _lock = new();

    public void Add(TestResult result)
    {
        if (result.Passed)
            result.Message = "Success";
        else
            result.Message = "Error";

        lock (_lock)
        {
            var oldTest = _results.FirstOrDefault(x => x.TestName == result.TestName);
            if (oldTest != null) _results.Remove(oldTest);

            _results.Add(result);
            Console.WriteLine(_results);
        }
    }

    public List<TestResult> GetAll()
    {
        lock (_lock)
        {
            return _results.ToList();
        }
    }

    public void Clear()
    {
        lock (_lock)
        {
            _results.Clear();
        }
    }
}

