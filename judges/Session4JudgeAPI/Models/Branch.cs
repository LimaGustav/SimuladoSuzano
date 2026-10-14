using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Session4JudgeAPI.Models;

[Table("branches")]
[Index("Code", Name = "UQ__branches__357D4CF9C99A4A55", IsUnique = true)]
public partial class Branch
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("code")]
    [StringLength(255)]
    public string Code { get; set; } = null!;

    [Column("name")]
    [StringLength(255)]
    public string Name { get; set; } = null!;

    [Column("city")]
    [StringLength(255)]
    public string City { get; set; } = null!;

    [Column("phone")]
    [StringLength(255)]
    public string Phone { get; set; } = null!;

    [InverseProperty("Branch")]
    public virtual ICollection<Shipment> Shipments { get; set; } = new List<Shipment>();
}
