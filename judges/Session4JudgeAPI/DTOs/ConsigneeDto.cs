using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class ConsigneeDto
{
    [JsonPropertyName("id")]
    public int Id { get; set; }

    [JsonPropertyName("legal_name")]
    public string LegalName { get; set; } = "";

    [JsonPropertyName("tax_id")]
    public string TaxId { get; set; } = "";

    [JsonPropertyName("country_code")]
    public string CountryCode { get; set; } = "";

    [JsonPropertyName("email")]
    public string Email { get; set; } = "";

    [JsonPropertyName("active")]
    public bool Active { get; set; }

    [JsonPropertyName("created_at")]
    public DateTimeOffset? CreatedAt { get; set; }
}

