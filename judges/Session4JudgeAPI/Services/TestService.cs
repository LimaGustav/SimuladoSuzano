using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;
using Session4JudgeAPI.Contexts;
using Session4JudgeAPI.DTOs;

namespace Session4JudgeAPI.Services;

public class TestService
{
    private readonly NortransTtContext _context;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly TestResultService _resultService;

    private static readonly JsonSerializerOptions _jsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        NumberHandling = JsonNumberHandling.AllowReadingFromString
    };

    public TestService(
        NortransTtContext context,
        IHttpClientFactory httpClientFactory,
        TestResultService resultService)
    {
        _context = context;
        _httpClientFactory = httpClientFactory;
        _resultService = resultService;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 1 — GET /health
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestHealth()
    {
        const string name = "GET /health";
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.GetAsync("/health");

            if (!response.IsSuccessStatusCode)
                return Fail(name, "/health", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var body = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(body);

            if (!doc.RootElement.TryGetProperty("status", out var statusProp))
                return Fail(name, "/health", null, null, "Response body does not contain 'status' field.");

            if (!statusProp.GetString()!.Equals("ok", StringComparison.OrdinalIgnoreCase))
                return Fail(name, "/health", null, null,
                    $"Expected status='ok' but got '{statusProp.GetString()}'");

            return Pass(name, "/health", "Health check passed.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/health", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 2 — GET /branches
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestBranches()
    {
        const string name = "GET /branches";
        try
        {
            var expected = await _context.Branches
                .OrderBy(b => b.Id)
                .ToListAsync();

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.GetAsync("/branches");

            if (!response.IsSuccessStatusCode)
                return Fail(name, "/branches", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<List<BranchDto>>(_jsonOptions);

            if (actual is null)
                return Fail(name, "/branches", null, null, "Response body is null or not a valid JSON array.");

            if (actual.Count != expected.Count)
                return Fail(name, "/branches", null, null,
                    $"Expected {expected.Count} branches but got {actual.Count}.");

            for (int i = 0; i < expected.Count; i++)
            {
                var e = expected[i];
                var a = actual.FirstOrDefault(x => x.Id == e.Id);
                if (a is null)
                    return Fail(name, "/branches", null, null, $"Branch id={e.Id} not found in response.");

                if (!CompareBranch(e, a, out var diff))
                    return Fail(name, "/branches", null, null, $"Branch id={e.Id} mismatch: {diff}");
            }

            return Pass(name, "/branches", $"All {expected.Count} branches match database.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/branches", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 3 — GET /branches/:id
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestBranchById()
    {
        const string name = "GET /branches/{id}";
        try
        {
            var branch = await _context.Branches.FirstOrDefaultAsync();
            if (branch is null)
                return Fail(name, "/branches/{id}", null, null, "No branches found in database to test with.");

            var client = _httpClientFactory.CreateClient("CompetitorApi");

            // 200 case
            var response = await client.GetAsync($"/branches/{branch.Id}");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/branches/{branch.Id}", 200, (int)response.StatusCode,
                    $"Expected 200 for existing branch but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<BranchDto>(_jsonOptions);
            if (actual is null)
                return Fail(name, $"/branches/{branch.Id}", null, null, "Response body is null.");
            if (!CompareBranch(branch, actual, out var diff))
                return Fail(name, $"/branches/{branch.Id}", null, null,
                    $"Branch id={branch.Id} mismatch: {diff}");

            // 404 case
            var notFound = await client.GetAsync("/branches/999999999");
            if (notFound.StatusCode != HttpStatusCode.NotFound)
                return Fail(name, "/branches/999999999", 404, (int)notFound.StatusCode,
                    $"Expected 404 for non-existent id but received {(int)notFound.StatusCode}");

            return Pass(name, "/branches/{id}", "Branch by id: 200 and 404 both correct.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/branches/{id}", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 4 — GET /consignees
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestConsignees()
    {
        const string name = "GET /consignees";
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            // 4a: No filters
            {
                var expected = await _context.Consignees.ToListAsync();
                var response = await client.GetAsync("/consignees");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/consignees", 200, (int)response.StatusCode,
                        $"Expected 200 but received {(int)response.StatusCode}");

                var actual = await response.Content.ReadFromJsonAsync<List<ConsigneeDto>>(_jsonOptions);
                if (actual is null)
                    return Fail(name, "/consignees", null, null, "Null response.");
                if (actual.Count != expected.Count)
                    return Fail(name, "/consignees", null, null,
                        $"Expected {expected.Count} consignees but got {actual.Count}.");
            }

            // 4b: ?active=true
            {
                var expected = await _context.Consignees.Where(c => c.Active).ToListAsync();
                var response = await client.GetAsync("/consignees?active=true");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/consignees?active=true", 200, (int)response.StatusCode,
                        $"Filter active=true: Expected 200 but received {(int)response.StatusCode}");

                var actual = await response.Content.ReadFromJsonAsync<List<ConsigneeDto>>(_jsonOptions);
                if (actual is null || actual.Any(a => !a.Active))
                    return Fail(name, "/consignees?active=true", null, null,
                        "Filter active=true returned inactive consignees.");
                if (actual.Count != expected.Count)
                    return Fail(name, "/consignees?active=true", null, null,
                        $"Filter active=true: Expected {expected.Count} but got {actual.Count}.");
            }

            // 4c: ?country=CR
            {
                var expected = await _context.Consignees.Where(c => c.CountryCode == "CR").ToListAsync();
                var response = await client.GetAsync("/consignees?country=CR");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/consignees?country=CR", 200, (int)response.StatusCode,
                        $"Filter country=CR: Expected 200 but received {(int)response.StatusCode}");

                var actual = await response.Content.ReadFromJsonAsync<List<ConsigneeDto>>(_jsonOptions);
                if (actual is null || actual.Any(a => !a.CountryCode.Equals("CR", StringComparison.OrdinalIgnoreCase)))
                    return Fail(name, "/consignees?country=CR", null, null,
                        "Filter country=CR returned consignees with different country.");
                if (actual.Count != expected.Count)
                    return Fail(name, "/consignees?country=CR", null, null,
                        $"Filter country=CR: Expected {expected.Count} but got {actual.Count}.");
            }

            // 4d: ?active=true&country=CR
            {
                var expected = await _context.Consignees
                    .Where(c => c.Active && c.CountryCode == "CR").ToListAsync();
                var response = await client.GetAsync("/consignees?active=true&country=CR");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/consignees?active=true&country=CR", 200, (int)response.StatusCode,
                        $"Combined filters: Expected 200 but received {(int)response.StatusCode}");

                var actual = await response.Content.ReadFromJsonAsync<List<ConsigneeDto>>(_jsonOptions);
                if (actual is null)
                    return Fail(name, "/consignees?active=true&country=CR", null, null, "Null response.");
                if (actual.Count != expected.Count)
                    return Fail(name, "/consignees?active=true&country=CR", null, null,
                        $"Combined filters: Expected {expected.Count} but got {actual.Count}.");
            }

            return Pass(name, "/consignees", "All consignee filter combinations passed.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/consignees", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 5 — GET /consignees/:id
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestConsigneeById()
    {
        const string name = "GET /consignees/{id}";
        try
        {
            var consignee = await _context.Consignees.FirstOrDefaultAsync();
            if (consignee is null)
                return Fail(name, "/consignees/{id}", null, null, "No consignees in database.");

            var client = _httpClientFactory.CreateClient("CompetitorApi");

            var response = await client.GetAsync($"/consignees/{consignee.Id}");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/consignees/{consignee.Id}", 200, (int)response.StatusCode,
                    $"Expected 200 for existing consignee but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<ConsigneeDto>(_jsonOptions);
            if (actual is null)
                return Fail(name, $"/consignees/{consignee.Id}", null, null, "Response body is null.");
            if (!CompareConsignee(consignee, actual, out var diff))
                return Fail(name, $"/consignees/{consignee.Id}", null, null,
                    $"Consignee id={consignee.Id} mismatch: {diff}");

            var notFound = await client.GetAsync("/consignees/999999999");
            if (notFound.StatusCode != HttpStatusCode.NotFound)
                return Fail(name, "/consignees/999999999", 404, (int)notFound.StatusCode,
                    $"Expected 404 for non-existent id but received {(int)notFound.StatusCode}");

            return Pass(name, "/consignees/{id}", "Consignee by id: 200 and 404 correct.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/consignees/{id}", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 6 — GET /shipments
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestShipments()
    {
        const string name = "GET /shipments";
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            // No filters
            {
                var expected = await _context.Shipments.ToListAsync();
                var response = await client.GetAsync("/shipments");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/shipments", 200, (int)response.StatusCode,
                        $"Expected 200 but received {(int)response.StatusCode}");

                var actual = await response.Content.ReadFromJsonAsync<List<ShipmentDto>>(_jsonOptions);
                if (actual is null)
                    return Fail(name, "/shipments", null, null, "Null response.");
                if (actual.Count != expected.Count)
                    return Fail(name, "/shipments", null, null,
                        $"Expected {expected.Count} shipments but got {actual.Count}.");
            }

            // ?status=booked
            {
                var expected = await _context.Shipments.Where(s => s.Status == "booked").ToListAsync();
                var response = await client.GetAsync("/shipments?status=booked");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/shipments?status=booked", 200, (int)response.StatusCode,
                        $"Filter status=booked: Expected 200 but received {(int)response.StatusCode}");

                var actual = await response.Content.ReadFromJsonAsync<List<ShipmentDto>>(_jsonOptions);
                if (actual is null)
                    return Fail(name, "/shipments?status=booked", null, null, "Null response.");
                if (actual.Count != expected.Count)
                    return Fail(name, "/shipments?status=booked", null, null,
                        $"Filter status=booked: Expected {expected.Count} but got {actual.Count}.");
                if (actual.Any(a => !a.Status.Equals("booked", StringComparison.OrdinalIgnoreCase)))
                    return Fail(name, "/shipments?status=booked", null, null,
                        "Filter status=booked returned shipments with different status.");
            }

            // ?status=unknown → 400
            {
                var response = await client.GetAsync("/shipments?status=unknown_status_xyz");
                if (response.StatusCode != HttpStatusCode.BadRequest)
                    return Fail(name, "/shipments?status=unknown", 400, (int)response.StatusCode,
                        $"Expected 400 for unknown status but received {(int)response.StatusCode}");
            }

            // ?branch=CAL (pick first branch code available)
            {
                var branch = await _context.Branches.FirstOrDefaultAsync();
                if (branch is not null)
                {
                    var expected = await _context.Shipments
                        .Where(s => s.Branch.Code == branch.Code).ToListAsync();
                    var response = await client.GetAsync($"/shipments?branch={branch.Code}");
                    if (!response.IsSuccessStatusCode)
                        return Fail(name, $"/shipments?branch={branch.Code}", 200, (int)response.StatusCode,
                            $"Filter branch={branch.Code}: Expected 200 but received {(int)response.StatusCode}");

                    var actual = await response.Content.ReadFromJsonAsync<List<ShipmentDto>>(_jsonOptions);
                    if (actual is null)
                        return Fail(name, $"/shipments?branch={branch.Code}", null, null, "Null response.");
                    if (actual.Count != expected.Count)
                        return Fail(name, $"/shipments?branch={branch.Code}", null, null,
                            $"Filter branch={branch.Code}: Expected {expected.Count} but got {actual.Count}.");
                }
            }

            return Pass(name, "/shipments", "All shipment filter combinations passed.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 7 — GET /shipments/:id
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestShipmentById()
    {
        const string name = "GET /shipments/{id}";
        try
        {
            var shipment = await _context.Shipments.FirstOrDefaultAsync();
            if (shipment is null)
                return Fail(name, "/shipments/{id}", null, null, "No shipments in database.");

            var client = _httpClientFactory.CreateClient("CompetitorApi");

            var response = await client.GetAsync($"/shipments/{shipment.Id}");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/shipments/{shipment.Id}", 200, (int)response.StatusCode,
                    $"Expected 200 for existing shipment but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<ShipmentDto>(_jsonOptions);
            if (actual is null)
                return Fail(name, $"/shipments/{shipment.Id}", null, null, "Response body is null.");
            if (!CompareShipment(shipment, actual, out var diff))
                return Fail(name, $"/shipments/{shipment.Id}", null, null,
                    $"Shipment id={shipment.Id} mismatch: {diff}");

            var notFound = await client.GetAsync("/shipments/999999999");
            if (notFound.StatusCode != HttpStatusCode.NotFound)
                return Fail(name, "/shipments/999999999", 404, (int)notFound.StatusCode,
                    $"Expected 404 for non-existent id but received {(int)notFound.StatusCode}");

            return Pass(name, "/shipments/{id}", "Shipment by id: 200 and 404 correct.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments/{id}", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 8 — POST /consignees
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestCreateConsignee()
    {
        const string name = "POST /consignees";
        var testData = GenerateUniqueConsignee();
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.PostAsJsonAsync("/consignees", testData, _jsonOptions);

            if (response.StatusCode != HttpStatusCode.Created)
                return Fail(name, "/consignees", 201, (int)response.StatusCode,
                    $"Expected 201 but received {(int)response.StatusCode}");

            var created = await _context.Consignees
                .FirstOrDefaultAsync(x => x.TaxId == testData.TaxId);

            if (created is null)
                return Fail(name, "/consignees", null, null,
                    "API returned 201 but record was not created in database.");

            if (created.LegalName != testData.LegalName)
                return Fail(name, "/consignees", null, null,
                    $"legal_name mismatch: expected '{testData.LegalName}' got '{created.LegalName}'");
            if (created.CountryCode != testData.CountryCode)
                return Fail(name, "/consignees", null, null,
                    $"country_code mismatch: expected '{testData.CountryCode}' got '{created.CountryCode}'");
            if (created.Email != testData.Email)
                return Fail(name, "/consignees", null, null,
                    $"email mismatch: expected '{testData.Email}' got '{created.Email}'");
            if (created.Active != testData.Active)
                return Fail(name, "/consignees", null, null,
                    $"active mismatch: expected {testData.Active} got {created.Active}");
            if (created.CreatedAt == default)
                return Fail(name, "/consignees", null, null, "created_at is not set.");

            _context.Consignees.Remove(created);
            await _context.SaveChangesAsync();

            return Pass(name, "/consignees", "Consignee created correctly and cleaned up.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/consignees", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 9 — POST /shipments
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestCreateShipment()
    {
        const string name = "POST /shipments";
        try
        {
            var consignee = await _context.Consignees.FirstAsync();
            var branch = await _context.Branches.FirstAsync();
            var testData = GenerateUniqueShipment(consignee.Id, branch.Id);

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.PostAsJsonAsync("/shipments", testData, _jsonOptions);

            if (response.StatusCode != HttpStatusCode.Created)
                return Fail(name, "/shipments", 201, (int)response.StatusCode,
                    $"Expected 201 but received {(int)response.StatusCode}");

            var created = await _context.Shipments
                .FirstOrDefaultAsync(s => s.Reference == testData.Reference);

            if (created is null)
                return Fail(name, "/shipments", null, null,
                    "API returned 201 but shipment was not found in database.");

            if (created.BillOfLading != testData.BillOfLading)
                return Fail(name, "/shipments", null, null,
                    $"bill_of_lading mismatch: expected '{testData.BillOfLading}' got '{created.BillOfLading}'");
            if (created.ConsigneeId != testData.ConsigneeId)
                return Fail(name, "/shipments", null, null,
                    $"consignee_id mismatch: expected {testData.ConsigneeId} got {created.ConsigneeId}");
            if (created.BranchId != testData.BranchId)
                return Fail(name, "/shipments", null, null,
                    $"branch_id mismatch: expected {testData.BranchId} got {created.BranchId}");
            if (!created.Mode.Equals(testData.Mode, StringComparison.OrdinalIgnoreCase))
                return Fail(name, "/shipments", null, null,
                    $"mode mismatch: expected '{testData.Mode}' got '{created.Mode}'");
            if (!created.Status.Equals("booked", StringComparison.OrdinalIgnoreCase))
                return Fail(name, "/shipments", null, null,
                    $"status must be 'booked' for new shipments, got '{created.Status}'");

            _context.Shipments.Remove(created);
            await _context.SaveChangesAsync();

            return Pass(name, "/shipments", "Shipment created correctly with status=booked and cleaned up.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 10 — GET /shipments/:id/containers
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestGetContainers()
    {
        const string name = "GET /shipments/{id}/containers";
        try
        {
            var shipment = await _context.Shipments
                .Include(s => s.Containers)
                .FirstOrDefaultAsync(s => s.Containers.Any());

            if (shipment is null)
                return Fail(name, "/shipments/{id}/containers", null, null,
                    "No shipment with containers found in database.");

            var expected = shipment.Containers.OrderBy(c => c.ContainerNo).ToList();
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            var response = await client.GetAsync($"/shipments/{shipment.Id}/containers");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/shipments/{shipment.Id}/containers", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<List<ContainerDto>>(_jsonOptions);
            if (actual is null)
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null, "Null response.");

            if (actual.Count != expected.Count)
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                    $"Expected {expected.Count} containers but got {actual.Count}.");

            // Verify ordering by container_no ASC
            for (int i = 0; i < actual.Count; i++)
            {
                if (!actual[i].ContainerNo.Equals(expected[i].ContainerNo, StringComparison.OrdinalIgnoreCase))
                    return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                        $"Ordering mismatch at position {i}: expected '{expected[i].ContainerNo}' got '{actual[i].ContainerNo}'");
            }

            // 404 for non-existent shipment
            var notFound = await client.GetAsync("/shipments/999999999/containers");
            if (notFound.StatusCode != HttpStatusCode.NotFound)
                return Fail(name, "/shipments/999999999/containers", 404, (int)notFound.StatusCode,
                    $"Expected 404 for non-existent shipment but received {(int)notFound.StatusCode}");

            return Pass(name, "/shipments/{id}/containers",
                $"Containers returned in correct order. 404 also correct.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments/{id}/containers", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 11 — POST /shipments/:id/containers
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestCreateContainer()
    {
        const string name = "POST /shipments/{id}/containers";
        try
        {
            var shipment = await _context.Shipments.FirstAsync();
            var testData = GenerateUniqueContainer();

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.PostAsJsonAsync(
                $"/shipments/{shipment.Id}/containers", testData, _jsonOptions);

            if (response.StatusCode != HttpStatusCode.Created)
                return Fail(name, $"/shipments/{shipment.Id}/containers", 201, (int)response.StatusCode,
                    $"Expected 201 but received {(int)response.StatusCode}");

            var created = await _context.Containers
                .FirstOrDefaultAsync(c => c.ContainerNo == testData.ContainerNo);

            if (created is null)
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                    "API returned 201 but container was not found in database.");

            if (created.ShipmentId != shipment.Id)
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                    $"shipment_id mismatch: expected {shipment.Id} got {created.ShipmentId}");
            if (!created.SizeType.Equals(testData.SizeType, StringComparison.OrdinalIgnoreCase))
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                    $"size_type mismatch: expected '{testData.SizeType}' got '{created.SizeType}'");
            if (created.Teu != testData.Teu)
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                    $"teu mismatch: expected {testData.Teu} got {created.Teu}");
            if (!created.SealNo.Equals(testData.SealNo, StringComparison.OrdinalIgnoreCase))
                return Fail(name, $"/shipments/{shipment.Id}/containers", null, null,
                    $"seal_no mismatch: expected '{testData.SealNo}' got '{created.SealNo}'");

            _context.Containers.Remove(created);
            await _context.SaveChangesAsync();

            return Pass(name, $"/shipments/{shipment.Id}/containers",
                "Container created correctly and cleaned up.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments/{id}/containers", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 12 — POST /containers/:id/events
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestCreateEvent()
    {
        const string name = "POST /containers/{id}/events";
        try
        {
            // Find a container that doesn't yet have discharged_at or gated_out_at set
            var container = await _context.Containers
                .FirstOrDefaultAsync(c => c.DischargedAt == null && c.GatedOutAt == null);

            if (container is null)
                return Fail(name, "/containers/{id}/events", null, null,
                    "No suitable container found (need one without discharged_at/gated_out_at).");

            var occurredAt = DateTimeOffset.UtcNow.AddHours(-2);
            var testData = new CreateEventDto
            {
                EventType = "discharged",
                OccurredAt = occurredAt,
                Location = "TEST-LOCATION",
                Note = "Test event note"
            };

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.PostAsJsonAsync(
                $"/containers/{container.Id}/events", testData, _jsonOptions);

            if (response.StatusCode != HttpStatusCode.Created)
                return Fail(name, $"/containers/{container.Id}/events", 201, (int)response.StatusCode,
                    $"Expected 201 but received {(int)response.StatusCode}");

            // Reload container + events from DB
            await _context.Entry(container).ReloadAsync();
            var createdEvent = await _context.Events
                .OrderByDescending(e => e.Id)
                .FirstOrDefaultAsync(e => e.ContainerId == container.Id && e.EventType == "discharged");

            if (createdEvent is null)
                return Fail(name, $"/containers/{container.Id}/events", null, null,
                    "API returned 201 but event was not found in database.");

            if (!createdEvent.EventType.Equals(testData.EventType, StringComparison.OrdinalIgnoreCase))
                return Fail(name, $"/containers/{container.Id}/events", null, null,
                    $"event_type mismatch: expected '{testData.EventType}' got '{createdEvent.EventType}'");

            if (!createdEvent.Location.Equals(testData.Location, StringComparison.OrdinalIgnoreCase))
                return Fail(name, $"/containers/{container.Id}/events", null, null,
                    $"location mismatch: expected '{testData.Location}' got '{createdEvent.Location}'");

            // Verify side effect: discharged_at must be set on container
            if (container.DischargedAt is null)
                return Fail(name, $"/containers/{container.Id}/events", null, null,
                    "Side effect not applied: container.discharged_at should be set after 'discharged' event.");

            // Cleanup event and restore container state
            _context.Events.Remove(createdEvent);
            container.DischargedAt = null;
            await _context.SaveChangesAsync();

            return Pass(name, $"/containers/{container.Id}/events",
                "Event created correctly. discharged_at side effect verified and cleaned up.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/containers/{id}/events", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 13 — GET /containers/:id/events
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestGetEvents()
    {
        const string name = "GET /containers/{id}/events";
        try
        {
            var container = await _context.Containers
                .Include(c => c.Events)
                .FirstOrDefaultAsync(c => c.Events.Any());

            if (container is null)
                return Fail(name, "/containers/{id}/events", null, null,
                    "No container with events found in database.");

            var expected = container.Events.OrderByDescending(e => e.OccurredAt).ToList();
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            var response = await client.GetAsync($"/containers/{container.Id}/events");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/containers/{container.Id}/events", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<List<EventDto>>(_jsonOptions);
            if (actual is null)
                return Fail(name, $"/containers/{container.Id}/events", null, null, "Null response.");

            if (actual.Count != expected.Count)
                return Fail(name, $"/containers/{container.Id}/events", null, null,
                    $"Expected {expected.Count} events but got {actual.Count}.");

            // Verify ordering by occurred_at DESC
            for (int i = 0; i < actual.Count; i++)
            {
                if (actual[i].OccurredAt != expected[i].OccurredAt)
                    return Fail(name, $"/containers/{container.Id}/events", null, null,
                        $"Ordering mismatch at position {i}: expected occurred_at='{expected[i].OccurredAt:O}' got '{actual[i].OccurredAt:O}'");
            }

            return Pass(name, $"/containers/{container.Id}/events",
                $"Events returned in correct order (occurred_at DESC).");
        }
        catch (Exception ex)
        {
            return Fail(name, "/containers/{id}/events", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 14 — PATCH /shipments/:id/status
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestPatchStatus()
    {
        const string name = "PATCH /shipments/{id}/status";
        try
        {
            // Find a shipment that can be advanced (not 'closed')
            var shipment = await _context.Shipments
                .FirstOrDefaultAsync(s => s.Status == "booked");

            if (shipment is null)
                return Fail(name, "/shipments/{id}/status", null, null,
                    "No shipment with status='booked' found.");

            var originalStatus = shipment.Status;
            var nextStatus = GetNextStatus(originalStatus);

            if (nextStatus is null)
                return Fail(name, "/shipments/{id}/status", null, null,
                    $"Cannot advance status from '{originalStatus}'.");

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var patchData = new PatchStatusDto { Status = nextStatus };
            var response = await client.PatchAsJsonAsync(
                $"/shipments/{shipment.Id}/status", patchData, _jsonOptions);

            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/shipments/{shipment.Id}/status", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            // Verify in database
            await _context.Entry(shipment).ReloadAsync();
            if (!shipment.Status.Equals(nextStatus, StringComparison.OrdinalIgnoreCase))
                return Fail(name, $"/shipments/{shipment.Id}/status", null, null,
                    $"Status not updated in database: expected '{nextStatus}' got '{shipment.Status}'");

            // Restore original status directly via DB (no HTTP call for rollback)
            shipment.Status = originalStatus;
            await _context.SaveChangesAsync();

            return Pass(name, $"/shipments/{shipment.Id}/status",
                $"Status updated from '{originalStatus}' to '{nextStatus}' and restored.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments/{id}/status", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 15 — GET /shipments/search
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestSearch()
    {
        const string name = "GET /shipments/search";
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            // Missing q → 400
            var missingQ = await client.GetAsync("/shipments/search");
            if (missingQ.StatusCode != HttpStatusCode.BadRequest)
                return Fail(name, "/shipments/search", 400, (int)missingQ.StatusCode,
                    $"Expected 400 for missing q but received {(int)missingQ.StatusCode}");

            // Empty q → 400
            var emptyQ = await client.GetAsync("/shipments/search?q=");
            if (emptyQ.StatusCode != HttpStatusCode.BadRequest)
                return Fail(name, "/shipments/search?q=", 400, (int)emptyQ.StatusCode,
                    $"Expected 400 for empty q but received {(int)emptyQ.StatusCode}");

            // Pick a term from first shipment reference
            var firstShipment = await _context.Shipments
                .Include(s => s.Consignee)
                .FirstOrDefaultAsync();

            if (firstShipment is null)
                return Fail(name, "/shipments/search", null, null, "No shipments in database.");

            var q = firstShipment.Reference[..Math.Min(3, firstShipment.Reference.Length)];
            var expected = await _context.Shipments
                .Include(s => s.Consignee)
                .Where(s => EF.Functions.Like(s.Reference, $"%{q}%")
                         || EF.Functions.Like(s.BillOfLading, $"%{q}%")
                         || EF.Functions.Like(s.Consignee.LegalName, $"%{q}%"))
                .OrderBy(s => s.Reference)
                .ToListAsync();

            var response = await client.GetAsync($"/shipments/search?q={Uri.EscapeDataString(q)}");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/shipments/search?q={q}", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var actual = await response.Content.ReadFromJsonAsync<List<ShipmentDto>>(_jsonOptions);
            if (actual is null)
                return Fail(name, $"/shipments/search?q={q}", null, null, "Null response.");

            if (actual.Count != expected.Count)
                return Fail(name, $"/shipments/search?q={q}", null, null,
                    $"Expected {expected.Count} results but got {actual.Count}.");

            // Verify ordering by reference ASC
            for (int i = 0; i < actual.Count; i++)
            {
                if (!actual[i].Reference.Equals(expected[i].Reference, StringComparison.OrdinalIgnoreCase))
                    return Fail(name, $"/shipments/search?q={q}", null, null,
                        $"Ordering mismatch at position {i}: expected '{expected[i].Reference}' got '{actual[i].Reference}'");
            }

            return Pass(name, "/shipments/search",
                $"Search with q='{q}' returned {actual.Count} results in correct order.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/shipments/search", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 16 — GET /consignees/:id/summary
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestConsigneeSummary()
    {
        const string name = "GET /consignees/{id}/summary";
        try
        {
            var consignee = await _context.Consignees
                .Include(c => c.Shipments)
                    .ThenInclude(s => s.Containers)
                .FirstOrDefaultAsync();

            if (consignee is null)
                return Fail(name, "/consignees/{id}/summary", null, null, "No consignees in database.");

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.GetAsync($"/consignees/{consignee.Id}/summary");

            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/consignees/{consignee.Id}/summary", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            using var doc = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
            var root = doc.RootElement;

            // consignee_id
            if (!root.TryGetProperty("consignee_id", out var cidProp) || cidProp.GetInt32() != consignee.Id)
                return Fail(name, $"/consignees/{consignee.Id}/summary", null, null,
                    "consignee_id missing or incorrect.");

            // shipments_by_status — all 5 statuses must be present
            if (!root.TryGetProperty("shipments_by_status", out var byStatus))
                return Fail(name, $"/consignees/{consignee.Id}/summary", null, null,
                    "shipments_by_status missing.");

            var statuses = new[] { "booked", "in_transit", "arrived", "cleared", "closed" };
            foreach (var s in statuses)
            {
                if (!byStatus.TryGetProperty(s, out _))
                    return Fail(name, $"/consignees/{consignee.Id}/summary", null, null,
                        $"shipments_by_status.{s} missing.");
            }

            // Calculate expected total_teu
            var expectedTeu = consignee.Shipments
                .SelectMany(s => s.Containers)
                .Sum(c => c.Teu);

            if (root.TryGetProperty("total_teu", out var teuProp))
            {
                var actualTeu = teuProp.GetDecimal();
                if (actualTeu != expectedTeu)
                    return Fail(name, $"/consignees/{consignee.Id}/summary", null, null,
                        $"total_teu mismatch: expected {expectedTeu} got {actualTeu}");
            }
            else
            {
                return Fail(name, $"/consignees/{consignee.Id}/summary", null, null,
                    "total_teu field missing.");
            }

            return Pass(name, $"/consignees/{consignee.Id}/summary",
                "Consignee summary fields validated.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/consignees/{id}/summary", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 17 — GET /reports/dwell
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestDwell()
    {
        const string name = "GET /reports/dwell";
        try
        {
            var now = DateTimeOffset.UtcNow;
            var expectedContainers = await _context.Containers
                .Where(c => c.DischargedAt != null && c.GatedOutAt == null)
                .ToListAsync();

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.GetAsync("/reports/dwell");

            if (!response.IsSuccessStatusCode)
                return Fail(name, "/reports/dwell", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var body = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(body);

            if (doc.RootElement.ValueKind != JsonValueKind.Array)
                return Fail(name, "/reports/dwell", null, null, "Response is not a JSON array.");

            var actualCount = doc.RootElement.GetArrayLength();
            if (actualCount != expectedContainers.Count)
                return Fail(name, "/reports/dwell", null, null,
                    $"Expected {expectedContainers.Count} dwell items but got {actualCount}.");

            // Verify descending order by dwell_days
            int? prevDwell = null;
            foreach (var item in doc.RootElement.EnumerateArray())
            {
                if (item.TryGetProperty("dwell_days", out var dwellProp))
                {
                    var dwell = dwellProp.GetInt32();
                    if (prevDwell.HasValue && dwell > prevDwell.Value)
                        return Fail(name, "/reports/dwell", null, null,
                            $"Ordering is not dwell_days DESC: found {dwell} after {prevDwell.Value}");
                    prevDwell = dwell;
                }
                else
                {
                    return Fail(name, "/reports/dwell", null, null, "dwell_days field missing in item.");
                }
            }

            return Pass(name, "/reports/dwell",
                $"Dwell report: {actualCount} containers, ordered by dwell_days DESC.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/reports/dwell", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 18 — GET /reports/transit-times
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestTransitTimes()
    {
        const string name = "GET /reports/transit-times";
        try
        {
            var expectedBranches = await _context.Branches
                .OrderBy(b => b.Code)
                .ToListAsync();

            var client = _httpClientFactory.CreateClient("CompetitorApi");
            var response = await client.GetAsync("/reports/transit-times");

            if (!response.IsSuccessStatusCode)
                return Fail(name, "/reports/transit-times", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var body = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(body);

            if (doc.RootElement.ValueKind != JsonValueKind.Array)
                return Fail(name, "/reports/transit-times", null, null, "Response is not a JSON array.");

            var actualCount = doc.RootElement.GetArrayLength();
            if (actualCount != expectedBranches.Count)
                return Fail(name, "/reports/transit-times", null, null,
                    $"Expected {expectedBranches.Count} rows (one per branch) but got {actualCount}.");

            // Verify ordering by branch_code ASC
            string? prevCode = null;
            foreach (var item in doc.RootElement.EnumerateArray())
            {
                if (!item.TryGetProperty("branch_code", out var codeProp))
                    return Fail(name, "/reports/transit-times", null, null,
                        "branch_code field missing in item.");

                var code = codeProp.GetString() ?? "";
                if (prevCode is not null && string.Compare(code, prevCode, StringComparison.OrdinalIgnoreCase) < 0)
                    return Fail(name, "/reports/transit-times", null, null,
                        $"Ordering not branch_code ASC: '{code}' came after '{prevCode}'.");
                prevCode = code;
            }

            return Pass(name, "/reports/transit-times",
                $"Transit times: {actualCount} rows, one per branch, ordered by branch_code ASC.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/reports/transit-times", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 19 — GET /reports/top-consignees
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestTopConsignees()
    {
        const string name = "GET /reports/top-consignees";
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            // No limit → default 5
            {
                var response = await client.GetAsync("/reports/top-consignees");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/reports/top-consignees", 200, (int)response.StatusCode,
                        $"No limit: Expected 200 but received {(int)response.StatusCode}");

                var body = await response.Content.ReadAsStringAsync();
                using var doc = JsonDocument.Parse(body);
                if (doc.RootElement.GetArrayLength() > 5)
                    return Fail(name, "/reports/top-consignees", null, null,
                        $"Without limit, expected at most 5 rows but got {doc.RootElement.GetArrayLength()}.");
            }

            // limit=3
            {
                var response = await client.GetAsync("/reports/top-consignees?limit=3");
                if (!response.IsSuccessStatusCode)
                    return Fail(name, "/reports/top-consignees?limit=3", 200, (int)response.StatusCode,
                        $"limit=3: Expected 200 but received {(int)response.StatusCode}");

                var body = await response.Content.ReadAsStringAsync();
                using var doc = JsonDocument.Parse(body);
                if (doc.RootElement.GetArrayLength() > 3)
                    return Fail(name, "/reports/top-consignees?limit=3", null, null,
                        $"Expected at most 3 rows but got {doc.RootElement.GetArrayLength()}.");

                // Verify ordering: shipment_count DESC, legal_name ASC on tie
                int? prevCount = null;
                string? prevName = null;
                foreach (var item in doc.RootElement.EnumerateArray())
                {
                    if (!item.TryGetProperty("shipment_count", out var countProp))
                        return Fail(name, "/reports/top-consignees?limit=3", null, null,
                            "shipment_count field missing.");

                    var cnt = countProp.GetInt32();
                    var name2 = item.TryGetProperty("legal_name", out var nameProp)
                        ? nameProp.GetString() ?? ""
                        : "";

                    if (prevCount.HasValue)
                    {
                        if (cnt > prevCount.Value)
                            return Fail(name, "/reports/top-consignees?limit=3", null, null,
                                $"Ordering not shipment_count DESC: {cnt} after {prevCount.Value}");
                        if (cnt == prevCount.Value && prevName is not null &&
                            string.Compare(name2, prevName, StringComparison.OrdinalIgnoreCase) < 0)
                            return Fail(name, "/reports/top-consignees?limit=3", null, null,
                                $"Tie-break not legal_name ASC: '{name2}' after '{prevName}'");
                    }
                    prevCount = cnt;
                    prevName = name2;
                }
            }

            // Invalid limit → 400
            {
                var response = await client.GetAsync("/reports/top-consignees?limit=0");
                if (response.StatusCode != HttpStatusCode.BadRequest)
                    return Fail(name, "/reports/top-consignees?limit=0", 400, (int)response.StatusCode,
                        $"Expected 400 for limit=0 but received {(int)response.StatusCode}");
            }

            // Invalid limit string → 400
            {
                var response = await client.GetAsync("/reports/top-consignees?limit=abc");
                if (response.StatusCode != HttpStatusCode.BadRequest)
                    return Fail(name, "/reports/top-consignees?limit=abc", 400, (int)response.StatusCode,
                        $"Expected 400 for limit=abc but received {(int)response.StatusCode}");
            }

            return Pass(name, "/reports/top-consignees",
                "Top consignees: ordering and limit validation all passed.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/reports/top-consignees", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Test 20 — GET /reports/monthly-volume
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<TestResult> TestMonthlyVolume()
    {
        const string name = "GET /reports/monthly-volume";
        try
        {
            var client = _httpClientFactory.CreateClient("CompetitorApi");

            // Missing year → 400
            {
                var r = await client.GetAsync("/reports/monthly-volume");
                if (r.StatusCode != HttpStatusCode.BadRequest)
                    return Fail(name, "/reports/monthly-volume", 400, (int)r.StatusCode,
                        $"Expected 400 for missing year but received {(int)r.StatusCode}");
            }

            // Invalid year → 400
            {
                var r = await client.GetAsync("/reports/monthly-volume?year=abc");
                if (r.StatusCode != HttpStatusCode.BadRequest)
                    return Fail(name, "/reports/monthly-volume?year=abc", 400, (int)r.StatusCode,
                        $"Expected 400 for year=abc but received {(int)r.StatusCode}");
            }

            // Valid year
            var year = DateTimeOffset.UtcNow.Year;
            var response = await client.GetAsync($"/reports/monthly-volume?year={year}");
            if (!response.IsSuccessStatusCode)
                return Fail(name, $"/reports/monthly-volume?year={year}", 200, (int)response.StatusCode,
                    $"Expected 200 but received {(int)response.StatusCode}");

            var body = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(body);

            if (doc.RootElement.ValueKind != JsonValueKind.Array)
                return Fail(name, $"/reports/monthly-volume?year={year}", null, null,
                    "Response is not a JSON array.");

            var count = doc.RootElement.GetArrayLength();
            if (count != 12)
                return Fail(name, $"/reports/monthly-volume?year={year}", null, null,
                    $"Expected exactly 12 monthly rows but got {count}.");

            // Verify months 1..12 in order
            int expectedMonth = 1;
            foreach (var item in doc.RootElement.EnumerateArray())
            {
                if (!item.TryGetProperty("month", out var monthProp))
                    return Fail(name, $"/reports/monthly-volume?year={year}", null, null,
                        "month field missing in item.");

                var month = monthProp.GetInt32();
                if (month != expectedMonth)
                    return Fail(name, $"/reports/monthly-volume?year={year}", null, null,
                        $"Expected month={expectedMonth} but got {month}.");

                if (!item.TryGetProperty("shipment_count", out _))
                    return Fail(name, $"/reports/monthly-volume?year={year}", null, null,
                        $"shipment_count missing in month {month}.");
    
                if (!item.TryGetProperty("teu", out _))
                    return Fail(name, $"/reports/monthly-volume?year={year}", null, null,
                        $"teu missing in month {month}.");

                expectedMonth++;
            }

            return Pass(name, $"/reports/monthly-volume?year={year}",
                $"Monthly volume for {year}: 12 months, fields and order validated.");
        }
        catch (Exception ex)
        {
            return Fail(name, "/reports/monthly-volume", null, null, ex.Message);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers — Pass / Fail
    // ─────────────────────────────────────────────────────────────────────────
    private TestResult Pass(string testName, string endpoint, string message)
    {
        var result = new TestResult
        {
            TestName = testName,
            Endpoint = endpoint,
            Passed = true,
            Message = message,
            ExecutedAt = DateTime.UtcNow
        };
        _resultService.Add(result);
        return result;
    }

    private TestResult Fail(
        string testName,
        string endpoint,
        int? expectedStatusCode,
        int? actualStatusCode,
        string message)
    {   
        var result = new TestResult
        {
            TestName = testName,
            Endpoint = endpoint,
            Passed = false,
            ExpectedStatusCode = expectedStatusCode,
            ActualStatusCode = actualStatusCode,
            Message = message,
            ExecutedAt = DateTime.UtcNow
        };
        _resultService.Add(result);
        return result;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers — Comparison
    // ─────────────────────────────────────────────────────────────────────────
    private static bool CompareBranch(Models.Branch e, BranchDto a, out string diff)
    {
        diff = "";
        if (e.Id != a.Id) { diff = $"id: {e.Id} vs {a.Id}"; return false; }
        if (!e.Code.Equals(a.Code, StringComparison.OrdinalIgnoreCase)) { diff = $"code: '{e.Code}' vs '{a.Code}'"; return false; }
        if (!e.Name.Equals(a.Name, StringComparison.OrdinalIgnoreCase)) { diff = $"name: '{e.Name}' vs '{a.Name}'"; return false; }
        if (!e.City.Equals(a.City, StringComparison.OrdinalIgnoreCase)) { diff = $"city: '{e.City}' vs '{a.City}'"; return false; }
        if (!e.Phone.Equals(a.Phone, StringComparison.OrdinalIgnoreCase)) { diff = $"phone: '{e.Phone}' vs '{a.Phone}'"; return false; }
        return true;
    }

    private static bool CompareConsignee(Models.Consignee e, ConsigneeDto a, out string diff)
    {
        diff = "";
        if (e.Id != a.Id) { diff = $"id: {e.Id} vs {a.Id}"; return false; }
        if (!e.LegalName.Equals(a.LegalName, StringComparison.OrdinalIgnoreCase)) { diff = $"legal_name: '{e.LegalName}' vs '{a.LegalName}'"; return false; }
        if (!e.TaxId.Equals(a.TaxId, StringComparison.OrdinalIgnoreCase)) { diff = $"tax_id: '{e.TaxId}' vs '{a.TaxId}'"; return false; }
        if (!e.CountryCode.Equals(a.CountryCode, StringComparison.OrdinalIgnoreCase)) { diff = $"country_code: '{e.CountryCode}' vs '{a.CountryCode}'"; return false; }
        if (!e.Email.Equals(a.Email, StringComparison.OrdinalIgnoreCase)) { diff = $"email: '{e.Email}' vs '{a.Email}'"; return false; }
        if (e.Active != a.Active) { diff = $"active: {e.Active} vs {a.Active}"; return false; }
        return true;
    }

    private static bool CompareShipment(Models.Shipment e, ShipmentDto a, out string diff)
    {
        diff = "";
        if (e.Id != a.Id) { diff = $"id: {e.Id} vs {a.Id}"; return false; }
        if (!e.Reference.Equals(a.Reference, StringComparison.OrdinalIgnoreCase)) { diff = $"reference: '{e.Reference}' vs '{a.Reference}'"; return false; }
        if (!e.BillOfLading.Equals(a.BillOfLading, StringComparison.OrdinalIgnoreCase)) { diff = $"bill_of_lading: '{e.BillOfLading}' vs '{a.BillOfLading}'"; return false; }
        if (e.ConsigneeId != a.ConsigneeId) { diff = $"consignee_id: {e.ConsigneeId} vs {a.ConsigneeId}"; return false; }
        if (e.BranchId != a.BranchId) { diff = $"branch_id: {e.BranchId} vs {a.BranchId}"; return false; }
        if (!e.Mode.Equals(a.Mode, StringComparison.OrdinalIgnoreCase)) { diff = $"mode: '{e.Mode}' vs '{a.Mode}'"; return false; }
        if (!e.Status.Equals(a.Status, StringComparison.OrdinalIgnoreCase)) { diff = $"status: '{e.Status}' vs '{a.Status}'"; return false; }
        return true;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers — Test data generators
    // ─────────────────────────────────────────────────────────────────────────
    private static CreateConsigneeDto GenerateUniqueConsignee()
    {
        var guid = Guid.NewGuid().ToString("N")[..8];
        var date = DateTime.UtcNow.ToString("yyyyMMdd");
        return new CreateConsigneeDto
        {
            LegalName = $"TEST COMPANY {guid.ToUpper()}",
            TaxId = $"TEST-{date}-{guid}",
            CountryCode = "BR",
            Email = $"test-{guid}@test.local",
            Active = true
        };
    }

    private static CreateShipmentDto GenerateUniqueShipment(int consigneeId, int branchId)
    {
        var guid = Guid.NewGuid().ToString("N")[..8];
        var date = DateTime.UtcNow.ToString("yyyyMMdd");
        return new CreateShipmentDto
        {
            Reference = $"TEST-SHIPMENT-{date}-{guid}",
            BillOfLading = $"TEST-BOL-{date}-{guid}",
            ConsigneeId = consigneeId,
            BranchId = branchId,
            Mode = "ocean",
            Etd = DateTimeOffset.UtcNow.Date,
            Eta = DateTimeOffset.UtcNow.Date.AddDays(7)
        };
    }

    private static CreateContainerDto GenerateUniqueContainer()
    {
        var guid = Guid.NewGuid().ToString("N")[..7].ToUpper();
        return new CreateContainerDto
        {
            ContainerNo = $"TEST{guid}",
            SizeType = "20GP",
            Teu = 1.0m,
            SealNo = $"SEAL{guid}"
        };
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers — Status progression
    // ─────────────────────────────────────────────────────────────────────────
    private static string? GetNextStatus(string current) => current switch
    {
        "booked" => "in_transit",
        "in_transit" => "arrived",
        "arrived" => "cleared",
        "cleared" => "closed",
        _ => null
    };
}
