using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Session4JudgeAPI.Models;

[Table("events")]
[Index("ContainerId", Name = "ix_events_container")]
public partial class Event
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("container_id")]
    public int ContainerId { get; set; }

    [Column("event_type")]
    [StringLength(255)]
    public string EventType { get; set; } = null!;

    [Column("occurred_at")]
    [Precision(0)]
    public DateTimeOffset OccurredAt { get; set; }

    [Column("location")]
    [StringLength(255)]
    public string Location { get; set; } = null!;

    [Column("note")]
    [StringLength(1000)]
    public string? Note { get; set; }

    [ForeignKey("ContainerId")]
    [InverseProperty("Events")]
    public virtual Container Container { get; set; } = null!;
}
