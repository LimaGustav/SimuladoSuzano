using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class CreateShipmentDto
{
    [JsonPropertyName("reference")]
    public string Reference { get; set; } = "";

    [JsonPropertyName("bill_of_lading")]
    public string BillOfLading { get; set; } = "";

    [JsonPropertyName("consignee_id")]
    public int ConsigneeId { get; set; }

    [JsonPropertyName("branch_id")]
    public int BranchId { get; set; }

    [JsonPropertyName("mode")]
    public string Mode { get; set; } = "ocean";

    [JsonPropertyName("etd")]
    public DateTimeOffset Etd { get; set; }

    [JsonPropertyName("eta")]
    public DateTimeOffset Eta { get; set; }
}

