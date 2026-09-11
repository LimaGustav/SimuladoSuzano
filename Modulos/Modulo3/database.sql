-- 1. Create the database if it doesn't already exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'worldskills_db')
BEGIN
    CREATE DATABASE [worldskills_db];
END;
GO

-- 2. Switch to the newly created database
USE [worldskills_db];
GO

-- 3. Initialize the tables
IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
CREATE TABLE [Groups] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [ParentGroupId] uniqueidentifier NULL,
    CONSTRAINT [PK_Groups] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Groups_Groups_ParentGroupId] FOREIGN KEY ([ParentGroupId]) REFERENCES [Groups] ([Id]) ON DELETE NO ACTION
);

CREATE TABLE [Users] (
    [Id] uniqueidentifier NOT NULL,
    [Email] nvarchar(450) NOT NULL,
    [Password] nvarchar(max) NOT NULL,
    [IsDisabled] bit NOT NULL,
    [TotpSecret] nvarchar(max) NULL,
    [IsTotpActive] bit NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY ([Id])
);

CREATE TABLE [LoginAttempts] (
    [Id] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [Country] nvarchar(max) NOT NULL,
    [IsSuccessful] bit NOT NULL,
    [Timestamp] datetime2 NOT NULL,
    CONSTRAINT [PK_LoginAttempts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_LoginAttempts_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [UserGroups] (
    [GroupId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_UserGroups] PRIMARY KEY ([GroupId], [UserId]),
    CONSTRAINT [FK_UserGroups_Groups_GroupId] FOREIGN KEY ([GroupId]) REFERENCES [Groups] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserGroups_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE UNIQUE INDEX [IX_Groups_Name] ON [Groups] ([Name]);

CREATE INDEX [IX_Groups_ParentGroupId] ON [Groups] ([ParentGroupId]);

CREATE INDEX [IX_LoginAttempts_UserId] ON [LoginAttempts] ([UserId]);

CREATE INDEX [IX_UserGroups_UserId] ON [UserGroups] ([UserId]);

CREATE UNIQUE INDEX [IX_Users_Email] ON [Users] ([Email]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260714171500_InitialMigration', N'10.0.9');

COMMIT;
GO

