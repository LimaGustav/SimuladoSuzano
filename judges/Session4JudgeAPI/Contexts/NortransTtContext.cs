using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Session4JudgeAPI.Models;

namespace Session4JudgeAPI.Contexts;

public partial class NortransTtContext : DbContext
{
    public NortransTtContext()
    {
    }

    public NortransTtContext(DbContextOptions<NortransTtContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Branch> Branches { get; set; }

    public virtual DbSet<Consignee> Consignees { get; set; }

    public virtual DbSet<Container> Containers { get; set; }

    public virtual DbSet<Event> Events { get; set; }

    public virtual DbSet<Shipment> Shipments { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=172.16.21.151;Database=nortrans_tt;User Id=sa;Password=Senai@134;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Branch>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__branches__3213E83FAC892FA5");
        });

        modelBuilder.Entity<Consignee>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__consigne__3213E83F57537273");

            entity.Property(e => e.Active).HasDefaultValue(true);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetimeoffset())");
        });

        modelBuilder.Entity<Container>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__containe__3213E83FFE577A37");

            entity.HasOne(d => d.Shipment).WithMany(p => p.Containers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_containers_shipment");
        });

        modelBuilder.Entity<Event>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__events__3213E83FE08BE48C");

            entity.HasOne(d => d.Container).WithMany(p => p.Events)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_events_container");
        });

        modelBuilder.Entity<Shipment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__shipment__3213E83F9779768C");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetimeoffset())");

            entity.HasOne(d => d.Branch).WithMany(p => p.Shipments)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_shipments_branch");

            entity.HasOne(d => d.Consignee).WithMany(p => p.Shipments)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_shipments_consignee");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
