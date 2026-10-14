using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Session4JudgeAPI.Models;

[Table("shipments")]
[Index("Reference", Name = "UQ__shipment__FD90DA99614F943E", IsUnique = true)]
[Index("BranchId", Name = "ix_shipments_branch")]
[Index("ConsigneeId", Name = "ix_shipments_consignee")]
public partial class Shipment
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("reference")]
    [StringLength(255)]
    public string Reference { get; set; } = null!;

    [Column("bill_of_lading")]
    [StringLength(255)]
    public string BillOfLading { get; set; } = null!;

    [Column("consignee_id")]
    public int ConsigneeId { get; set; }

    [Column("branch_id")]
    public int BranchId { get; set; }

    [Column("mode")]
    [StringLength(255)]
    public string Mode { get; set; } = null!;

    [Column("status")]
    [StringLength(255)]
    public string Status { get; set; } = null!;

    [Column("etd")]
    [Precision(0)]
    public DateTimeOffset Etd { get; set; }

    [Column("eta")]
    [Precision(0)]
    public DateTimeOffset Eta { get; set; }

    [Column("created_at")]
    [Precision(0)]
    public DateTimeOffset CreatedAt { get; set; }

    [ForeignKey("BranchId")]
    [InverseProperty("Shipments")]
    public virtual Branch Branch { get; set; } = null!;

    [ForeignKey("ConsigneeId")]
    [InverseProperty("Shipments")]
    public virtual Consignee Consignee { get; set; } = null!;

    [InverseProperty("Shipment")]
    public virtual ICollection<Container> Containers { get; set; } = new List<Container>();
}
