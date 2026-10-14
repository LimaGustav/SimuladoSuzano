using Microsoft.AspNetCore.Mvc;
using Session4JudgeAPI.DTOs;
using Session4JudgeAPI.Services;

namespace Session4JudgeAPI.Controllers;

[ApiController]
[Route("test")]
public class TestController : ControllerBase
{
    private readonly TestService _testService;
    private readonly TestResultService _resultService;

    public TestController(TestService testService, TestResultService resultService)
    {
        _testService = testService;
        _resultService = resultService;
    }

    // ── Results history ──────────────────────────────────────────────────────

    /// <summary>Returns the history of all test results recorded so far.</summary>
    [HttpGet("results")]
    public IActionResult Results() => Ok(_resultService.GetAll());

    /// <summary>Clears the test result history.</summary>
    [HttpDelete("results")]
    public IActionResult ClearResults()
    {
        _resultService.Clear();
        return NoContent();
    }

    // ── Tier 1 — Reads ───────────────────────────────────────────────────────

    /// <summary>Test 1 — GET /health</summary>
    [HttpGet("health")]
    public async Task<IActionResult> TestHealth()
        => Ok(await _testService.TestHealth());

    /// <summary>Test 2 — GET /branches</summary>
    [HttpGet("branches")]
    public async Task<IActionResult> TestBranches()
        => Ok(await _testService.TestBranches());

    /// <summary>Test 3 — GET /branches/{id}</summary>
    [HttpGet("branches/{id:int}")]
    public async Task<IActionResult> TestBranchById()
        => Ok(await _testService.TestBranchById());

    /// <summary>Test 4 — GET /consignees (with filters)</summary>
    [HttpGet("consignees")]
    public async Task<IActionResult> TestConsignees()
        => Ok(await _testService.TestConsignees());

    /// <summary>Test 5 — GET /consignees/{id}</summary>
    [HttpGet("consignees/{id:int}")]
    public async Task<IActionResult> TestConsigneeById()
        => Ok(await _testService.TestConsigneeById());

    /// <summary>Test 6 — GET /shipments (with filters)</summary>
    [HttpGet("shipments")]
    public async Task<IActionResult> TestShipments()
        => Ok(await _testService.TestShipments());

    /// <summary>Test 7 — GET /shipments/{id}</summary>
    [HttpGet("shipments/{id:int}")]
    public async Task<IActionResult> TestShipmentById()
        => Ok(await _testService.TestShipmentById());

    // ── Tier 2 — Writes and Relationships ────────────────────────────────────

    /// <summary>Test 8 — POST /consignees</summary>
    [HttpPost("consignees")]
    public async Task<IActionResult> TestCreateConsignee()
        => Ok(await _testService.TestCreateConsignee());

    /// <summary>Test 9 — POST /shipments</summary>
    [HttpPost("shipments")]
    public async Task<IActionResult> TestCreateShipment()
        => Ok(await _testService.TestCreateShipment());

    /// <summary>Test 10 — GET /shipments/{id}/containers</summary>
    [HttpGet("shipments/{id:int}/containers")]
    public async Task<IActionResult> TestGetContainers()
        => Ok(await _testService.TestGetContainers());

    /// <summary>Test 11 — POST /shipments/{id}/containers</summary>
    [HttpPost("shipments/{id:int}/containers")]
    public async Task<IActionResult> TestCreateContainer()
        => Ok(await _testService.TestCreateContainer());

    /// <summary>Test 12 — POST /containers/{id}/events</summary>
    [HttpPost("containers/{id:int}/events")]
    public async Task<IActionResult> TestCreateEvent()
        => Ok(await _testService.TestCreateEvent());

    /// <summary>Test 13 — GET /containers/{id}/events</summary>
    [HttpGet("containers/{id:int}/events")]
    public async Task<IActionResult> TestGetEvents()
        => Ok(await _testService.TestGetEvents());

    /// <summary>Test 14 — PATCH /shipments/{id}/status</summary>
    [HttpPatch("shipments/{id:int}/status")]
    public async Task<IActionResult> TestPatchStatus()
        => Ok(await _testService.TestPatchStatus());

    // ── Tier 3 — Aggregation ─────────────────────────────────────────────────

    /// <summary>Test 15 — GET /shipments/search</summary>
    [HttpGet("shipments/search")]
    public async Task<IActionResult> TestSearch()
        => Ok(await _testService.TestSearch());

    /// <summary>Test 16 — GET /consignees/{id}/summary</summary>
    [HttpGet("consignees/{id:int}/summary")]
    public async Task<IActionResult> TestConsigneeSummary()
        => Ok(await _testService.TestConsigneeSummary());

    /// <summary>Test 17 — GET /reports/dwell</summary>
    [HttpGet("reports/dwell")]
    public async Task<IActionResult> TestDwell()
        => Ok(await _testService.TestDwell());

    /// <summary>Test 18 — GET /reports/transit-times</summary>
    [HttpGet("reports/transit-times")]
    public async Task<IActionResult> TestTransitTimes()
        => Ok(await _testService.TestTransitTimes());

    /// <summary>Test 19 — GET /reports/top-consignees</summary>
    [HttpGet("reports/top-consignees")]
    public async Task<IActionResult> TestTopConsignees()
        => Ok(await _testService.TestTopConsignees());

    /// <summary>Test 20 — GET /reports/monthly-volume</summary>
    [HttpGet("reports/monthly-volume")]
    public async Task<IActionResult> TestMonthlyVolume()
        => Ok(await _testService.TestMonthlyVolume());
}

