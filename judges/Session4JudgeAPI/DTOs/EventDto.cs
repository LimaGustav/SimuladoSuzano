using System.Text.Json.Serialization;

namespace Session4JudgeAPI.DTOs;

public class EventDto
{
    [JsonPropertyName("id")]
    public int Id { get; set; }

    [JsonPropertyName("container_id")]
    public int ContainerId { get; set; }

    [JsonPropertyName("event_type")]
    public string EventType { get; set; } = "";

    [JsonPropertyName("occurred_at")]
    public DateTimeOffset OccurredAt { get; set; }

    [JsonPropertyName("location")]
    public string Location { get; set; } = "";

    [JsonPropertyName("note")]
    public string? Note { get; set; }
}

