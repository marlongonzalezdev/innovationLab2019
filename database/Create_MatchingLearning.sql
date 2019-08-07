----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

USE [MatchingLearning]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

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
DROP TABLE IF EXISTS [dbo].[PeoplePeopleRole]
DROP TABLE IF EXISTS [dbo].[People]
DROP TABLE IF EXISTS [dbo].[PeopleRole]
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

CREATE TABLE [dbo].[PeopleRole] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
    
  CONSTRAINT [PK_PeopleRole] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_PeopleRole_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[People] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [DeliveryUnitId]                INT NOT NULL,
  [RelationType]                  INT NOT NULL CONSTRAINT [CH_People_RelationType] CHECK ([RelationType] IN (1, 2, 3)), -- 1: Employee, 2: Candidate, 3: External
  [FirstName]                     [MLName] NOT NULL,
  [LastName]                      [MLName] NOT NULL,
  [DocType]                       INT NULL CONSTRAINT [CH_People_DocType] CHECK ([DocType] IN (1, 2)), -- 1: NationalIdentity, 2: Passport
  [DocNumber]                     NVARCHAR(64) NULL,
  [EmployeeNumber]                INT NULL,
  [InBench]                       BIT NOT NULL,

  CONSTRAINT [PK_People] PRIMARY KEY CLUSTERED ([Id] ASC),
  
  CONSTRAINT [FK_People_DeliveryUnit_DeliveryUnitId] FOREIGN KEY ([DeliveryUnitId]) REFERENCES [dbo].[DeliveryUnit] ([Id]),
)
GO

-- CONSTRAINT [UC_People_EmployeeNumber] NONCLUSTERED ([EmployeeNumber] ASC),

--  CONSTRAINT [UC_People_Doc] NONCLUSTERED ([DocType] ASC, [DocNumber] ASC),

CREATE TABLE [dbo].[PeoplePeopleRole] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [PeopleId]                      INT NOT NULL,
  [PeopleRoleId]                  INT NOT NULL,
  [StartDate]                     DATETIME NOT NULL,
  [EndDate]                       DATETIME NULL,

  CONSTRAINT [PK_PeoplePeopleRole] PRIMARY KEY CLUSTERED ([Id] ASC),
  
  CONSTRAINT [FK_PeoplePeopleRole_People_PeopleId] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([Id]),

  CONSTRAINT [FK_PeoplePeopleRole_PeopleRole_PeopleRoleId] FOREIGN KEY ([PeopleRoleId]) REFERENCES [dbo].[PeopleRole] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Technology] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [IsVersioned]                   BIT NOT NULL,

  CONSTRAINT [PK_Technology] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_Technology_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[TechnologyVersion] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [TechnologyId]                  INT NOT NULL,
  [Version]                       [MLCode] NOT NULL,
  [StartDate]                     DATETIME  NULL,

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

  CONSTRAINT [PK_TechnologyRole] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_TechnologyRole_Code] UNIQUE NONCLUSTERED ([Code] ASC),

  CONSTRAINT [FK_TechnologyRole_Technology_TechnologyId] FOREIGN KEY ([TechnologyId]) REFERENCES [dbo].[Technology] ([Id]),
)
GO

CREATE TABLE [dbo].[SoftSkill] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,

  CONSTRAINT [PK_SoftSkill] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_SoftSkill_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[BusinessArea] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,

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

  [ObsolesenceByYear]             [MLDecimal] NULL,

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
  [SkillId1]                      INT NOT NULL,
  [SkillId2]                      INT NOT NULL,
  [RelationType]                  INT NOT NULL CONSTRAINT [CH_SkillRelation_RelationType] CHECK ([RelationType] IN (1, 2, 3)), -- 1: Parent/Child, 2: Version, , 3: Similar
  [Factor1To2]                    [MLDecimal] NOT NULL,
  [Factor2To1]                    [MLDecimal] NOT NULL,

  CONSTRAINT [PK_SkillRelation] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillRelation_Skill_SkillId1] FOREIGN KEY ([SkillId1]) REFERENCES [dbo].[Skill] ([Id]),

  CONSTRAINT [FK_SkillRelation_Skill_SkillId2] FOREIGN KEY ([SkillId2]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

CREATE TABLE [dbo].[SkillGrades] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [SkillId]                       INT NOT NULL,
  [MinValue]                      [MLDecimal] NOT NULL,
  [MaxValue]                      [MLDecimal] NOT NULL,
  [Description]                   NVARCHAR(MAX) NOT NULL,

  CONSTRAINT [PK_SkillGrades] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillGrades_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

CREATE TABLE [dbo].[SkillLearningCurve] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [SkillId]                       INT NOT NULL,
  [Months]                        INT NOT NULL,
  [AvgExpertise]                  [MLDecimal] NOT NULL,

  CONSTRAINT [PK_SkillLearningCurve] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillLearningCurve_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[EvaluationType] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [Factor]                        [MLDecimal] NOT NULL,

  CONSTRAINT [PK_EvaluationType] PRIMARY KEY CLUSTERED ([Id] ASC),
)
GO

CREATE TABLE [dbo].[Evaluation] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [PeopleId]                      INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [EvaluationKey]                 NVARCHAR(256) NULL,
  [EvaluationTypeId]              INT NOT NULL,
  [Date]                          DATETIME NOT NULL,
  [Expertise]                     [MLDecimal] NOT NULL,
  [Notes]                         NVARCHAR(MAX) NULL,

  CONSTRAINT [PK_Evaluation] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_Evaluation_EvaluationKey] UNIQUE NONCLUSTERED ([EvaluationKey] ASC),

  CONSTRAINT [FK_Evaluation_People_PeopleId] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([Id]),

  CONSTRAINT [FK_Evaluation_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),

  CONSTRAINT [FK_Evaluation_EvaluationType_EvaluationTypeId] FOREIGN KEY ([EvaluationTypeId]) REFERENCES [dbo].[EvaluationType] ([Id]),
)
GO

CREATE TABLE [dbo].[Experience] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [PeopleId]                      INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [StartDate]                     DATETIME NOT NULL,
  [EndDate]                       DATETIME NULL,
  [Percentage]                    [MLDecimal] NOT NULL,

  CONSTRAINT [PK_Experience] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_Experience_People_PeopleId] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([Id]),

  CONSTRAINT [FK_Experience_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[SkillEstimatedExpertise] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [PeopleId]                      INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [Expertise]                     [MLDecimal] NOT NULL,

  CONSTRAINT [PK_SkillEstimatedExpertise] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_SkillEstimatedExpertise_People_PeopleId] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([Id]),

  CONSTRAINT [FK_SkillEstimatedExpertise_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
)
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

INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('PM', 'Project Manager')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('BA', 'Business Analyst')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('DEV', 'Developer')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('TST', 'Tester')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('DBA', 'Database Administrator')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('SRV', 'Servers Administrator')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('NET', 'Networks Administrator')
INSERT INTO [dbo].[PeopleRole] ([Code], [Name]) VALUES ('UX', 'UX Designer')
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('ExpertEvaluation', 0.7)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('LeaderEvaluation', 0.9)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('PairEvaluation', 0.7)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('Interview', 0.9)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('Certification', 0.75)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('Curriculum Vitae', 0.3)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('LinkedIn', 0.1)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('PluralSight', 0.2)
INSERT INTO [dbo].[EvaluationType] ([Name], [Factor]) VALUES ('HackerRank', 0.1)
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('CLOUD', 'CLOUD Computing', 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('AZURE', 'MS Azure', 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('AMZN', 'Amazon AWS', 0)

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('SQL', 'SQL', 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('SQLServer', 'MS SQL Server', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('SQLServerAzure', 'MS SQL Server Azure', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('Oracle', 'Oracle', 1)
GO

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '6.0', '1995-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '6.5', '1996-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.0', '1998-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2000', '2000-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2005', '2005-11-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2008', '2008-08-06' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2008 R2', '2010-04-21' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2012', '2012-03-06' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2014', '2014-03-18' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2016', '2016-06-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2017', '2017-10-02' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
GO

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2010', '2010-01-01' FROM [dbo].[Technology] WHERE [Code] = 'SQLServerAzure'
GO

INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name]) SELECT [Id], 'SQL Srv TSQL Dev', 'MS SQL Server TSQL Developer' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name]) SELECT [Id], 'SQL Srv DBA', 'MS SQL Server Database Administrator' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name]) SELECT [Id], 'SQL Srv IS', 'MS SQL Server Integration Services' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
INSERT INTO [dbo].[TechnologyRole] ([TechnologyId], [Code], [Name]) SELECT [Id], 'SQL Srv SSRS', 'MS SQL Server Reporting Services' FROM [dbo].[Technology] WHERE [Code] = 'SQLServer'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('.NET', '.NET', 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('.NET FRMK', '.NET Framework', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('C#', 'C#', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('VB.NET', 'VB.NET', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('MS C++', 'MS C++', 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.0', '2002-02-13' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.1', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2.0', '2005-11-07' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '3.0', '2006-11-06' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '3.5', '2007-11-19' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.0', '2010-04-12' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.5', '2012-08-15' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.5.1', '2013-10-17' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.5.2', '2014-05-05' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.6', '2015-07-20' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.6.1', '2015-11-30' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.6.2', '2016-08-02' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.7', '2017-04-05' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.7.1', '2017-10-17' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.7.2', '2018-04-30' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.8', '2019-04-18' FROM [dbo].[Technology] WHERE [Code] = '.NET FRMK'

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.0', '2002-02-13' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.1', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.2', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2.0', '2005-11-07' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '3.0', '2007-11-19' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.0', '2010-04-12' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '5.0', '2012-08-15' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '6.0', '2015-07-20' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.0', '2017-03-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.1', '2017-08-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.2', '2017-11-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.3', '2018-01-01' FROM [dbo].[Technology] WHERE [Code] = 'C#'

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.0', '2002-02-13' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7.1', '2003-04-24' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '8.0', '2005-11-07' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '9.0', '2007-11-19' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '10.0', '2010-04-12' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '11.0', '2012-08-15' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '14.0', '2015-07-20' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '15.0', '2017-04-05' FROM [dbo].[Technology] WHERE [Code] = 'VB.NET'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('JAVA', 'JAVA', 0)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('JDK', 'JDK', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('J2SE', 'J2SE', 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('JAVA SE', 'Java SE', 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.0', '1996-01-01' FROM [dbo].[Technology] WHERE [Code] = 'JDK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.1', '1997-02-01' FROM [dbo].[Technology] WHERE [Code] = 'JDK'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.2', '1998-12-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.3', '2000-05-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '1.4', '2002-02-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '5.0', '2004-09-01' FROM [dbo].[Technology] WHERE [Code] = 'J2SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '6', '2006-12-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '7', '2011-07-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '8', '2014-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '9', '2017-09-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '10', '2018-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '11', '2018-09-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '12', '2019-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JAVA SE'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [IsVersioned]) VALUES ('ANGULAR', 'Angular', 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], 'JS', '2010-01-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '2.0', '2016-09-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '4.0', '2017-03-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [Version], [StartDate]) SELECT [Id], '5.0', '2017-11-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('COMM', 'Communication')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('LEAD', 'Leadership')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('PLAN', 'Planning')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('TIME', 'Time Management')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('PROB', 'Problem Solving')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('TEAM', 'Team Player')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('CONF', 'Self-Confidence')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('FLEX', 'Flexibility/Adaptability')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('PRES', 'Working Well Under Pressure')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('POSI', 'Positive Attitude')

INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('OENG', 'Oral English')
INSERT INTO [dbo].[SoftSkill] ([Code], [Name]) VALUES ('WENG', 'Writting English')

GO

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('BANK', 'Banking')
INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('CRED', 'Credit Cards')
INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('INS', 'Insurance')
INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('ENER', 'Energy')
INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('RET', 'Retail')
INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('LOG', 'Logistics')
INSERT INTO [dbo].[BusinessArea] ([Code], [Name]) VALUES ('MAN', 'Manufacturing')
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Daniel', 'Cabrera', NULL, NULL, 16429, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Yony', 'Gomez', NULL, NULL, 13163, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Fernando', 'Olmos', NULL, NULL, 29707, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Eugenia', 'Pais', NULL, NULL, 96919, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Marcelo', 'Zepedeo', NULL, NULL, 95795, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Adrián', 'Belen', NULL, NULL, 87138, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Pablo', 'Queirolo', NULL, NULL, 69873, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Alfonso', 'Rodriguez', NULL, NULL, 26013, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Hernan', 'Rumbo', NULL, NULL, 51488, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Orlando', 'Garbarino', NULL, NULL, 15830, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Bruno', 'Candia', NULL, NULL, 11534, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Victoria', 'Andrada', NULL, NULL, 90896, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Mathías', 'Rodriguez', NULL, NULL, 41007, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'

INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Delia', 'Álvarez', NULL, NULL, 54393, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Yanara', 'Valdez', NULL, NULL, 79078, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Marlon', 'González', NULL, NULL, 27082, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'William', 'Claro', NULL, NULL, 33169, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'

INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Adrián', 'Costa', NULL, NULL, 14537, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Agustín', 'Narvaez', NULL, NULL, 75797, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Andrea', 'Sabella', NULL, NULL, 12231, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Ezequiel', 'Konjuh', NULL, NULL, 64668, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[People] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench]) SELECT [Id], 1, 'Luis', 'Fregeiro', NULL, NULL, 53014, 0 FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'

----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Daniel' AND [P].[LastName] = 'Cabrera' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Yony' AND [P].[LastName] = 'Gomez' AND [PR].[Code] = 'UX'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Fernando' AND [P].[LastName] = 'Olmos' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Eugenia' AND [P].[LastName] = 'Pais' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Marcelo' AND [P].[LastName] = 'Zepedeo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Adrián' AND [P].[LastName] = 'Belen' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Queirolo' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Alfonso' AND [P].[LastName] = 'Rodriguez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Hernan' AND [P].[LastName] = 'Rumbo' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Orlando' AND [P].[LastName] = 'Garbarino' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Bruno' AND [P].[LastName] = 'Candia' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Victoria' AND [P].[LastName] = 'Andrada' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Mathías' AND [P].[LastName] = 'Rodriguez' AND [PR].[Code] = 'DEV'

INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Delia' AND [P].[LastName] = 'Álvarez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Yanara' AND [P].[LastName] = 'Valdez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Marlon' AND [P].[LastName] = 'González' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'William' AND [P].[LastName] = 'Claro' AND [PR].[Code] = 'DEV'

INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Adrián' AND [P].[LastName] = 'Costa' AND [PR].[Code] = 'PM'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Agustín' AND [P].[LastName] = 'Narvaez' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Andrea' AND [P].[LastName] = 'Sabella' AND [PR].[Code] = 'TST'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Ezequiel' AND [P].[LastName] = 'Konjuh' AND [PR].[Code] = 'DEV'
INSERT INTO [dbo].[PeoplePeopleRole] ([PeopleId], [PeopleRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[People] AS P, [dbo].[PeopleRole] AS [PR] WHERE [P].[FirstName] = 'Luis' AND [P].[LastName] = 'Fregeiro' AND [PR].[Code] = 'DEV'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


