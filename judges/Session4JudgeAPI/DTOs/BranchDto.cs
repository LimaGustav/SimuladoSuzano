using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class BranchDto
{
    [JsonPropertyName("id")]
    public int Id { get; set; }

    [JsonPropertyName("code")]
    public string Code { get; set; } = "";

    [JsonPropertyName("name")]
    public string Name { get; set; } = "";

    [JsonPropertyName("city")]
    public string City { get; set; } = "";

    [JsonPropertyName("phone")]
    public string Phone { get; set; } = "";
}

