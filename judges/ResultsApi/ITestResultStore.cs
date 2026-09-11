using ResultsApi.Models;

namespace ResultsApi;

public interface ITestResultStore
{
    void Save(TestResultRequest result, string competitor);
    IReadOnlyDictionary<string, TestResultRequest> GetAll(string competitor);
}
