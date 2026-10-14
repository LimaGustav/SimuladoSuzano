using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace Nortrans.Tests;

/// <summary>Base class that reports the outcome of each xUnit test to an optional HTTP endpoint.</summary>
public abstract class ResultReportingTestBase
{
    protected async Task ReportAsync(string testName, Func<Task> test)
    {
        var timer = Stopwatch.StartNew();
        try
        {
            await test();
            await ResultsApiClient.PublishAsync(new TestResult(testName, "passed", timer.ElapsedMilliseconds, null));
        }
        catch (Exception exception)
        {
            await ResultsApiClient.PublishAsync(new TestResult(testName, "failed", timer.ElapsedMilliseconds, "Unfortunately you will have to figure out the error"));
            throw;
        }
    }

    protected Task ReportAsync(string testName, Action test) => ReportAsync(testName, () => { test(); return Task.CompletedTask; });
}

public sealed record TestResult(string TestName, string Outcome, long DurationMs, string? Error)
{
    public DateTimeOffset OccurredAtUtc { get; init; } = DateTimeOffset.UtcNow;
}

internal static class ResultsApiClient
{
    private static readonly HttpClient HttpClient = new();
    private static readonly Lazy<ResultsApiOptions> Options = new(ReadOptions);

    internal static async Task PublishAsync(TestResult result)
    {
        
        var options = Options.Value;
        if (options.Endpoint is null) return;

        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, options.Endpoint)
            {
                Content = new StringContent(JsonSerializer.Serialize(result), Encoding.UTF8, "application/json")
            };
            if (!string.IsNullOrWhiteSpace(options.ApiKey)) request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", options.ApiKey);
            using var cancellation = new CancellationTokenSource(TimeSpan.FromSeconds(options.TimeoutSeconds));
            using var response = await HttpClient.SendAsync(request, cancellation.Token);
            response.EnsureSuccessStatusCode();
        }
        catch (Exception exception)
        {
            Console.WriteLine($"[RESULTS API] Falha ao enviar resultado: {exception}");

            if (options.FailTestWhenUnavailable)
                throw;
        }
    }

    private static ResultsApiOptions ReadOptions()
    {
        const int defaultTimeoutSeconds = 10;
        var path = Path.Combine(AppContext.BaseDirectory, "appsettings.json");
        if (!File.Exists(path)) return new ResultsApiOptions(null, null, defaultTimeoutSeconds, false);
        try
        {
            using var document = JsonDocument.Parse(File.ReadAllText(path));
            if (!document.RootElement.TryGetProperty("ResultsApi", out var section)) return new ResultsApiOptions(null, null, defaultTimeoutSeconds, false);
            var endpointText = section.TryGetProperty("Endpoint", out var endpointValue) ? endpointValue.GetString() : null;
            var endpoint = Uri.TryCreate(endpointText, UriKind.Absolute, out var parsed) && (parsed.Scheme == Uri.UriSchemeHttp || parsed.Scheme == Uri.UriSchemeHttps) ? parsed : null;
            var apiKey = section.TryGetProperty("ApiKey", out var apiKeyValue) ? apiKeyValue.GetString() : null;
            var timeout = section.TryGetProperty("TimeoutSeconds", out var timeoutValue) && timeoutValue.TryGetInt32(out var configuredTimeout) && configuredTimeout > 0 ? configuredTimeout : defaultTimeoutSeconds;
            var fail = section.TryGetProperty("FailTestWhenUnavailable", out var failValue) && failValue.ValueKind is JsonValueKind.True;
            return new ResultsApiOptions(endpoint, apiKey, timeout, fail);
        }
        catch (JsonException)
        {
            return new ResultsApiOptions(null, null, defaultTimeoutSeconds, false);
        }
    }

    private sealed record ResultsApiOptions(Uri? Endpoint, string? ApiKey, int TimeoutSeconds, bool FailTestWhenUnavailable);
}
