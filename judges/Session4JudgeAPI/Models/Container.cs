using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Session4JudgeAPI.Models;

[Table("containers")]
[Index("ContainerNo", Name = "UQ__containe__48738247D589A9D3", IsUnique = true)]
[Index("ShipmentId", Name = "ix_containers_shipment")]
public partial class Container
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("shipment_id")]
    public int ShipmentId { get; set; }

    [Column("container_no")]
    [StringLength(255)]
    public string ContainerNo { get; set; } = null!;

    [Column("size_type")]
    [StringLength(255)]
    public string SizeType { get; set; } = null!;

    [Column("teu", TypeName = "numeric(3, 1)")]
    public decimal Teu { get; set; }

    [Column("seal_no")]
    [StringLength(255)]
    public string SealNo { get; set; } = null!;

    [Column("discharged_at")]
    [Precision(0)]
    public DateTimeOffset? DischargedAt { get; set; }

    [Column("gated_out_at")]
    [Precision(0)]
    public DateTimeOffset? GatedOutAt { get; set; }

    [InverseProperty("Container")]
    public virtual ICollection<Event> Events { get; set; } = new List<Event>();

    [ForeignKey("ShipmentId")]
    [InverseProperty("Containers")]
    public virtual Shipment Shipment { get; set; } = null!;
}
