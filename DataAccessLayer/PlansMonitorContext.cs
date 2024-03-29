﻿using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace DataAccessLayer
{
    public partial class PlansMonitorContext : DbContext
    {
        public PlansMonitorContext()
        {
        }

        public PlansMonitorContext(DbContextOptions<PlansMonitorContext> options)
            : base(options)
        {
        }

        public virtual DbSet<TblAudit> TblAudit { get; set; }
        public virtual DbSet<TblAuditLog> TblAuditLog { get; set; }
        public virtual DbSet<TblAuditObject> TblAuditObject { get; set; }
        public virtual DbSet<TblAuthorization> TblAuthorization { get; set; }
        public virtual DbSet<TblCorrectiveAction> TblCorrectiveAction { get; set; }
        public virtual DbSet<TblDictionary> TblDictionary { get; set; }
        public virtual DbSet<TblDictionaryValue> TblDictionaryValue { get; set; }
        public virtual DbSet<TblEmailTemplate> TblEmailTemplate { get; set; }
        public virtual DbSet<TblFileStorage> TblFileStorage { get; set; }
        public virtual DbSet<TblRemark> TblRemark { get; set; }
        public virtual DbSet<TblUser> TblUser { get; set; }
        public virtual DbSet<TblUserRole> TblUserRole { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseNpgsql("Host=localhost;Database=PlansMonitor;Username=postgres;Password=12345");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.4-servicing-10062");

            modelBuilder.Entity<TblAudit>(entity =>
            {
                entity.ToTable("tblAudit");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CapmonitoringCompleteDate)
                    .HasColumnName("CAPMonitoringCompleteDate")
                    .HasColumnType("timestamp with time zone");

                entity.Property(e => e.CapmonitoringCompletedOnDate)
                    .HasColumnName("CAPMonitoringCompletedOnDate")
                    .HasColumnType("timestamp with time zone");

                entity.Property(e => e.FileLocalRegulatory)
                    .HasColumnName("fileLocalRegulatory")
                    .HasMaxLength(256);

                entity.Property(e => e.FilePlanScheduleOfControlEvent)
                    .HasColumnName("filePlanScheduleOfControlEvent	")
                    .HasMaxLength(256);

                entity.Property(e => e.GroundForVerification)
                    .IsRequired()
                    .HasMaxLength(4192);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(256);

                entity.Property(e => e.NextCapmonitoringDate)
                    .HasColumnName("NextCAPMonitoringDate")
                    .HasColumnType("timestamp with time zone");

                entity.Property(e => e.NumLocalRegulatory)
                    .IsRequired()
                    .HasColumnName("numLocalRegulatory")
                    .HasMaxLength(256);

                entity.Property(e => e.NumberAndDateLocRegAcceptance).HasMaxLength(128);

                entity.Property(e => e.NumberAndDateLocRegPrepare).HasMaxLength(128);

                entity.Property(e => e.ParPlanScheduleOfControlEvent)
                    .IsRequired()
                    .HasColumnName("parPlanScheduleOfControlEvent")
                    .HasMaxLength(16);

                entity.Property(e => e.VerficationTermEnd)
                    .IsRequired()
                    .HasColumnType("character varying");

                entity.Property(e => e.VerificationPeriod)
                    .IsRequired()
                    .HasMaxLength(16);

                entity.Property(e => e.VerificationPeriodStart).HasColumnType("timestamp with time zone");

                entity.Property(e => e.VerificationPeriodStop).HasColumnType("timestamp with time zone");

                entity.Property(e => e.VerificationTermStart).HasColumnType("timestamp with time zone");

                entity.HasOne(d => d.AuditObjectNavigation)
                    .WithMany(p => p.TblAudit)
                    .HasForeignKey(d => d.AuditObject)
                    .HasConstraintName("fk_audit_audit_object");

                entity.HasOne(d => d.AuditSuperviserNavigation)
                    .WithMany(p => p.TblAuditAuditSuperviserNavigation)
                    .HasForeignKey(d => d.AuditSuperviser)
                    .HasConstraintName("fk_audit_superviser");

                entity.HasOne(d => d.ResponsibleEmployeeNavigation)
                    .WithMany(p => p.TblAuditResponsibleEmployeeNavigation)
                    .HasForeignKey(d => d.ResponsibleEmployee)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_audit_resp_employee");
            });

            modelBuilder.Entity<TblAuditLog>(entity =>
            {
                entity.ToTable("tblAuditLog");

                entity.HasIndex(e => e.Action)
                    .HasName("tblauditlog_action_idx");

                entity.HasIndex(e => e.BusinessObject)
                    .HasName("tblauditlog_screen_idx");

                entity.HasIndex(e => e.Time)
                    .HasName("tblauditlog_time_idx");

                entity.HasIndex(e => e.User)
                    .HasName("tblauditlog_user_idx");

                entity.HasIndex(e => new { e.User, e.Time })
                    .HasName("tblauditlog_usertime_idx");

                entity.Property(e => e.Id).UseNpgsqlIdentityByDefaultColumn();

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(2048);

                entity.Property(e => e.Time).HasColumnType("timestamp with time zone");

                entity.HasOne(d => d.UserNavigation)
                    .WithMany(p => p.TblAuditLog)
                    .HasForeignKey(d => d.User)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_audit_log_user");
            });

            modelBuilder.Entity<TblAuditObject>(entity =>
            {
                entity.ToTable("tblAuditObject");

                entity.Property(e => e.Id).UseNpgsqlIdentityByDefaultColumn();

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(256);
            });

            modelBuilder.Entity<TblAuthorization>(entity =>
            {
                entity.ToTable("tblAuthorization");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Permit4Ur1admin).HasColumnName("Permit4UR1Admin");

                entity.Property(e => e.Permit4Ur2intOperator).HasColumnName("Permit4UR2IntOperator");

                entity.Property(e => e.Permit4Ur3extOperator).HasColumnName("Permit4UR3ExtOperator");

                entity.Property(e => e.Permit4Ur4auditSuperviser).HasColumnName("Permit4UR4AuditSuperviser");

                entity.Property(e => e.Permit4Ur5auditor).HasColumnName("Permit4UR5Auditor");

                entity.Property(e => e.Permit4Ur6controller).HasColumnName("Permit4UR6Controller");

                entity.Property(e => e.Permit4Ur7respEmployee).HasColumnName("Permit4UR7RespEmployee");
            });

            modelBuilder.Entity<TblCorrectiveAction>(entity =>
            {
                entity.ToTable("tblCorrectiveAction");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CadevelopmentEvaluation)
                    .HasColumnName("CADevelopmentEvaluation")
                    .HasMaxLength(2048);

                entity.Property(e => e.CainAccordOrderOfVerifObject)
                    .HasColumnName("CAInAccordOrderOfVerifObject")
                    .HasMaxLength(4096);

                entity.Property(e => e.CommentOnUsedRecommendationInPca)
                    .HasColumnName("CommentOnUsedRecommendationInPCA")
                    .HasMaxLength(2048);

                entity.Property(e => e.ConclusionCorrectiveActionEffectEvaluation).HasMaxLength(2048);

                entity.Property(e => e.CorrectiveActionStateComment).HasMaxLength(2048);

                entity.Property(e => e.EvalAccordRecomForPrepOfCacomment)
                    .HasColumnName("EvalAccordRecomForPrepOfCAComment")
                    .HasMaxLength(4096);

                entity.Property(e => e.EvaluationAccordRecomForPrepOfCa)
                    .HasColumnName("EvaluationAccordRecomForPrepOfCA")
                    .HasMaxLength(4096);

                entity.Property(e => e.EvaluationCheckMarkOnCa).HasColumnName("EvaluationCheckMarkOnCA");

                entity.Property(e => e.EvaluationOfPostControlNeed).HasMaxLength(2048);

                entity.Property(e => e.ExecutiveOfficerFirstName)
                    .IsRequired()
                    .HasMaxLength(64);

                entity.Property(e => e.ExecutiveOfficerLastName)
                    .IsRequired()
                    .HasMaxLength(64);

                entity.Property(e => e.ExecutiveOfficerPatronymic)
                    .IsRequired()
                    .HasMaxLength(64);

                entity.Property(e => e.FactPeriodOfCaexecution)
                    .HasColumnName("FactPeriodOfCAExecution")
                    .HasMaxLength(64);

                entity.Property(e => e.MonitoringOfficerFirstName).HasMaxLength(64);

                entity.Property(e => e.MonitoringOfficerLastName).HasMaxLength(64);

                entity.Property(e => e.MonitoringOfficerPatronymic).HasMaxLength(64);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(128);

                entity.Property(e => e.NotDevelopmentCacomment)
                    .HasColumnName("NotDevelopmentCAComment")
                    .HasMaxLength(4096);

                entity.Property(e => e.Note).HasMaxLength(4096);

                entity.Property(e => e.PlannedExecutionDate).HasColumnType("timestamp with time zone");

                entity.Property(e => e.PlannedResultOfCorrectiveAction)
                    .IsRequired()
                    .HasMaxLength(256);

                entity.Property(e => e.ReportImplementOfTheApprovedCa)
                    .HasColumnName("ReportImplementOfTheApprovedCA")
                    .HasMaxLength(4096);

                entity.Property(e => e.UsedRecommendationInPca).HasColumnName("UsedRecommendationInPCA");

                entity.HasOne(d => d.AuditNavigation)
                    .WithMany(p => p.TblCorrectiveAction)
                    .HasForeignKey(d => d.Audit)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_CorrAction_Audit");
            });

            modelBuilder.Entity<TblDictionary>(entity =>
            {
                entity.ToTable("tblDictionary");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Description).HasMaxLength(2048);

                entity.Property(e => e.EngName4Code).HasMaxLength(1024);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(128);
            });

            modelBuilder.Entity<TblDictionaryValue>(entity =>
            {
                entity.ToTable("tblDictionaryValue");

                entity.HasIndex(e => new { e.Dictionary, e.Position })
                    .HasName("uk_Dictionary_Position")
                    .IsUnique();

                entity.Property(e => e.Id).UseNpgsqlIdentityByDefaultColumn();

                entity.Property(e => e.Description)
                    .HasMaxLength(2048)
                    .ForNpgsqlHasComment("Описание элемента, используется далеко не во всех словарях");

                entity.Property(e => e.EngName4Code).HasMaxLength(1024);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(128);

                entity.HasOne(d => d.DictionaryNavigation)
                    .WithMany(p => p.TblDictionaryValue)
                    .HasForeignKey(d => d.Dictionary)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_dicvalue_dic");
            });

            modelBuilder.Entity<TblEmailTemplate>(entity =>
            {
                entity.ToTable("tblEmailTemplate");

                entity.Property(e => e.Id).UseNpgsqlIdentityByDefaultColumn();

                entity.Property(e => e.Description).HasMaxLength(8192);

                entity.Property(e => e.Template)
                    .IsRequired()
                    .HasMaxLength(8192);
            });

            modelBuilder.Entity<TblFileStorage>(entity =>
            {
                entity.ToTable("tblFileStorage");

                entity.HasIndex(e => e.Audit)
                    .HasName("tblfilestorage_audit_idx");

                entity.HasIndex(e => new { e.Audit, e.Extention })
                    .HasName("tblfilestorage_aextention_idx");

                entity.HasIndex(e => new { e.Audit, e.LoadingTime })
                    .HasName("tblfilestorage_altime_idx");

                entity.HasIndex(e => new { e.Audit, e.Name })
                    .HasName("tblfilestorage_aname_idx");

                entity.HasIndex(e => new { e.Audit, e.User })
                    .HasName("tblfilestorage_auser_idx");

                entity.HasIndex(e => new { e.Audit, e.Name, e.Extention })
                    .HasName("tblfilestorage_anamext_idx");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Extention)
                    .IsRequired()
                    .HasMaxLength(16);

                entity.Property(e => e.LoadingTime).HasColumnType("timestamp with time zone");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(256);

                entity.Property(e => e.PathToFile)
                    .IsRequired()
                    .HasMaxLength(256);

                entity.Property(e => e.PathToPreview).HasMaxLength(256);

                entity.HasOne(d => d.AuditNavigation)
                    .WithMany(p => p.TblFileStorage)
                    .HasForeignKey(d => d.Audit)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_fileStorage_audit");
            });

            modelBuilder.Entity<TblRemark>(entity =>
            {
                entity.ToTable("tblRemark");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.AuditObjectComments).HasMaxLength(2048);

                entity.Property(e => e.AuditObjectFinalAssessment).HasColumnType("character varying");

                entity.Property(e => e.PersonCmrecommendations)
                    .HasColumnName("PersonCMRecommendations")
                    .HasMaxLength(4192);

                entity.Property(e => e.QualitativeAssessment).HasMaxLength(4192);

                entity.Property(e => e.RemarkDescription).HasColumnType("character varying");

                entity.Property(e => e.RevealedRemarkConsequences).HasColumnType("character varying");

                entity.Property(e => e.RevealedRemarkReason).HasColumnType("character varying");

                entity.Property(e => e.ViolationContent).HasColumnType("character varying");

                entity.Property(e => e.ViolationsAndDeficienciesCauses).HasColumnType("character varying");

                entity.HasOne(d => d.ResponsibleAuditorNavigation)
                    .WithMany(p => p.TblRemarkResponsibleAuditorNavigation)
                    .HasForeignKey(d => d.ResponsibleAuditor)
                    .HasConstraintName("fk_remark_user");

                entity.HasOne(d => d.ResponsibleControllerNavigation)
                    .WithMany(p => p.TblRemarkResponsibleControllerNavigation)
                    .HasForeignKey(d => d.ResponsibleController)
                    .HasConstraintName("fk_remark_resp_contr");
            });

            modelBuilder.Entity<TblUser>(entity =>
            {
                entity.ToTable("tblUser");

                entity.HasIndex(e => new { e.FirstName, e.LastName, e.Patronymic })
                    .HasName("tbluser_firstname_idx")
                    .IsUnique();

                entity.Property(e => e.Id).UseNpgsqlIdentityByDefaultColumn();

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasColumnName("EMail")
                    .HasMaxLength(254);

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(64);

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(64);

                entity.Property(e => e.Login)
                    .IsRequired()
                    .HasMaxLength(32);

                entity.Property(e => e.PasswordHash).HasMaxLength(32);

                entity.Property(e => e.PasswordSalt)
                    .IsRequired()
                    .HasMaxLength(32);

                entity.Property(e => e.Patronymic)
                    .IsRequired()
                    .HasMaxLength(64);

                entity.HasOne(d => d.RoleNavigation)
                    .WithMany(p => p.TblUser)
                    .HasForeignKey(d => d.Role)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_tbl_user_role");

                entity.HasOne(d => d.VerificationObjectNavigation)
                    .WithMany(p => p.TblUser)
                    .HasForeignKey(d => d.VerificationObject)
                    .HasConstraintName("fk_tbl_verification_object");
            });

            modelBuilder.Entity<TblUserRole>(entity =>
            {
                entity.ToTable("tblUserRole");

                entity.Property(e => e.Id).UseNpgsqlIdentityByDefaultColumn();

                entity.Property(e => e.Comment)
                    .IsRequired()
                    .HasMaxLength(256);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(64);
            });

            modelBuilder.HasSequence<int>("tblAuthorization_Id_seq1");
        }
    }
}
