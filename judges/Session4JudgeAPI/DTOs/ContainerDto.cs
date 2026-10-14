using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class ContainerDto
{
    [JsonPropertyName("id")]
    public int Id { get; set; }

    [JsonPropertyName("shipment_id")]
    public int ShipmentId { get; set; }

    [JsonPropertyName("container_no")]
    public string ContainerNo { get; set; } = "";

    [JsonPropertyName("size_type")]
    public string SizeType { get; set; } = "";

    [JsonPropertyName("teu")]
    public decimal Teu { get; set; }

    [JsonPropertyName("seal_no")]
    public string SealNo { get; set; } = "";

    [JsonPropertyName("discharged_at")]
    public DateTimeOffset? DischargedAt { get; set; }

    [JsonPropertyName("gated_out_at")]
    public DateTimeOffset? GatedOutAt { get; set; }
}

