using System.Collections.Concurrent;
using ResultsApi.Models;

namespace ResultsApi;

public sealed class InMemoryTestResultStore : ITestResultStore
{
    private readonly ConcurrentDictionary<string,ConcurrentDictionary<string, TestResultRequest>> _results = new(StringComparer.Ordinal);

    public void Save(TestResultRequest result, string competitior) {
        if (!_results.ContainsKey(competitior))
        {
            _results[competitior] = new ConcurrentDictionary<string, TestResultRequest>();
        }
        _results[competitior][result.TestName] = result;
    } 

    public IReadOnlyDictionary<string, TestResultRequest> GetAll(string competitor) {
        if (!_results.ContainsKey(competitor))
            return null;
     return _results[competitor]
        .OrderBy(pair => pair.Key, StringComparer.Ordinal)
        .ToDictionary(pair => pair.Key, pair => pair.Value, StringComparer.Ordinal);

    } 
}
