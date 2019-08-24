----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

USE [MatchingLearning]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS [dbo].[GlobalSkill]

DROP TABLE IF EXISTS [dbo].[SkillEstimatedExpertise]
DROP TABLE IF EXISTS [dbo].[Experience]
DROP TABLE IF EXISTS [dbo].[Evaluation]
DROP TABLE IF EXISTS [dbo].[EvaluationType]
DROP TABLE IF EXISTS [dbo].[SkillLearningCurve]
DROP TABLE IF EXISTS [dbo].[SkillGrades]
DROP TABLE IF EXISTS [dbo].[SkillRelation]
DROP TABLE IF EXISTS [dbo].[Skill]
DROP TABLE IF EXISTS [dbo].[BusinessArea]
DROP TABLE IF EXISTS [dbo].[SoftSkill]
DROP TABLE IF EXISTS [dbo].[TechnologyRole]
DROP TABLE IF EXISTS [dbo].[TechnologyVersion]
DROP TABLE IF EXISTS [dbo].[Technology]
DROP TABLE IF EXISTS [dbo].[CandidateCandidateRole]
DROP TABLE IF EXISTS [dbo].[Candidate]
DROP TABLE IF EXISTS [dbo].[CandidateRole]
DROP TABLE IF EXISTS [dbo].[DeliveryUnit]
DROP TABLE IF EXISTS [dbo].[Region]
GO

DROP TYPE IF EXISTS [MLCode]
DROP TYPE IF EXISTS [MLName]
DROP TYPE IF EXISTS [MLDecimal]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

CREATE TYPE [MLCode] FROM NVARCHAR(32)
CREATE TYPE [MLName] FROM NVARCHAR(256)
CREATE TYPE [MLDecimal] FROM DECIMAL(12, 4)

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Region] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,

  CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_Region_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[DeliveryUnit] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [RegionId]                      INT NOT NULL,

  CONSTRAINT [PK_DeliveryUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_DeliveryUnit_Code] UNIQUE NONCLUSTERED ([Code] ASC),

  CONSTRAINT [FK_DeliveryUnit_Region_RegionId] FOREIGN KEY ([RegionId]) REFERENCES [dbo].[Region] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[CandidateRole] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
    
  CONSTRAINT [PK_CandidateRole] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_CandidateRole_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[Candidate] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [DeliveryUnitId]                INT NOT NULL,
  [RelationType]                  INT NOT NULL CONSTRAINT [CH_Candidate_RelationType] CHECK ([RelationType] IN (1, 2, 3)), -- 1: Employee, 2: Candidate, 3: External
  [FirstName]                     [MLName] NOT NULL,
  [LastName]                      [MLName] NOT NULL,
  [DocType]                       INT NULL CONSTRAINT [CH_Candidate_DocType] CHECK ([DocType] IN (1, 2)), -- 1: NationalIdentity, 2: Passport
  [DocNumber]                     NVARCHAR(64) NULL,
  [EmployeeNumber]                INT NULL,
  [InBench]                       BIT NOT NULL,
  [Picture]                       NVARCHAR(1024) NULL,
  [IsActive]                      BIT NOT NULL,

  CONSTRAINT [PK_Candidate] PRIMARY KEY CLUSTERED ([Id] ASC),
  
  CONSTRAINT [FK_Candidate_DeliveryUnit_DeliveryUnitId] FOREIGN KEY ([DeliveryUnitId]) REFERENCES [dbo].[DeliveryUnit] ([Id]),
)
GO

-- CONSTRAINT [UC_Candidate_EmployeeNumber] NONCLUSTERED ([EmployeeNumber] ASC),
-- CONSTRAINT [UC_Candidate_Doc] NONCLUSTERED ([DocType] ASC, [DocNumber] ASC),

CREATE TABLE [dbo].[CandidateCandidateRole] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [CandidateId]                   INT NOT NULL,
  [CandidateRoleId]               INT NOT NULL,
  [StartDate]                     DATETIME NOT NULL,
  [EndDate]                       DATETIME NULL,

  CONSTRAINT [PK_CandidateCandidateRole] PRIMARY KEY CLUSTERED ([Id] ASC),
  
  CONSTRAINT [FK_CandidateCandidateRole_Candidate_CandidateId] FOREIGN KEY ([CandidateId]) REFERENCES [dbo].[Candidate] ([Id]),

  CONSTRAINT [FK_CandidateCandidateRole_CandidateRole_CandidateRoleId] FOREIGN KEY ([CandidateRoleId]) REFERENCES [dbo].[CandidateRole] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Technology] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [DefaultExpertise]              [MLDecimal] NOT NULL CONSTRAINT [CH_Technology_DefaultExpertise] CHECK ([DefaultExpertise] BETWEEN 0.0 AND 1.0),
  [IsVersioned]                   BIT NOT NULL,

  CONSTRAINT [PK_Technology] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_Technology_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[TechnologyVersion] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [TechnologyId]                  INT NOT NULL,
  [DefaultExpertise]              [MLDecimal] NOT NULL CONSTRAINT [CH_TechnologyVersion_DefaultExpertise] CHECK ([DefaultExpertise] BETWEEN 0.0 AND 1.0),
  [Version]                       [MLCode] NOT NULL,
  [StartDate]                     DATETIME  NOT NULL,

  CONSTRAINT [PK_TechnologyVersion] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_TechnologyVersion_TechnologyId_Version] UNIQUE NONCLUSTERED ([TechnologyId], [Version] ASC),

  CONSTRAINT [FK_TechnologyVersion_Technology_TechnologyId] FOREIGN KEY ([TechnologyId]) REFERENCES [dbo].[Technology] ([Id]),
)
GO

CREATE TABLE [dbo].[TechnologyRole] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [TechnologyId]                  INT NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [DefaultExpertise]              [MLDecimal] NOT NULL CONSTRAINT [CH_TechnologyRole_DefaultExpertise] CHECK ([DefaultExpertise] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_TechnologyRole] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_TechnologyRole_Code] UNIQUE NONCLUSTERED ([Code] ASC),

  CONSTRAINT [FK_TechnologyRole_Technology_TechnologyId] FOREIGN KEY ([TechnologyId]) REFERENCES [dbo].[Technology] ([Id]),
)
GO

CREATE TABLE [dbo].[SoftSkill] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [DefaultExpertise]              [MLDecimal] NOT NULL CONSTRAINT [CH_SoftSkill_DefaultExpertise] CHECK ([DefaultExpertise] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_SoftSkill] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_SoftSkill_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[BusinessArea] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [DefaultExpertise]              [MLDecimal] NOT NULL CONSTRAINT [CH_BusinessArea_DefaultExpertise] CHECK ([DefaultExpertise] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_BusinessArea] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_BusinessArea_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Skill] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,

  [TechnologyId]                  INT NULL,
  [TechnologyVersionId]           INT NULL,
  [TechnologyRoleId]              INT NULL,
  [SoftSkillId]                   INT NULL,
  [BusinessAreaId]                INT NULL,

  CONSTRAINT [PK_Skill] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_Skill_Technology_TechnologyId] FOREIGN KEY ([TechnologyId]) REFERENCES [dbo].[Technology] ([Id]),
  CONSTRAINT [FK_Skill_TechnologyVersion_TechnologyVersionId] FOREIGN KEY ([TechnologyVersionId]) REFERENCES [dbo].[TechnologyVersion] ([Id]),
  CONSTRAINT [FK_Skill_TechnologyRole_TechnologyRoleId] FOREIGN KEY ([TechnologyRoleId]) REFERENCES [dbo].[TechnologyRole] ([Id]),
  CONSTRAINT [FK_Skill_SoftSkill_SoftSkillId] FOREIGN KEY ([SoftSkillId]) REFERENCES [dbo].[SoftSkill] ([Id]),
  CONSTRAINT [FK_Skill_BusinessArea_BusinessAreaId] FOREIGN KEY ([BusinessAreaId]) REFERENCES [dbo].[BusinessArea] ([Id]),

  CONSTRAINT [CH_Skill_Related] CHECK ([TechnologyId] IS NOT NULL OR [TechnologyVersionId] IS NOT NULL OR [TechnologyRoleId] IS NOT NULL OR [SoftSkillId] IS NOT NULL OR [BusinessAreaId] IS NOT NULL),
)
GO

CREATE TABLE [dbo].[SkillRelation] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [SkillId]                       INT NOT NULL,
  [AssociatedSkillId]             INT NOT NULL,
  [RelationType]                  INT NOT NULL CONSTRAINT [CH_SkillRelation_RelationType] CHECK ([RelationType] IN (1, 2, 3)), -- 1: Parent/Child, 2: Version, 3: Similar
  [ConversionFactor]              [MLDecimal] NOT NULL CONSTRAINT [CH_SkillRelation_ConversionFactor] CHECK ([ConversionFactor] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_SkillRelation] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillRelation_Skill_SkillId1] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),

  CONSTRAINT [FK_SkillRelation_Skill_SkillId2] FOREIGN KEY ([AssociatedSkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

CREATE TABLE [dbo].[SkillGrades] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [SkillId]                       INT NOT NULL,
  [MinValue]                      [MLDecimal] NOT NULL CONSTRAINT [CH_SkillGrades_MinValue] CHECK ([MinValue] BETWEEN 0.0 AND 1.0),
  [MaxValue]                      [MLDecimal] NOT NULL CONSTRAINT [CH_SkillGrades_MaxValue] CHECK ([MaxValue] BETWEEN 0.0 AND 1.0),
  [Description]                   NVARCHAR(MAX) NOT NULL,

  CONSTRAINT [PK_SkillGrades] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillGrades_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

CREATE TABLE [dbo].[SkillLearningCurve] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [SkillId]                       INT NOT NULL,
  [Months]                        INT NOT NULL,
  [ExpectedExpertise]             [MLDecimal] NOT NULL CONSTRAINT [CH_SkillLearningCurve_ExpectedExpertise] CHECK ([ExpectedExpertise] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_SkillLearningCurve] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillLearningCurve_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[EvaluationType] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [Priority]                      [MLDecimal] NOT NULL CONSTRAINT [CH_EvaluationType_Priority] CHECK ([Priority] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_EvaluationType] PRIMARY KEY CLUSTERED ([Id] ASC),
    
  CONSTRAINT [UC_EvaluationType_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[Evaluation] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [CandidateId]                   INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [EvaluationKey]                 NVARCHAR(256) NULL,
  [EvaluationTypeId]              INT NOT NULL,
  [Date]                          DATETIME NOT NULL,
  [Expertise]                     [MLDecimal] NOT NULL CONSTRAINT [CH_Evaluation_Expertise] CHECK ([Expertise] BETWEEN 0.0 AND 1.0),
  [Notes]                         NVARCHAR(MAX) NULL,

  CONSTRAINT [PK_Evaluation] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_Evaluation_Candidate_CandidateId] FOREIGN KEY ([CandidateId]) REFERENCES [dbo].[Candidate] ([Id]),

  CONSTRAINT [FK_Evaluation_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),

  CONSTRAINT [FK_Evaluation_EvaluationType_EvaluationTypeId] FOREIGN KEY ([EvaluationTypeId]) REFERENCES [dbo].[EvaluationType] ([Id]),
)
GO

CREATE TABLE [dbo].[Experience] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [CandidateId]                   INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [StartDate]                     DATETIME NOT NULL,
  [EndDate]                       DATETIME NULL,
  [Percentage]                    [MLDecimal] NOT NULL CONSTRAINT [CH_Experience_Percentage] CHECK ([Percentage] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_Experience] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_Experience_Candidate_CandidateId] FOREIGN KEY ([CandidateId]) REFERENCES [dbo].[Candidate] ([Id]),

  CONSTRAINT [FK_Experience_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[SkillEstimatedExpertise] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [CandidateId]                   INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [Expertise]                     [MLDecimal] NOT NULL CONSTRAINT [CH_SkillEstimatedExpertise_Expertise] CHECK ([Expertise] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_SkillEstimatedExpertise] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillEstimatedExpertise_Candidate_CandidateId] FOREIGN KEY ([CandidateId]) REFERENCES [dbo].[Candidate] ([Id]),

  CONSTRAINT [FK_SkillEstimatedExpertise_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

GO

CREATE VIEW [dbo].[GlobalSkill]
AS
  SELECT [S].[Id] AS [SkillId],
         [T].[Id] AS [RelatedId],
         1 AS [Category],
         [T].[Code],
         [T].[Name],
         [T].[DefaultExpertise]
  FROM [dbo].[Technology] AS [T]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[TechnologyId] = [T].[Id]
  UNION ALL
  SELECT [S].[Id] AS [SkillId],
         [TV].[Id] AS [RelatedId],
         2 AS [Category],
         [T].[Code] + ' v' + [TV].[Version] AS [Code],
         [T].[Name] + ' v' + [TV].[Version] AS [Name],
         [TV].[DefaultExpertise]
  FROM [dbo].[Technology] AS [T]
  INNER JOIN [dbo].[TechnologyVersion] AS [TV] ON [TV].[TechnologyId] = [T].[Id]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[TechnologyVersionId] = [TV].[Id]
  UNION ALL
  SELECT [S].[Id] AS [SkillId],
         [TR].[Id] AS [RelatedId],
         3 AS [Category],
         [TR].[Code],
         [TR].[Name],
         [TR].[DefaultExpertise]
  FROM [dbo].[Technology] AS [T]
  INNER JOIN [dbo].[TechnologyRole] AS [TR] ON [TR].[TechnologyId] = [T].[Id]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[TechnologyRoleId] = [TR].[Id]
  UNION ALL
  SELECT [S].[Id] AS [SkillId],
         [SK].[Id] AS [RelatedId],
         4 AS [Category],
         [SK].[Code],
         [SK].[Name],
         [SK].[DefaultExpertise]
  FROM [dbo].[SoftSkill] AS [SK]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[SoftSkillId] = [SK].[Id]
  UNION ALL
  SELECT [S].[Id] AS [SkillId],
         [BA].[Id] AS [RelatedId],
         5 AS [Category],
         [BA].[Code],
         [BA].[Name],
         [BA].[DefaultExpertise]
  FROM [dbo].[BusinessArea] AS [BA]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[BusinessAreaId] = [BA].[Id]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Region] ([Code], [Name]) VALUES ('WEU', 'West Europe')
INSERT INTO [dbo].[Region] ([Code], [Name]) VALUES ('EEU', 'East Europe')
INSERT INTO [dbo].[Region] ([Code], [Name]) VALUES ('NLATAM', 'North Latin-America')
INSERT INTO [dbo].[Region] ([Code], [Name]) VALUES ('SLATAM', 'South Latin-America')
GO

INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'BEL', 'Belgrade', [Id] FROM [dbo].[Region] WHERE [Code] = 'WEU'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'SOF', 'Sofia', [Id] FROM [dbo].[Region] WHERE [Code] = 'WEU'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'SKO', 'Skopje', [Id] FROM [dbo].[Region] WHERE [Code] = 'WEU'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'CNA', 'Cluj-Napoca', [Id] FROM [dbo].[Region] WHERE [Code] = 'WEU'

INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'BUC', 'Bucharest', [Id] FROM [dbo].[Region] WHERE [Code] = 'EEU'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'CHI', 'Chisinau', [Id] FROM [dbo].[Region] WHERE [Code] = 'EEU'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'IAS', 'Iasi', [Id] FROM [dbo].[Region] WHERE [Code] = 'EEU'

INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'BOG', 'Bogota', [Id] FROM [dbo].[Region] WHERE [Code] = 'NLATAM'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'MED', 'Medellin', [Id] FROM [dbo].[Region] WHERE [Code] = 'NLATAM'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'CAR', 'Caracas', [Id] FROM [dbo].[Region] WHERE [Code] = 'NLATAM'

INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'BAS', 'Buenos Aires', [Id] FROM [dbo].[Region] WHERE [Code] = 'SLATAM'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'ROS', 'Rosario', [Id] FROM [dbo].[Region] WHERE [Code] = 'SLATAM'
INSERT INTO [dbo].[DeliveryUnit] ([Code], [Name], [RegionId]) SELECT 'MVD', 'Montevideo', [Id] FROM [dbo].[Region] WHERE [Code] = 'SLATAM'
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('PM', 'Project Manager')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('BA', 'Business Analyst')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('DEV', 'Developer')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('TST', 'Tester')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('DBA', 'Database Administrator')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('SRV', 'Servers Administrator')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('NET', 'Networks Administrator')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('UX', 'UX Designer')
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('ADMIN', 'Admin Roles')
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('EXPERT', 'Expert Evaluation', 0.9)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('LEADER', 'Leader Evaluation', 0.7)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('PAIR', 'Pair Evaluation', 0.5)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('CERT', 'Certification', 0.75)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('CV', 'Curriculum Vitae', 0.25)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('LINKEDIN', 'LinkedIn', 0.1)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('PLURALSIGHT', 'PluralSight', 0.2)
INSERT INTO [dbo].[EvaluationType] ([Code], [Name], [Priority]) VALUES ('HACKERRANK', 'HackerRank', 0.3)
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('CLOUD', 'CLOUD Computing', 0.0, 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('AZURE', 'MS Azure', 0.0, 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('AMZN', 'Amazon AWS', 0.0, 0)

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('SQL', 'SQL', 0.2, 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('SQLServer', 'MS SQL Server', 0.2, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('SQLServerAzure', 'MS SQL Server Azure', 0.15, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('Oracle', 'Oracle', 0.1, 1)
GO

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '6.0', '1995-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '6.5', '1996-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '7.0', '1998-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2000', '2000-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2005', '2005-11-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2008', '2008-08-06' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2008 R2', '2010-04-21' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2012', '2012-03-06' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2014', '2014-03-18' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2016', '2016-06-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.25, '2017', '2017-10-02' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
GO

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.1,  '2010','2010-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServerAzure'
GO

INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name], [DefaultExpertise]) SELECT [Id], 'SQL Srv TSQL Dev', 'MS SQL Server TSQL Developer', 0.25 FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name], [DefaultExpertise]) SELECT [Id], 'SQL Srv DBA', 'MS SQL Server Database Administrator', 0.1 FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name], [DefaultExpertise]) SELECT [Id], 'SQL Srv IS', 'MS SQL Server Integration Services', 0.0 FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name], [DefaultExpertise]) SELECT [Id], 'SQL Srv SSRS', 'MS SQL Server Reporting Services', 0.0 FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('.NET', '.NET', 0.0, 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('.NET FRMK', '.NET Framework', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('C#', 'C#', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('VB.NET', 'VB.NET', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('MS C++', 'MS C++', 0.0, 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.0', '2002-02-13' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.1', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '2.0', '2005-11-07' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '3.0', '2006-11-06' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '3.5', '2007-11-19' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.0', '2010-04-12' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.5', '2012-08-15' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.5.1', '2013-10-17' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.5.2', '2014-05-05' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.6', '2015-07-20' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.6.1', '2015-11-30' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.6.2', '2016-08-02' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.7', '2017-04-05' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.7.1', '2017-10-17' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.7.2', '2018-04-30' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.8', '2019-04-18' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.0', '2002-02-13' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.1', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.2', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '2.0', '2005-11-07' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '3.0', '2007-11-19' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.0', '2010-04-12' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '5.0', '2012-08-15' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '6.0', '2015-07-20' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7.0', '2017-03-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7.1', '2017-08-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7.2', '2017-11-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7.3', '2018-01-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7.0', '2002-02-13' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7.1', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '8.0', '2005-11-07' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '9.0', '2007-11-19' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '10.0', '2010-04-12' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '11.0', '2012-08-15' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '14.0', '2015-07-20' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '15.0', '2017-04-05' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('JAVA', 'JAVA', 0.0, 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('JDK', 'JDK', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('J2SE', 'J2SE', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('JAVA SE', 'Java SE', 0.0, 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.0', '1996-01-01' FROM [dbo].[Technology] WHERE [Code] = 'JDK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.1', '1997-02-01' FROM [dbo].[Technology] WHERE [Code] = 'JDK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.2', '1998-12-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.3', '2000-05-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.4', '2002-02-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '5.0', '2004-09-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '6', '2006-12-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '7', '2011-07-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '8', '2014-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '9', '2017-09-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '10', '2018-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '11', '2018-09-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '12', '2019-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('ANGULAR', 'Angular', 0.0, 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, 'JS', '2010-01-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '2.0', '2016-09-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.0', '2017-03-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '5.0', '2017-11-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('COMM', 'Communication', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('LEAD', 'Leadership', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('PLAN', 'Planning', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('TIME', 'Time Management', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('PROB', 'Problem Solving', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('TEAM', 'Team Player', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('CONF', 'Self-Confidence', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('FLEX', 'Flexibility/Adaptability', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('PRES', 'Working Well Under Pressure', 0.5)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('POSI', 'Positive Attitude', 0.5)

INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('OENG', 'Oral English', 0.25)
INSERT INTO [dbo].[SoftSkill] ([Code], [Name], [DefaultExpertise]) VALUES ('WENG', 'Writting English', 0.5)

GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('BANK', 'Banking', 0.1)
INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('CRED', 'Credit Cards', 0.1)
INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('INS', 'Insurance', 0.1)
INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('ENER', 'Energy', 0.1)
INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('RET', 'Retail', 0.1)
INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('LOG', 'Logistics', 0.1)
INSERT INTO [dbo].[BusinessArea] ([Code], [Name], [DefaultExpertise]) VALUES ('MAN', 'Manufacturing', 0.1)
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Skill] ([TechnologyId]) SELECT [Id] FROM [dbo].[Technology]

INSERT INTO [dbo].[Skill] ([TechnologyVersionId]) SELECT [Id] FROM [dbo].[TechnologyVersion]

INSERT INTO [dbo].[Skill] ([TechnologyRoleId]) SELECT [Id] FROM [dbo].[TechnologyRole]

INSERT INTO [dbo].[Skill] ([SoftSkillId]) SELECT [Id] FROM [dbo].[SoftSkill]

INSERT INTO [dbo].[Skill] ([BusinessAreaId]) SELECT [Id] FROM [dbo].[BusinessArea]

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.80 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v5.0' AND [AS].[Code] = 'ANGULAR v4.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.70 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v5.0' AND [AS].[Code] = 'ANGULAR v2.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.50 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v5.0' AND [AS].[Code] = 'ANGULAR vJS'

INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.95 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v4.0' AND [AS].[Code] = 'ANGULAR v5.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.80 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v4.0' AND [AS].[Code] = 'ANGULAR v2.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.60 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v4.0' AND [AS].[Code] = 'ANGULAR vJS'

INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.80 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v2.0' AND [AS].[Code] = 'ANGULAR v5.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.90 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v2.0' AND [AS].[Code] = 'ANGULAR v4.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.70 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR v2.0' AND [AS].[Code] = 'ANGULAR vJS'

INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.70 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR vJS' AND [AS].[Code] = 'ANGULAR v5.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.80 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR vJS' AND [AS].[Code] = 'ANGULAR v4.0'
INSERT INTO [dbo].[SkillRelation] ([SkillId], [AssociatedSkillId], [RelationType], [ConversionFactor]) SELECT [PS].[SkillId], [AS].[SkillId], 2, 0.85 FROM [dbo].[GlobalSkill] AS [PS], [dbo].[GlobalSkill] AS [AS] WHERE [PS].[Code] = 'ANGULAR vJS' AND [AS].[Code] = 'ANGULAR v2.0'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Adrián', 'Belen', NULL, NULL, 77257, 0 , 'MVD/Adrian_Belen.JPG', 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Adrián', 'Lopez', NULL, NULL, 34515, 0 , 'MVD/Adrian_Lopez.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Alberto', 'Da Cunha', NULL, NULL, 33078, 1 , 'MVD/Alberto_Dacunha.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Alberto', 'Hernández', NULL, NULL, 21190, 0 , 'MVD/Alberto_Hernandez.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Alejandro', 'Capece', NULL, NULL, 46798, 0 , 'MVD/Alejandro Capece.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Alejandro', 'Latchinian', NULL, NULL, 58358, 0 , 'MVD/Alejandro_Latchinian.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Alfonso', 'Rodriguez', NULL, NULL, 8677, 1 , 'MVD/Alfonso_Rodriguez.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Alvaro', 'Restuccia', NULL, NULL, 25406, 1 , 'MVD/Alvaro_Restuccia.jpeg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Andrés', 'Bores', NULL, NULL, 79408, 0 , 'MVD/Andres_Bores.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Andrés', 'Maedo', NULL, NULL, 25460, 1 , 'MVD/Andres_Maedo.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Andrés', 'Nieves', NULL, NULL, 42351, 0 , 'MVD/Andres_Nieves.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Aniela', 'Amy', NULL, NULL, 26147, 0 , 'MVD/Aniela_Amy.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Ariel', 'Sisro', NULL, NULL, 632, 0 , 'MVD/Ariel_Sisro.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Beerbal', 'Abdulkhader', NULL, NULL, 80676, 1 , 'MVD/Beerbal_Abdulkhader.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Bruno', 'Candia', NULL, NULL, 90293, 1 , 'MVD/Bruno_Candia.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Camila', 'Roji', NULL, NULL, 28450, 0 , 'MVD/Camila_Roji.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Camila', 'Sorio', NULL, NULL, 89022, 0 , 'MVD/Camila_Sorio.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Camilo', 'Gomez', NULL, NULL, 56411, 1 , 'MVD/Camilo_Gomez.jpeg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Damián', 'Pereira', NULL, NULL, 58945, 1 , 'MVD/Damian_Pereira.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Daniel', 'Cabrera', NULL, NULL, 90259, 0 , 'MVD/Daniel_Cabrera.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Delia', 'Alvarez', NULL, NULL, 24078, 0 , 'MVD/Delia_Alvarez.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Eduardo', 'Ducer', NULL, NULL, 18100, 0 , 'MVD/Eduardo_Ducer.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Eugenia', 'Pais', NULL, NULL, 52654, 1 , 'MVD/Maria_Pais.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Federico', 'Canet', NULL, NULL, 32581, 1 , 'MVD/Federico_Canet.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Federico', 'García', NULL, NULL, 71051, 0 , 'MVD/Federico_Garcia.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Federico', 'Trujillo', NULL, NULL, 2173, 1 , 'MVD/Federico_Trujillo.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Fernando', 'Olmos', NULL, NULL, 20578, 1 , 'MVD/Fernando_Olmos.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Fernando', 'Cañas', NULL, NULL, 97044, 0 , 'MVD/Fernando_Canas.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Fernando', 'Stromillo', NULL, NULL, 33817, 0 , 'MVD/Fernando_Stromillo.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Gastón', 'Aroztegui', NULL, NULL, 59935, 0 , 'MVD/Gaston_Aroztegui.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Gerardo', 'Barbitta', NULL, NULL, 86777, 0 , 'MVD/Gerardo_Barbitta.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Giovanina', 'Chirione', NULL, NULL, 88550, 0 , 'MVD/Giovanina_Chirione.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Hernán', 'Rumbo', NULL, NULL, 53982, 0 , 'MVD/Hernan_Rumbo.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Horacio', 'Blanco', NULL, NULL, 81036, 0 , 'MVD/Horacio_Blanco.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Hugo', 'Ocampo', NULL, NULL, 83026, 0 , 'MVD/Hugo_Ocampo.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Ignacio', 'Assandri', NULL, NULL, 679, 1 , 'MVD/Ignacio_Assandri.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Ignacio', 'Loureiro', NULL, NULL, 78490, 0 , 'MVD/Ignacio_Loureiro.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Ignacio', 'Secco', NULL, NULL, 99628, 0 , 'MVD/Ignacio_Secco.jpeg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Javier', 'Barrios', NULL, NULL, 41633, 0 , 'MVD/Javier_Barrios.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Javier', 'Calero', NULL, NULL, 90859, 0 , 'MVD/Javier_Calero.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Jimena', 'Irigaray', NULL, NULL, 83710, 0 , 'MVD/Jimena_Irigaray.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Jorge', 'Jova', NULL, NULL, 30355, 1 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Juan', 'Aguerre', NULL, NULL, 51821, 0 , 'MVD/Juan_Aguerre.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Juan', 'Estrada', NULL, NULL, 30065, 0 , 'MVD/Juan_Estrada.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Juan Manuel', 'Fagundez', NULL, NULL, 9283, 0 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Leonardo', 'Mendizabal', NULL, NULL, 96996, 0 , 'MVD/Leonardo_Mendizabal.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Luciano', 'Deluca', NULL, NULL, 48654, 0 , 'MVD/Luciano_Deluca.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Malvina', 'Jaume', NULL, NULL, 61094, 0 , 'MVD/Malvina_Jaume.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Marcelo', 'Zepedeo', NULL, NULL, 3398, 0 , 'MVD/Marcelo_Zepedeo.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Marcos', 'Guimaraes', NULL, NULL, 37198, 0 , 'MVD/Marcos_Guimaraes.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'María Julia', 'Etcheverry', NULL, NULL, 60909, 0 , 'MVD/Maria_Etcheverry.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'María Noel', 'Mosqueira', NULL, NULL, 79836, 0 , 'MVD/Maria_Mosqueira.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Marlon', 'González', NULL, NULL, 83487, 0 , 'MVD/Marlon_Gonzalez.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Martín', 'Acosta', NULL, NULL, 12606, 0 , 'MVD/Martin_Acosta.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Martin', 'Caetano', NULL, NULL, 3609, 0 , 'MVD/Martin_Caetano.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Mathías', 'Rodríguez', NULL, NULL, 36857, 1 , 'MVD/Mathias_Rodriguez.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Mauricio', 'Mora', NULL, NULL, 22556, 0 , 'MVD/Mauricio_Mora.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Nicolás', 'Gómez', NULL, NULL, 93105, 1 , 'MVD/Nicolas_Gomez.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Nicolás', 'Lasarte', NULL, NULL, 26317, 1 , 'MVD/Nicolas_Lasarte.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Nicolas', 'Mañay', NULL, NULL, 99054, 0 , 'MVD/Nicolas_Ma¤ay.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Octavio', 'Garbarino', NULL, NULL, 57990, 1 , 'MVD/Octavio_Garbarino.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pablo', 'Cawen', NULL, NULL, 72996, 0 , 'MVD/Pablo_Cawen.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pablo', 'Da Silva', NULL, NULL, 2479, 0 , 'MVD/Pablo_DaSilva.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pablo', 'García', NULL, NULL, 80883, 0 , 'MVD/Pablo_Garcia.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pablo', 'Gus', NULL, NULL, 11059, 0 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pablo', 'Queirolo', NULL, NULL, 3583, 0 , 'MVD/Pablo_Queirolo.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pablo', 'Uriarte', NULL, NULL, 67636, 0 , 'MVD/Pablo_Uriarte.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pedro', 'Minetti', NULL, NULL, 44258, 0 , 'MVD/Pedro_Minetti.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Pedro', 'Tournier', NULL, NULL, 72309, 1 , 'MVD/Pedro_Tournier.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Raidel', 'Gonzalez', NULL, NULL, 44558, 0 , 'MVD/Raidel_Gonzalez.jpeg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Raúl', 'Fossemale', NULL, NULL, 43553, 0 , 'MVD/Raul_Fossemale.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Roberto', 'Assandri', NULL, NULL, 86962, 0 , 'MVD/Roberto_Assandri.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Rodrigo', 'Alvarez', NULL, NULL, 54391, 0 , 'MVD/Rodrigo_Alvarez.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Rodrigo', 'Valdez', NULL, NULL, 51400, 0 , 'MVD/Rodrigo_Valdez.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Ruben', 'Bracco', NULL, NULL, 47173, 0 , 'MVD/Ruben_Bracco.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Santiago', 'Ferreiro', NULL, NULL, 63259, 0 , 'MVD/Santiago_Ferreiro.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Sebastian', 'Queirolo', NULL, NULL, 42205, 0 , 'MVD/Sebastian_Queirolo.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Silvia', 'Derkoyorikian', NULL, NULL, 40244, 0 , 'MVD/Silvia_Derkoyorikian.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Valentín', 'Gadola', NULL, NULL, 10049, 0 , 'MVD/Valentin_Gadola.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Valeria', 'Rotunno', NULL, NULL, 28236, 0 , 'MVD/Valeria_Rotunno.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Victoria', 'Andrada', NULL, NULL, 88872, 0 , 'MVD/Victoria_Andrada.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'William', 'Claro', NULL, NULL, 76073, 0 , 'MVD/William_Claro.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Yago', 'Auza', NULL, NULL, 35839, 0 , 'MVD/Yago_Auza.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Yanara', 'Valdes', NULL, NULL, 92366, 0 , 'MVD/Yanara_Valdes.jpg', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Yony', 'Gómez', NULL, NULL, 49238, 0 , 'MVD/Yony_Gomez.JPG', 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Adrián', 'Costa', NULL, NULL, 54675, 0 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Agustín', 'Narvaez', NULL, NULL, 52745, 1 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Andrea', 'Sabella', NULL, NULL, 88691, 1 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Ezequiel', 'Konjuh', NULL, NULL, 21466, 0 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive]) SELECT [Id], 1, 'Luis', 'Fregeiro', NULL, NULL, 41809, 0 , NULL, 1 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'

INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Adrián' AND [P].[LastName] = 'Belen' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Adrián' AND [P].[LastName] = 'Lopez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Alberto' AND [P].[LastName] = 'Da Cunha' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Alberto' AND [P].[LastName] = 'Hernández' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Alejandro' AND [P].[LastName] = 'Capece' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Alejandro' AND [P].[LastName] = 'Latchinian' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Alfonso' AND [P].[LastName] = 'Rodriguez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Alvaro' AND [P].[LastName] = 'Restuccia' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Andrés' AND [P].[LastName] = 'Bores' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Andrés' AND [P].[LastName] = 'Maedo' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Andrés' AND [P].[LastName] = 'Nieves' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Aniela' AND [P].[LastName] = 'Amy' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Ariel' AND [P].[LastName] = 'Sisro' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Beerbal' AND [P].[LastName] = 'Abdulkhader' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Bruno' AND [P].[LastName] = 'Candia' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Camila' AND [P].[LastName] = 'Roji' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Camila' AND [P].[LastName] = 'Sorio' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Camilo' AND [P].[LastName] = 'Gomez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Damián' AND [P].[LastName] = 'Pereira' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Daniel' AND [P].[LastName] = 'Cabrera' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Delia' AND [P].[LastName] = 'Alvarez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Eduardo' AND [P].[LastName] = 'Ducer' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Eugenia' AND [P].[LastName] = 'Pais' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Federico' AND [P].[LastName] = 'Canet' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Federico' AND [P].[LastName] = 'García' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Federico' AND [P].[LastName] = 'Trujillo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Fernando' AND [P].[LastName] = 'Olmos' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Fernando' AND [P].[LastName] = 'Cañas' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Fernando' AND [P].[LastName] = 'Stromillo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Gastón' AND [P].[LastName] = 'Aroztegui' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Gerardo' AND [P].[LastName] = 'Barbitta' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Giovanina' AND [P].[LastName] = 'Chirione' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Hernán' AND [P].[LastName] = 'Rumbo' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Horacio' AND [P].[LastName] = 'Blanco' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Hugo' AND [P].[LastName] = 'Ocampo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Ignacio' AND [P].[LastName] = 'Assandri' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Ignacio' AND [P].[LastName] = 'Loureiro' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Ignacio' AND [P].[LastName] = 'Secco' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Javier' AND [P].[LastName] = 'Barrios' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Javier' AND [P].[LastName] = 'Calero' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Jimena' AND [P].[LastName] = 'Irigaray' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Jorge' AND [P].[LastName] = 'Jova' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Juan' AND [P].[LastName] = 'Aguerre' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Juan' AND [P].[LastName] = 'Estrada' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Juan Manuel' AND [P].[LastName] = 'Fagundez' AND [PR].[Code] = 'SRV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Leonardo' AND [P].[LastName] = 'Mendizabal' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Luciano' AND [P].[LastName] = 'Deluca' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Malvina' AND [P].[LastName] = 'Jaume' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Marcelo' AND [P].[LastName] = 'Zepedeo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Marcos' AND [P].[LastName] = 'Guimaraes' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'María Julia' AND [P].[LastName] = 'Etcheverry' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'María Noel' AND [P].[LastName] = 'Mosqueira' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Marlon' AND [P].[LastName] = 'González' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Martín' AND [P].[LastName] = 'Acosta' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Martin' AND [P].[LastName] = 'Caetano' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Mathías' AND [P].[LastName] = 'Rodríguez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Mauricio' AND [P].[LastName] = 'Mora' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Nicolás' AND [P].[LastName] = 'Gómez' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Nicolás' AND [P].[LastName] = 'Lasarte' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Nicolas' AND [P].[LastName] = 'Mañay' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Octavio' AND [P].[LastName] = 'Garbarino' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Cawen' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Da Silva' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'García' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Gus' AND [PR].[Code] = 'SRV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Queirolo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Uriarte' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pedro' AND [P].[LastName] = 'Minetti' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pedro' AND [P].[LastName] = 'Tournier' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Raidel' AND [P].[LastName] = 'Gonzalez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Raúl' AND [P].[LastName] = 'Fossemale' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Roberto' AND [P].[LastName] = 'Assandri' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Rodrigo' AND [P].[LastName] = 'Alvarez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Rodrigo' AND [P].[LastName] = 'Valdez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Ruben' AND [P].[LastName] = 'Bracco' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Santiago' AND [P].[LastName] = 'Ferreiro' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Sebastian' AND [P].[LastName] = 'Queirolo' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Silvia' AND [P].[LastName] = 'Derkoyorikian' AND [PR].[Code] = 'DBA'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Valentín' AND [P].[LastName] = 'Gadola' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Valeria' AND [P].[LastName] = 'Rotunno' AND [PR].[Code] = 'ADMIN'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Victoria' AND [P].[LastName] = 'Andrada' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'William' AND [P].[LastName] = 'Claro' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Yago' AND [P].[LastName] = 'Auza' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Yanara' AND [P].[LastName] = 'Valdes' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Yony' AND [P].[LastName] = 'Gómez' AND [PR].[Code] = 'UX'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Adrián' AND [P].[LastName] = 'Costa' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Agustín' AND [P].[LastName] = 'Narvaez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Andrea' AND [P].[LastName] = 'Sabella' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Ezequiel' AND [P].[LastName] = 'Konjuh' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Luis' AND [P].[LastName] = 'Fregeiro' AND [PR].[Code] = 'DEV'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

DECLARE @candidateId INT
DECLARE @skillId INT

DECLARE @rndSeeExpertice FLOAT
DECLARE @rndSeeImpact FLOAT
DECLARE @limitSeeImpact FLOAT = 0.2

DECLARE @rndCvExpertice FLOAT
DECLARE @rndCvImpact FLOAT
DECLARE @limitCvImpact FLOAT = 0.2

DECLARE @rndExpExpertice FLOAT
DECLARE @rndExpImpact FLOAT
DECLARE @limitExpImpact FLOAT = 0.2

DECLARE candidate_cursor CURSOR FOR   
SELECT [Id]
FROM [dbo].[Candidate]
  
OPEN candidate_cursor  
  
FETCH NEXT FROM candidate_cursor   
INTO @candidateId 

WHILE @@FETCH_STATUS = 0  
 BEGIN
  DECLARE skill_cursor CURSOR FOR   
  SELECT [Id]
  FROM [dbo].[Skill]
  
  OPEN skill_cursor  
  
  FETCH NEXT FROM skill_cursor   
  INTO @skillId 
  
  WHILE @@FETCH_STATUS = 0  
   BEGIN
    SET @rndSeeExpertice = RAND()
    SET @rndSeeImpact = RAND()

    IF (@rndSeeImpact < @limitSeeImpact)
     BEGIN
      INSERT INTO [dbo].[SkillEstimatedExpertise] (
        [CandidateId],
        [SkillId],
        [Expertise]
      )
      VALUES (
        @candidateId,
        @skillId,
        @rndSeeExpertice
      )
     END


    SET @rndCvExpertice = RAND()
    SET @rndCvImpact = RAND()

    IF (@rndCvImpact < @limitCvImpact)
     BEGIN
      INSERT INTO [dbo].[Evaluation] (
        [CandidateId],
        [SkillId],
        [EvaluationTypeId],
        [Date],
        [Expertise]
      )
      SELECT @candidateId,
             @skillId,
             [Id],
             '2015-01-01',
             @rndCvExpertice
      FROM [dbo].[EvaluationType]
      WHERE [Code] = 'CV'
     END


    SET @rndExpExpertice = RAND()
    SET @rndExpImpact = RAND()

    IF (@rndExpImpact < @limitExpImpact)
     BEGIN
      INSERT INTO [dbo].[Evaluation] (
        [CandidateId],
        [SkillId],
        [EvaluationTypeId],
        [Date],
        [Expertise]
      )
      SELECT @candidateId,
             @skillId,
             [Id],
             '2015-01-01',
             @rndExpExpertice
      FROM [dbo].[EvaluationType]
      WHERE [Code] = 'EXPERT'
     END
     
    FETCH NEXT FROM skill_cursor   
    INTO @skillId 
   END   

  CLOSE skill_cursor;  
  DEALLOCATE skill_cursor; 
    
  FETCH NEXT FROM candidate_cursor   
  INTO @candidateId 
 END   

CLOSE candidate_cursor;  
DEALLOCATE candidate_cursor; 

INSERT INTO [dbo].[SkillEstimatedExpertise] (
  [CandidateId],
  [SkillId],
  [Expertise]
)
SELECT [C].[Id],
       [GS].[SkillId],
       [GS].[DefaultExpertise]
FROM [dbo].[Candidate] AS [C]
CROSS JOIN [dbo].[GlobalSkill] AS [GS]
WHERE NOT EXISTS (SELECT 1
                  FROM [SkillEstimatedExpertise] AS [SEE]
                  WHERE [SEE].[CandidateId] = [C].[Id]
                    AND [SEE].[SkillId] = [GS].[SkillId])


UPDATE [dbo].[SkillEstimatedExpertise]
SET [Expertise] = 0
WHERE [CandidateId] IN (SELECT [CandidateId]
                        FROM [dbo].[CandidateCandidateRole] AS [CCR]
                        INNER JOIN [dbo].[CandidateRole] AS [CR] ON [CR].[Id] = [CCR].[CandidateRoleId]
                        WHERE [CR].[Code] IN ('ADMIN'))
  AND [SkillId] IN (SELECT [Id]
                    FROM [dbo].[Skill] AS [S]
                    WHERE [S].[TechnologyId] IS NOT NULL OR [S].[TechnologyRoleId] IS NOT NULL OR [S].[TechnologyVersionId] IS NOT NULL OR [S].[BusinessAreaId] IS NOT NULL)

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

SELECT * FROM [dbo].[Candidate]

SELECT * FROM [dbo].[Skill]

SELECT * FROM [dbo].[GlobalSkill]

SELECT * 
FROM [dbo].[SkillEstimatedExpertise] AS [SEE]
INNER JOIN [dbo].[GlobalSkill] AS [GS] ON [GS].[SkillId] = [SEE].[SkillId]
INNER JOIN [dbo].[Candidate] AS [C] ON [C].[Id] = [SEE].[CandidateId]
ORDER BY [SEE].[CandidateId],
         [SEE].[SkillId]

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
