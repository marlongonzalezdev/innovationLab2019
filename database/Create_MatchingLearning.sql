----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

USE [MatchingLearning]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS [dbo].[RandomDate]
DROP FUNCTION IF EXISTS [dbo].[RandomBench]
DROP FUNCTION IF EXISTS [dbo].[RandomCandidateRole]
DROP FUNCTION IF EXISTS [dbo].[RandomCandidateGrade]
DROP FUNCTION IF EXISTS [dbo].[RandomDeliveryUnit]
DROP FUNCTION IF EXISTS [dbo].[RandomRelationType]
DROP FUNCTION IF EXISTS [dbo].[RandomEvaluationType]
DROP FUNCTION IF EXISTS [dbo].[RandomProject]

DROP FUNCTION IF EXISTS [dbo].[GradeFromStr]
GO

DROP VIEW IF EXISTS [dbo].[GlobalSkill]

DROP TABLE IF EXISTS [dbo].[SkillEstimatedExpertise]
DROP TABLE IF EXISTS [dbo].[Experience]
DROP TABLE IF EXISTS [dbo].[EvaluationDetail]
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
DROP TABLE IF EXISTS [dbo].[Project]
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

CREATE FUNCTION [dbo].[RandomDate] (@daysRange INT, @rnd FLOAT) RETURNS DATETIME
AS
 BEGIN
  DECLARE @res DATETIME

  DECLARE @baseDaysRange FLOAT = @daysRange  
  DECLARE @currentDate DATE = GetDate()
  DECLARE @rndDays INT
  
  SET @rndDays = (@rnd * @baseDaysRange)  
  SET @res = DATEADD(DD, -@rndDays, @currentDate)

  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomProject] (@rnd FLOAT) RETURNS INT
AS
 BEGIN  
  DECLARE @res INT
  
  SET @res = 1 + (@rnd * 100)  

  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomBench] (@rnd FLOAT) RETURNS BIT
AS
 BEGIN  
  DECLARE @res BIT
  
  IF (@rnd < 0.05)
   BEGIN
    SET @res = 1
   END
  ELSE
   BEGIN
    SET @res = 0
   END

  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomCandidateRole] (@rnd FLOAT) RETURNS INT
AS
 BEGIN
  DECLARE @res INT

  IF (@rnd < 0.85)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'DEV')
   END
  ELSE IF (@rnd < 0.85)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'TST')
   END
  ELSE IF (@rnd < 0.95)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'PM')
   END
  ELSE IF (@rnd < 0.93)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'DBA')
   END
  ELSE IF (@rnd < 0.95)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'UX')
   END
  ELSE IF (@rnd < 0.97)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'OPS')
   END
  ELSE IF (@rnd < 0.985)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'BA')
   END
  ELSE
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'ADMIN')
   END
   
  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomCandidateGrade] (@rnd FLOAT) RETURNS INT
AS
 BEGIN
  DECLARE @res INT

  IF (@rnd < 0.1)
   BEGIN
    SET @res = 1 -- IN
   END
  ELSE IF (@rnd < 0.2)
   BEGIN
    SET @res = 2 -- JT
   END
  ELSE IF (@rnd < 0.3)
   BEGIN
    SET @res = 3 -- TL
   END
  ELSE IF (@rnd < 0.5)
   BEGIN
    SET @res = 4 -- ST
   END
  ELSE IF (@rnd < 0.7)
   BEGIN
    SET @res = 5 -- EN
   END
  ELSE IF (@rnd < 0.8)
   BEGIN
    SET @res = 6 -- SE
   END
  ELSE IF (@rnd < 0.9)
   BEGIN
    SET @res = 7 -- CL
   END
  ELSE IF (@rnd < 0.95)
   BEGIN
    SET @res = 8 -- SC
   END
  ELSE IF (@rnd < 0.98)
   BEGIN
    SET @res = 9 -- ML
   END
  ELSE IF (@rnd < 1)
   BEGIN
    SET @res = 10 -- SM
   END
  ELSE IF (@rnd < 1)
   BEGIN
    SET @res = 11 -- BM
   END
  ELSE IF (@rnd < 1)
   BEGIN
    SET @res = 12 -- BD
   END
  ELSE
   BEGIN
    SET @res = 13 -- DR
   END
   
  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomDeliveryUnit] (@rnd FLOAT) RETURNS INT
AS
 BEGIN
  DECLARE @res INT
  
  SET @res = 1 + (@rnd * 11)  

  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomRelationType] (@rnd FLOAT) RETURNS INT
AS
 BEGIN
  DECLARE @res INT
  
  SET @res = 1 + (@rnd * 2)  

  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[RandomEvaluationType] (@rnd FLOAT) RETURNS INT
AS
 BEGIN
  DECLARE @res INT
  
  SET @res = 1 + (@rnd * 7)  

  RETURN @res
 END
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[GradeFromStr] (@gradeCode NVARCHAR(2)) RETURNS INT
AS
 BEGIN
  DECLARE @res INT

  IF (@gradeCode = 'IN')
   BEGIN
    SET @res = 1 -- IN
   END
  ELSE IF (@gradeCode = 'JT')
   BEGIN
    SET @res = 2 -- JT
   END
  ELSE IF (@gradeCode = 'TL')
   BEGIN
    SET @res = 3 -- TL
   END
  ELSE IF (@gradeCode = 'ST')
   BEGIN
    SET @res = 4 -- ST
   END
  ELSE IF (@gradeCode = 'EN')
   BEGIN
    SET @res = 5 -- EN
   END
  ELSE IF (@gradeCode = 'SE')
   BEGIN
    SET @res = 6 -- SE
   END
  ELSE IF (@gradeCode = 'CL')
   BEGIN
    SET @res = 7 -- CL
   END
  ELSE IF (@gradeCode = 'SC')
   BEGIN
    SET @res = 8 -- SC
   END
  ELSE IF (@gradeCode = 'ML')
   BEGIN
    SET @res = 9 -- ML
   END
  ELSE IF (@gradeCode = 'SM')
   BEGIN
    SET @res = 10 -- SM
   END
  ELSE IF (@gradeCode = 'BM')
   BEGIN
    SET @res = 11 -- BM
   END
  ELSE IF (@gradeCode = 'BD')
   BEGIN
    SET @res = 12 -- BD
   END
  ELSE IF (@gradeCode = 'DR')
   BEGIN
    SET @res = 13 -- DR
   END
  ELSE
   BEGIN
    SET @res = -1 -- Error
   END

  RETURN @res
 END
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

CREATE TABLE [dbo].[Project] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
    
  CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_Project_Code] UNIQUE NONCLUSTERED ([Code] ASC),
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
  [Grade]                         INT CONSTRAINT [CH_Candidate_Grade] CHECK ([Grade] BETWEEN 1 AND 13), -- 1: IN, 2: JT, 3: TL, 4: ST, 5: EN, 6: SE, 7: CL, 8: SC, 9: ML, 10: SM, 11: BM, 12: BD, 13: DR
  [CurrentProjectId]              INT NULL,
  [CurrentProjectJoin]            DATETIME NULL,

  CONSTRAINT [PK_Candidate] PRIMARY KEY CLUSTERED ([Id] ASC),
  
  CONSTRAINT [FK_Candidate_DeliveryUnit_DeliveryUnitId] FOREIGN KEY ([DeliveryUnitId]) REFERENCES [dbo].[DeliveryUnit] ([Id]),
  CONSTRAINT [FK_Candidate_Project_CurrentProjectId] FOREIGN KEY ([CurrentProjectId]) REFERENCES [dbo].[Project] ([Id]),
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
  [EvaluationKey]                 NVARCHAR(256) NULL,
  [EvaluationTypeId]              INT NOT NULL,
  [Date]                          DATETIME NOT NULL,
  [Notes]                         NVARCHAR(MAX) NULL,

  CONSTRAINT [PK_Evaluation] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_Evaluation_Candidate_CandidateId] FOREIGN KEY ([CandidateId]) REFERENCES [dbo].[Candidate] ([Id]),

  CONSTRAINT [FK_Evaluation_EvaluationType_EvaluationTypeId] FOREIGN KEY ([EvaluationTypeId]) REFERENCES [dbo].[EvaluationType] ([Id]),
)
GO

CREATE TABLE [dbo].[EvaluationDetail] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [EvaluationId]                  INT NOT NULL,
  [SkillId]                       INT NOT NULL,
  [Expertise]                     [MLDecimal] NOT NULL CONSTRAINT [CH_Evaluation_Expertise] CHECK ([Expertise] BETWEEN 0.0 AND 1.0),

  CONSTRAINT [PK_EvaluationDetail] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [FK_EvaluationDetail_Evaluation_EvaluationId] FOREIGN KEY ([EvaluationId]) REFERENCES [dbo].[Evaluation] ([Id]),

  CONSTRAINT [FK_EvaluationDetail_Skill_SkillId] FOREIGN KEY ([SkillId]) REFERENCES [dbo].[Skill] ([Id]),
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
INSERT INTO [dbo].[CandidateRole] ([Code], [Name]) VALUES ('OPS', 'DevOps')
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
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('SQLSERVER', 'MS SQL Server', 0.2, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('SQLSERVERAZURE', 'MS SQL Server Azure', 0.15, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('ORACLE', 'Oracle', 0.1, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('MYSQL', 'MySql', 0.1, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('POSTGRESQL', 'PostgreSQL', 0.1, 1)
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

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('JS', 'JavaScript', 0.0, 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.0', '1996-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.1', '1996-08-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.2', '1997-06-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.3', '1998-10-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.5', '2000-11-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.6', '2005-11-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.7', '2006-10-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.8', '2008-06-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.8.1', '2009-06-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.8.2', '2010-01-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '1.8.5', '2011-03-01' FROM [dbo].[Technology] WHERE [Code] = 'JS'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('ANGULAR', 'Angular', 0.0, 1)

INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, 'JS', '2010-01-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '2.0', '2016-09-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '4.0', '2017-03-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
INSERT INTO [dbo].[TechnologyVersion] ([TechnologyId], [DefaultExpertise], [Version], [StartDate]) SELECT [Id], 0.0, '5.0', '2017-11-01' FROM [dbo].[Technology] WHERE [Code] = 'ANGULAR'
GO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('PYTHON', 'Python', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('RUBY', 'Ruby', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('PHP', 'PHP', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('NODEJS', 'Node.js', 0.0, 1)

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('GO', 'Go', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('SWIFT', 'Swift', 0.0, 1)

INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('CSS', 'CSS', 0.0, 1)
INSERT INTO [dbo].[Technology] ([Code], [Name], [DefaultExpertise], [IsVersioned]) VALUES ('HTML', 'HTML', 0.0, 1)

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

INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P001', 'Project #001')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P002', 'Project #002')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P003', 'Project #003')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P004', 'Project #004')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P005', 'Project #005')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P006', 'Project #006')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P007', 'Project #007')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P008', 'Project #008')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P009', 'Project #009')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P010', 'Project #010')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P011', 'Project #011')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P012', 'Project #012')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P013', 'Project #013')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P014', 'Project #014')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P015', 'Project #015')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P016', 'Project #016')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P017', 'Project #017')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P018', 'Project #018')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P019', 'Project #019')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P020', 'Project #020')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P021', 'Project #021')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P022', 'Project #022')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P023', 'Project #023')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P024', 'Project #024')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P025', 'Project #025')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P026', 'Project #026')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P027', 'Project #027')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P028', 'Project #028')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P029', 'Project #029')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P030', 'Project #030')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P031', 'Project #031')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P032', 'Project #032')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P033', 'Project #033')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P034', 'Project #034')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P035', 'Project #035')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P036', 'Project #036')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P037', 'Project #037')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P038', 'Project #038')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P039', 'Project #039')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P040', 'Project #040')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P041', 'Project #041')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P042', 'Project #042')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P043', 'Project #043')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P044', 'Project #044')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P045', 'Project #045')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P046', 'Project #046')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P047', 'Project #047')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P048', 'Project #048')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P049', 'Project #049')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P050', 'Project #050')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P051', 'Project #051')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P052', 'Project #052')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P053', 'Project #053')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P054', 'Project #054')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P055', 'Project #055')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P056', 'Project #056')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P057', 'Project #057')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P058', 'Project #058')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P059', 'Project #059')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P060', 'Project #060')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P061', 'Project #061')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P062', 'Project #062')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P063', 'Project #063')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P064', 'Project #064')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P065', 'Project #065')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P066', 'Project #066')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P067', 'Project #067')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P068', 'Project #068')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P069', 'Project #069')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P070', 'Project #070')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P071', 'Project #071')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P072', 'Project #072')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P073', 'Project #073')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P074', 'Project #074')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P075', 'Project #075')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P076', 'Project #076')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P077', 'Project #077')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P078', 'Project #078')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P079', 'Project #079')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P080', 'Project #080')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P081', 'Project #081')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P082', 'Project #082')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P083', 'Project #083')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P084', 'Project #084')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P085', 'Project #085')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P086', 'Project #086')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P087', 'Project #087')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P088', 'Project #088')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P089', 'Project #089')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P090', 'Project #090')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P091', 'Project #091')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P092', 'Project #092')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P093', 'Project #093')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P094', 'Project #094')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P095', 'Project #095')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P096', 'Project #096')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P097', 'Project #097')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P098', 'Project #098')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P099', 'Project #099')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ('P100', 'Project #100')
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Adrián', 'Belen', NULL, NULL, 71548, 0 , 'MVD/Adrian_Belen.JPG', 0, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Adrián', 'Lopez', NULL, NULL, 87969, 0 , 'MVD/Adrian_Lopez.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Alberto', 'Da Cunha', NULL, NULL, 49723, 1 , 'MVD/Alberto_Dacunha.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Alberto', 'Hernández', NULL, NULL, 62289, 0 , 'MVD/Alberto_Hernandez.jpg', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Alejandro', 'Capece', NULL, NULL, 24890, 0 , 'MVD/Alejandro Capece.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Alejandro', 'Latchinian', NULL, NULL, 19450, 0 , 'MVD/Alejandro_Latchinian.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Alfonso', 'Rodriguez', NULL, NULL, 19819, 1 , 'MVD/Alfonso_Rodriguez.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Alvaro', 'Restuccia', NULL, NULL, 74146, 1 , 'MVD/Alvaro_Restuccia.jpeg', 1, [dbo].[GradeFromStr]('CL') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Andrés', 'Bores', NULL, NULL, 19581, 0 , 'MVD/Andres_Bores.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Andrés', 'Maedo', NULL, NULL, 10509, 1 , 'MVD/Andres_Maedo.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Andrés', 'Nieves', NULL, NULL, 31005, 0 , 'MVD/Andres_Nieves.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Aniela', 'Amy', NULL, NULL, 78364, 0 , 'MVD/Aniela_Amy.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Ariel', 'Sisro', NULL, NULL, 28424, 0 , 'MVD/Ariel_Sisro.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Beerbal', 'Abdulkhader', NULL, NULL, 24953, 1 , 'MVD/Beerbal_Abdulkhader.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Bruno', 'Candia', NULL, NULL, 3429, 1 , 'MVD/Bruno_Candia.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Camila', 'Roji', NULL, NULL, 543, 0 , 'MVD/Camila_Roji.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Camila', 'Sorio', NULL, NULL, 71157, 0 , 'MVD/Camila_Sorio.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Camilo', 'Gomez', NULL, NULL, 33111, 1 , 'MVD/Camilo_Gomez.jpeg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Damián', 'Pereira', NULL, NULL, 52846, 1 , 'MVD/Damian_Pereira.JPG', 1, [dbo].[GradeFromStr]('CL') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Daniel', 'Cabrera', NULL, NULL, 94483, 0 , 'MVD/Daniel_Cabrera.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Delia', 'Alvarez', NULL, NULL, 51761, 0 , 'MVD/Delia_Alvarez.jpg', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Eduardo', 'Ducer', NULL, NULL, 80042, 0 , 'MVD/Eduardo_Ducer.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Eugenia', 'Pais', NULL, NULL, 13160, 1 , 'MVD/Maria_Pais.jpg', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Federico', 'Canet', NULL, NULL, 69093, 1 , 'MVD/Federico_Canet.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Federico', 'García', NULL, NULL, 21080, 0 , 'MVD/Federico_Garcia.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Federico', 'Trujillo', NULL, NULL, 81091, 1 , 'MVD/Federico_Trujillo.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Fernando', 'Olmos', NULL, NULL, 8655, 1 , 'MVD/Fernando_Olmos.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Fernando', 'Cañas', NULL, NULL, 84854, 0 , 'MVD/Fernando_Canas.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Fernando', 'Stromillo', NULL, NULL, 87871, 0 , 'MVD/Fernando_Stromillo.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Gastón', 'Aroztegui', NULL, NULL, 90764, 0 , 'MVD/Gaston_Aroztegui.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Gerardo', 'Barbitta', NULL, NULL, 43613, 0 , 'MVD/Gerardo_Barbitta.jpg', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Giovanina', 'Chirione', NULL, NULL, 67402, 0 , 'MVD/Giovanina_Chirione.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Hernán', 'Rumbo', NULL, NULL, 49566, 0 , 'MVD/Hernan_Rumbo.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Horacio', 'Blanco', NULL, NULL, 5971, 0 , 'MVD/Horacio_Blanco.JPG', 1, [dbo].[GradeFromStr]('CL') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Hugo', 'Ocampo', NULL, NULL, 2059, 0 , 'MVD/Hugo_Ocampo.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Ignacio', 'Assandri', NULL, NULL, 72580, 1 , 'MVD/Ignacio_Assandri.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Ignacio', 'Loureiro', NULL, NULL, 72259, 0 , 'MVD/Ignacio_Loureiro.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Ignacio', 'Secco', NULL, NULL, 39204, 0 , 'MVD/Ignacio_Secco.jpeg', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Javier', 'Barrios', NULL, NULL, 7938, 0 , 'MVD/Javier_Barrios.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Javier', 'Calero', NULL, NULL, 35010, 0 , 'MVD/Javier_Calero.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Jimena', 'Irigaray', NULL, NULL, 9494, 0 , 'MVD/Jimena_Irigaray.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Jorge', 'Jova', NULL, NULL, 76049, 1 , NULL, 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Juan', 'Aguerre', NULL, NULL, 63712, 0 , 'MVD/Juan_Aguerre.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Juan', 'Estrada', NULL, NULL, 16777, 0 , 'MVD/Juan_Estrada.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Juan Manuel', 'Fagundez', NULL, NULL, 16744, 0 , NULL, 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Leonardo', 'Mendizabal', NULL, NULL, 51876, 0 , 'MVD/Leonardo_Mendizabal.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Luciano', 'Deluca', NULL, NULL, 8098, 0 , 'MVD/Luciano_Deluca.JPG', 1, [dbo].[GradeFromStr]('SC') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Malvina', 'Jaume', NULL, NULL, 34423, 0 , 'MVD/Malvina_Jaume.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Marcelo', 'Zepedeo', NULL, NULL, 9472, 0 , 'MVD/Marcelo_Zepedeo.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Marcos', 'Guimaraes', NULL, NULL, 29563, 0 , 'MVD/Marcos_Guimaraes.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'María Julia', 'Etcheverry', NULL, NULL, 55612, 0 , 'MVD/Maria_Etcheverry.jpg', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'María Noel', 'Mosqueira', NULL, NULL, 74625, 0 , 'MVD/Maria_Mosqueira.JPG', 1, [dbo].[GradeFromStr]('TL') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Marlon', 'González', NULL, NULL, 17979, 0 , 'MVD/Marlon_Gonzalez.jpg', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Martín', 'Acosta', NULL, NULL, 96407, 0 , 'MVD/Martin_Acosta.jpg', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Martin', 'Caetano', NULL, NULL, 83517, 0 , 'MVD/Martin_Caetano.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Mathías', 'Rodríguez', NULL, NULL, 47924, 1 , 'MVD/Mathias_Rodriguez.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Mauricio', 'Mora', NULL, NULL, 95184, 0 , 'MVD/Mauricio_Mora.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Nicolás', 'Gómez', NULL, NULL, 87246, 1 , 'MVD/Nicolas_Gomez.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Nicolás', 'Lasarte', NULL, NULL, 55683, 1 , 'MVD/Nicolas_Lasarte.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Nicolas', 'Mañay', NULL, NULL, 52658, 0 , 'MVD/Nicolas_Manay.jpg', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Octavio', 'Garbarino', NULL, NULL, 65204, 1 , 'MVD/Octavio_Garbarino.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pablo', 'Cawen', NULL, NULL, 13493, 0 , 'MVD/Pablo_Cawen.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pablo', 'Da Silva', NULL, NULL, 61913, 0 , 'MVD/Pablo_DaSilva.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pablo', 'García', NULL, NULL, 20851, 0 , 'MVD/Pablo_Garcia.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pablo', 'Gus', NULL, NULL, 94261, 0 , NULL, 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pablo', 'Queirolo', NULL, NULL, 45259, 0 , 'MVD/Pablo_Queirolo.jpg', 1, [dbo].[GradeFromStr]('SC') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pablo', 'Uriarte', NULL, NULL, 80883, 0 , 'MVD/Pablo_Uriarte.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pedro', 'Minetti', NULL, NULL, 59765, 0 , 'MVD/Pedro_Minetti.jpg', 1, [dbo].[GradeFromStr]('SM') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Pedro', 'Tournier', NULL, NULL, 51598, 1 , 'MVD/Pedro_Tournier.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Raidel', 'Gonzalez', NULL, NULL, 79674, 0 , 'MVD/Raidel_Gonzalez.jpeg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Raúl', 'Fossemale', NULL, NULL, 23331, 0 , 'MVD/Raul_Fossemale.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Roberto', 'Assandri', NULL, NULL, 13530, 0 , 'MVD/Roberto_Assandri.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Rodrigo', 'Alvarez', NULL, NULL, 93282, 0 , 'MVD/Rodrigo_Alvarez.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Rodrigo', 'Valdez', NULL, NULL, 2994, 0 , 'MVD/Rodrigo_Valdez.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Ruben', 'Bracco', NULL, NULL, 32547, 0 , 'MVD/Ruben_Bracco.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Santiago', 'Ferreiro', NULL, NULL, 99107, 0 , 'MVD/Santiago_Ferreiro.jpg', 1, [dbo].[GradeFromStr]('CL') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Sebastian', 'Queirolo', NULL, NULL, 25302, 0 , 'MVD/Sebastian_Queirolo.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Silvia', 'Derkoyorikian', NULL, NULL, 44500, 0 , 'MVD/Silvia_Derkoyorikian.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Valentín', 'Gadola', NULL, NULL, 88656, 0 , 'MVD/Valentin_Gadola.jpg', 1, [dbo].[GradeFromStr]('SC') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Valeria', 'Rotunno', NULL, NULL, 4264, 0 , 'MVD/Valeria_Rotunno.JPG', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Victoria', 'Andrada', NULL, NULL, 82715, 0 , 'MVD/Victoria_Andrada.JPG', 1, [dbo].[GradeFromStr]('ST') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'William', 'Claro', NULL, NULL, 10899, 1 , 'MVD/William_Claro.JPG', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Yago', 'Auza', NULL, NULL, 51094, 0 , 'MVD/Yago_Auza.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Yanara', 'Valdes', NULL, NULL, 86941, 0 , 'MVD/Yanara_Valdes.jpg', 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Yony', 'Gómez', NULL, NULL, 48926, 0 , 'MVD/Yony_Gomez.JPG', 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'MVD'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Adrián', 'Costa', NULL, NULL, 64124, 0 , NULL, 1, [dbo].[GradeFromStr]('CL') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Agustín', 'Narvaez', NULL, NULL, 30043, 1 , NULL, 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Andrea', 'Sabella', NULL, NULL, 86576, 1 , NULL, 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Ezequiel', 'Konjuh', NULL, NULL, 68067, 0 , NULL, 1, [dbo].[GradeFromStr]('EN') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [DocType], [DocNumber], [EmployeeNumber], [InBench], [Picture], [IsActive], [Grade]) SELECT [Id], 1, 'Luis', 'Fregeiro', NULL, NULL, 44167, 0 , NULL, 1, [dbo].[GradeFromStr]('SE') FROM [dbo].[DeliveryUnit] WHERE [Code] = 'ROS'

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
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Juan Manuel' AND [P].[LastName] = 'Fagundez' AND [PR].[Code] = 'OPS'
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
INSERT INTO [dbo].[CandidateCandidateRole] ([CandidateId], [CandidateRoleId], [StartDate], [EndDate]) SELECT [P].[Id], [PR].[Id], '2015-01-01', NULL FROM [dbo].[Candidate] AS P, [dbo].[CandidateRole] AS [PR] WHERE [P].[FirstName] = 'Pablo' AND [P].[LastName] = 'Gus' AND [PR].[Code] = 'OPS'
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

DECLARE @candidateLimit INT = 100
DECLARE @candidateIdx INT = 1

DECLARE @candidateId INT
DECLARE @candidateRoleId INT
DECLARE @deliveryUnitId INT
DECLARE @relationType INT
DECLARE @inBench BIT
DECLARE @candidateGrade INT

WHILE (@candidateIdx <= @candidateLimit)
 BEGIN
  SET @deliveryUnitId = [dbo].[RandomDeliveryUnit](RAND())
  SET @relationType = [dbo].[RandomRelationType](RAND())
  SET @inBench =  [dbo].[RandomBench](RAND())
  SET @candidateGrade =  [dbo].[RandomCandidateGrade](RAND())

  INSERT INTO [dbo].[Candidate] (
    [DeliveryUnitId],
    [RelationType],
    [FirstName],
    [LastName],
    [DocType],
    [DocNumber],
    [EmployeeNumber],
    [InBench],
    [Picture],
    [IsActive],
    [Grade],
    [CurrentProjectId],
    [CurrentProjectJoin]
  )
  VALUES (
    @deliveryUnitId,
    @relationType,
    'Generic First Name',
    'Generic Last Name',
    NULL,
    NULL,
    NULL,
    @inBench,
    NULL,
    1,
    @candidateGrade,
    NULL,
    NULL
  )

  SET @candidateId = @@IDENTITY
  SET @candidateRoleId = [dbo].[RandomCandidateRole](RAND())

  INSERT INTO [dbo].[CandidateCandidateRole] (
    [CandidateId],
    [CandidateRoleId],
    [StartDate],
    [EndDate]
  )
  VALUES (
    @candidateId,
    @candidateRoleId,
    '2015-01-01',
    NULL
  )

  SET @candidateIdx = @candidateIdx + 1
 END

----------------------------------------------------------------------------------------------------

UPDATE [dbo].[CandidateCandidateRole]
SET [StartDate] = [dbo].[RandomDate](2000, RAND())
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

DECLARE @candidateId INT
DECLARE @skillId INT

DECLARE @rndSeeExpertice FLOAT
DECLARE @rndSeeImpact FLOAT
DECLARE @limitSeeImpact FLOAT = 0.2

DECLARE @evalForCandidate BIT
DECLARE @rndDetailExpertice FLOAT
DECLARE @rndDetailImpact FLOAT
DECLARE @rndEvalImpact FLOAT
DECLARE @limitDetailImpact FLOAT = 0.1
DECLARE @limitEvalImpact FLOAT = 0.25

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
  
  SET @evalForCandidate = 0

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

    -- Random evaluations
    SET @rndEvalImpact = RAND()
    SET @rndDetailImpact = RAND()
    IF (@rndDetailImpact < @limitDetailImpact)
     BEGIN      
       IF ((@rndEvalImpact < @limitEvalImpact) OR (@evalForCandidate = 0))
        BEGIN
         INSERT INTO [dbo].[Evaluation] (
           [CandidateId],
           [EvaluationTypeId],
           [Date]
         )
         VALUES (
           @candidateId,
           [dbo].[RandomEvaluationType](RAND()),
           [dbo].[RandomDate](2000, RAND())
         )
         
         SET @evalForCandidate = 1
        END
     
      SET @rndDetailExpertice = RAND()
      
      INSERT INTO [dbo].[EvaluationDetail] (
        [EvaluationId],
        [SkillId],
        [Expertise]
      )
      SELECT MAX([E].[Id]),
             @skillId,
             @rndDetailExpertice
      FROM [dbo].[Evaluation] AS [E]
      WHERE [E].[CandidateId] = @candidateId
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

DECLARE @candidateInBench BIT

DECLARE candidateproject_cursor CURSOR FOR   
SELECT [Id],
       [InBench]
FROM [dbo].[Candidate]
  
OPEN candidateproject_cursor  
  
FETCH NEXT FROM candidateproject_cursor   
INTO @candidateId,
     @candidateInBench

WHILE @@FETCH_STATUS = 0  
 BEGIN
  IF (@candidateInBench = 1)
   BEGIN
    UPDATE [dbo].[Candidate]
    SET [CurrentProjectId] = NULL,
        [CurrentProjectJoin] = [dbo].[RandomDate](50, RAND())
    WHERE [Id] = @candidateId
   END
  ELSE
   BEGIN
    UPDATE [dbo].[Candidate]
    SET [CurrentProjectId] = [dbo].[RandomProject](RAND()),
        [CurrentProjectJoin] = [dbo].[RandomDate](1000, RAND())
    WHERE [Id] = @candidateId
    END

  FETCH NEXT FROM candidateproject_cursor   
  INTO @candidateId,
       @candidateInBench
 END   

CLOSE candidateproject_cursor;  
DEALLOCATE candidateproject_cursor; 

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

DROP FUNCTION IF EXISTS [dbo].[RandomDate]
DROP FUNCTION IF EXISTS [dbo].[RandomBench]
DROP FUNCTION IF EXISTS [dbo].[RandomCandidateRole]
DROP FUNCTION IF EXISTS [dbo].[RandomCandidateGrade]
DROP FUNCTION IF EXISTS [dbo].[RandomDeliveryUnit]
DROP FUNCTION IF EXISTS [dbo].[RandomRelationType]
DROP FUNCTION IF EXISTS [dbo].[RandomEvaluationType]
DROP FUNCTION IF EXISTS [dbo].[RandomProject]

DROP FUNCTION IF EXISTS [dbo].[GradeFromStr]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
