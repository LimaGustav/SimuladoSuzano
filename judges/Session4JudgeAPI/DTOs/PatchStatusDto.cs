using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class PatchStatusDto
{
    [JsonPropertyName("status")]
    public string Status { get; set; } = "";
}

