using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class CreateContainerDto
{
    [JsonPropertyName("container_no")]
    public string ContainerNo { get; set; } = "";

    [JsonPropertyName("size_type")]
    public string SizeType { get; set; } = "";

    [JsonPropertyName("teu")]
    public decimal Teu { get; set; }

    [JsonPropertyName("seal_no")]
    public string SealNo { get; set; } = "";
}

