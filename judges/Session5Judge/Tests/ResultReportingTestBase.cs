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
            await ResultsApiClient.PublishAsync(new TestResult(testName, "failed", timer.ElapsedMilliseconds, exception.ToString()));
            throw;
        }
    }

    protected Task ReportAsync(string testName, Action test) => ReportAsync(testName, () => { test(); return Task.CompletedTask; });
}

public sealed class TestResult
{
    public string TestName { get; init; }
    public string Outcome { get; init; }
    public long DurationMs { get; init; }
    public string? Error { get; init; }
    public DateTimeOffset OccurredAtUtc { get; init; } = DateTimeOffset.UtcNow;
    public string Competitor { get; set; }

    public TestResult(string testName, string outcome, long durationMs, string? error)
    {
        TestName = testName;
        Outcome = outcome;
        DurationMs = durationMs;
        Error = error;
    }
}

internal static class ResultsApiClient
{
    private static readonly HttpClient HttpClient = new();
    private static readonly Lazy<ResultsApiOptions> Options = new(ReadOptions);

    internal static async Task PublishAsync(TestResult result)
    {
        var options = Options.Value;
        Console.WriteLine(options);
        if (options.Endpoint is null)
        {
            Console.WriteLine("[RESULTS API] Endpoint nulo — appsettings.json não foi carregado ou a seção 'ResultsApi' não foi encontrada.");
            return;
        }

        try
        {
            result.Competitor = options.Competitor.ToString();
            Console.WriteLine($"[RESULTS API] Enviando para {options.Endpoint} (Competitor={options.Competitor}, ApiKey vazia={string.IsNullOrWhiteSpace(options.ApiKey)})");

            using var request = new HttpRequestMessage(HttpMethod.Post, options.Endpoint)
            {
                Content = new StringContent(JsonSerializer.Serialize(result), Encoding.UTF8, "application/json")
            };
            if (!string.IsNullOrWhiteSpace(options.ApiKey)) request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", options.ApiKey);
            using var cancellation = new CancellationTokenSource(TimeSpan.FromSeconds(options.TimeoutSeconds));
            using var response = await HttpClient.SendAsync(request, cancellation.Token);
            response.EnsureSuccessStatusCode();

            Console.WriteLine($"[RESULTS API] Enviado com sucesso: {(int)response.StatusCode}");

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
        if (!File.Exists(path)) 
        
        {
            Console.WriteLine($"[RESULTS API] appsettings nao existe");
            return new ResultsApiOptions(null, null, defaultTimeoutSeconds, false,null);
        
        }
        
        try
        {
            Console.WriteLine($"[RESULTS API] appsettings existe");

            using var document = JsonDocument.Parse(File.ReadAllText(path));
            if (!document.RootElement.TryGetProperty("ResultsApi", out var section)) {
                Console.WriteLine($"[RESULTS API] appsettings sem results api");

                return new ResultsApiOptions(null, null, defaultTimeoutSeconds, false, null);
            }
            var endpointText = section.TryGetProperty("Endpoint", out var endpointValue) ? endpointValue.GetString() : null;
            var endpoint = Uri.TryCreate(endpointText, UriKind.Absolute, out var parsed) && (parsed.Scheme == Uri.UriSchemeHttp || parsed.Scheme == Uri.UriSchemeHttps) ? parsed : null;
            var apiKey = section.TryGetProperty("ApiKey", out var apiKeyValue) ? apiKeyValue.GetString() : null;
            var timeout = section.TryGetProperty("TimeoutSeconds", out var timeoutValue) && timeoutValue.TryGetInt32(out var configuredTimeout) && configuredTimeout > 0 ? configuredTimeout : defaultTimeoutSeconds;
            var fail = section.TryGetProperty("FailTestWhenUnavailable", out var failValue) && failValue.ValueKind is JsonValueKind.True;
            var competitor = section.TryGetProperty("Competitor", out var compValue) ? compValue.GetString() : "";
            return new ResultsApiOptions(endpoint, apiKey, timeout, fail, competitor);
        }
        catch (JsonException)
        {
            return new ResultsApiOptions(null, null, defaultTimeoutSeconds, false, null);
        }
    }

    private sealed record ResultsApiOptions(Uri? Endpoint, string? ApiKey, int TimeoutSeconds, bool FailTestWhenUnavailable, string? Competitor);
}
