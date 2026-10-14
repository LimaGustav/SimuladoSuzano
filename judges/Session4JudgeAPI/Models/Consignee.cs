using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Session4JudgeAPI.Models;

[Table("consignees")]
[Index("TaxId", Name = "UQ__consigne__129B867101D1E8F1", IsUnique = true)]
[Index("Email", Name = "UQ__consigne__AB6E6164D1E26DD3", IsUnique = true)]
public partial class Consignee
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("legal_name")]
    [StringLength(255)]
    public string LegalName { get; set; } = null!;

    [Column("tax_id")]
    [StringLength(255)]
    public string TaxId { get; set; } = null!;

    [Column("country_code")]
    [StringLength(255)]
    public string CountryCode { get; set; } = null!;

    [Column("email")]
    [StringLength(255)]
    public string Email { get; set; } = null!;

    [Column("active")]
    public bool Active { get; set; }

    [Column("created_at")]
    [Precision(0)]
    public DateTimeOffset CreatedAt { get; set; }

    [InverseProperty("Consignee")]
    public virtual ICollection<Shipment> Shipments { get; set; } = new List<Shipment>();
}
