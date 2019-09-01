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

CREATE TYPE [MLCode] FROM NVARCHAR(64)
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
  
  SET @res = 1 + (@rnd * 1000)  

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

  IF (@rnd < 0.65)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'DEV')
   END
  ELSE IF (@rnd < 0.75)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'TST')
   END
  ELSE IF (@rnd < 0.8)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'BA')
   END
  ELSE IF (@rnd < 0.85)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'PM')
   END
  ELSE IF (@rnd < 0.9)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'DBA')
   END
  ELSE IF (@rnd < 0.93)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'UX')
   END
  ELSE IF (@rnd < 0.96)
   BEGIN
    SET @res = (SELECT [Id] FROM [dbo].[CandidateRole] WHERE [Code] = 'OPS')
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
  [CandidateRoleId]               INT NOT NULL,
  [DocType]                       INT NULL CONSTRAINT [CH_Candidate_DocType] CHECK ([DocType] IN (1, 2)), -- 1: NationalIdentity, 2: Passport
  [DocNumber]                     NVARCHAR(64) NULL,
  [EmployeeNumber]                INT NULL,
  [Picture]                       NVARCHAR(1024) NULL,
  [Grade]                         INT CONSTRAINT [CH_Candidate_Grade] CHECK ([Grade] BETWEEN 1 AND 13), -- 1: IN, 2: JT, 3: TL, 4: ST, 5: EN, 6: SE, 7: CL, 8: SC, 9: ML, 10: SM, 11: BM, 12: BD, 13: DR
  [InBench]                       BIT NOT NULL,
  [CurrentProjectId]              INT NULL,
  [CurrentProjectJoin]            DATETIME NULL,
  [IsActive]                      BIT NOT NULL,

  CONSTRAINT [PK_Candidate] PRIMARY KEY CLUSTERED ([Id] ASC),
  
  CONSTRAINT [FK_Candidate_DeliveryUnit_DeliveryUnitId] FOREIGN KEY ([DeliveryUnitId]) REFERENCES [dbo].[DeliveryUnit] ([Id]),
  CONSTRAINT [FK_Candidate_CandidateRole_CandidateRoleId] FOREIGN KEY ([CandidateRoleId]) REFERENCES [dbo].[CandidateRole] ([Id]),
  CONSTRAINT [FK_Candidate_Project_CurrentProjectId] FOREIGN KEY ([CurrentProjectId]) REFERENCES [dbo].[Project] ([Id]),
)
GO

-- CONSTRAINT [UC_Candidate_EmployeeNumber] NONCLUSTERED ([EmployeeNumber] ASC),
-- CONSTRAINT [UC_Candidate_Doc] NONCLUSTERED ([DocType] ASC, [DocNumber] ASC),

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


INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WALMART', 'WALMART')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXXON_MOBIL', 'EXXON MOBIL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHEVRON', 'CHEVRON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BERKSHIRE_HATHAWAY', 'BERKSHIRE HATHAWAY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APPLE', 'APPLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_MOTORS', 'GENERAL MOTORS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PHILLIPS_66', 'PHILLIPS 66')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_ELECTRIC', 'GENERAL ELECTRIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FORD_MOTOR', 'FORD MOTOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CVS_HEALTH', 'CVS HEALTH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCKESSON', 'MCKESSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AT&T', 'AT&T')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VALERO_ENERGY', 'VALERO ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITEDHEALTH_GROUP', 'UNITEDHEALTH GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VERIZON', 'VERIZON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERISOURCEBERGEN', 'AMERISOURCEBERGEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FANNIE_MAE', 'FANNIE MAE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COSTCO', 'COSTCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HP', 'HP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KROGER', 'KROGER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JP_MORGAN_CHASE', 'JP MORGAN CHASE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPRESS_SCRIPTS_HOLDING', 'EXPRESS SCRIPTS HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BANK_OF_AMERICA_CORP.', 'BANK OF AMERICA CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IBM', 'IBM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARATHON_PETROLEUM', 'MARATHON PETROLEUM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARDINAL_HEALTH', 'CARDINAL HEALTH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOEING', 'BOEING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CITIGROUP', 'CITIGROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMAZON.COM', 'AMAZON.COM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WELLS_FARGO', 'WELLS FARGO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MICROSOFT', 'MICROSOFT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PROCTER_&_GAMBLE', 'PROCTER & GAMBLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOME_DEPOT', 'HOME DEPOT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARCHER_DANIELS_MIDLAND', 'ARCHER DANIELS MIDLAND')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WALGREENS', 'WALGREENS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TARGET', 'TARGET')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JOHNSON_&_JOHNSON', 'JOHNSON & JOHNSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANTHEM', 'ANTHEM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'METLIFE', 'METLIFE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GOOGLE', 'GOOGLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STATE_FARM_INSURANCE_COS.', 'STATE FARM INSURANCE COS.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FREDDIE_MAC', 'FREDDIE MAC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMCAST', 'COMCAST')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEPSICO', 'PEPSICO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_TECHNOLOGIES', 'UNITED TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AIG', 'AIG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UPS', 'UPS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOW_CHEMICAL', 'DOW CHEMICAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AETNA', 'AETNA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LOWES', 'LOWE''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONOCOPHILLIPS', 'CONOCOPHILLIPS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTEL', 'INTEL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGY_TRANSFER_EQUITY', 'ENERGY TRANSFER EQUITY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CATERPILLAR', 'CATERPILLAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRUDENTIAL_FINANCIAL', 'PRUDENTIAL FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PFIZER', 'PFIZER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISNEY', 'DISNEY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUMANA', 'HUMANA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENTERPRISE_PRODUCTS_PARTNERS', 'ENTERPRISE PRODUCTS PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CISCO_SYSTEMS', 'CISCO SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYSCO', 'SYSCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INGRAM_MICRO', 'INGRAM MICRO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COCA-COLA', 'COCA-COLA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LOCKHEED_MARTIN', 'LOCKHEED MARTIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FEDEX', 'FEDEX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JOHNSON_CONTROLS', 'JOHNSON CONTROLS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PLAINS_GP_HOLDINGS', 'PLAINS GP HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WORLD_FUEL_SERVICES', 'WORLD FUEL SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHS', 'CHS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_AIRLINES_GROUP', 'AMERICAN AIRLINES GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERCK', 'MERCK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BEST_BUY', 'BEST BUY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DELTA_AIR_LINES', 'DELTA AIR LINES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HONEYWELL_INTERNATIONAL', 'HONEYWELL INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HCA_HOLDINGS', 'HCA HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GOLDMAN_SACHS_GROUP', 'GOLDMAN SACHS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TESORO', 'TESORO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIBERTY_MUTUAL_INSURANCE_GROUP', 'LIBERTY MUTUAL INSURANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_CONTINENTAL_HOLDINGS', 'UNITED CONTINENTAL HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEW_YORK_LIFE_INSURANCE', 'NEW YORK LIFE INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ORACLE', 'ORACLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MORGAN_STANLEY', 'MORGAN STANLEY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TYSON_FOODS', 'TYSON FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SAFEWAY', 'SAFEWAY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONWIDE', 'NATIONWIDE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DEERE', 'DEERE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DUPONT', 'DUPONT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_EXPRESS', 'AMERICAN EXPRESS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLSTATE', 'ALLSTATE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIGNA', 'CIGNA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MONDELEZ_INTERNATIONAL', 'MONDELEZ INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIAA-CREF', 'TIAA-CREF')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTL_FCSTONE', 'INTL FCSTONE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASSACHUSETTS_MUTUAL_LIFE_INSURANCE', 'MASSACHUSETTS MUTUAL LIFE INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DIRECTV', 'DIRECTV')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HALLIBURTON', 'HALLIBURTON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TWENTY-FIRST_CENTURY_FOX', 'TWENTY-FIRST CENTURY FOX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( '3M', '3M')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEARS_HOLDINGS', 'SEARS HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_DYNAMICS', 'GENERAL DYNAMICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUBLIX_SUPER_MARKETS', 'PUBLIX SUPER MARKETS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PHILIP_MORRIS_INTERNATIONAL', 'PHILIP MORRIS INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TJX', 'TJX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIME_WARNER', 'TIME WARNER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MACYS', 'MACY''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NIKE', 'NIKE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TECH_DATA', 'TECH DATA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVNET', 'AVNET')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHWESTERN_MUTUAL', 'NORTHWESTERN MUTUAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCDONALDS', 'MCDONALD''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXELON', 'EXELON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRAVELERS_COS.', 'TRAVELERS COS.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUALCOMM', 'QUALCOMM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERNATIONAL_PAPER', 'INTERNATIONAL PAPER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OCCIDENTAL_PETROLEUM', 'OCCIDENTAL PETROLEUM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DUKE_ENERGY', 'DUKE ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RITE_AID', 'RITE AID')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GILEAD_SCIENCES', 'GILEAD SCIENCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BAKER_HUGHES', 'BAKER HUGHES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EMERSON_ELECTRIC', 'EMERSON ELECTRIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EMC', 'EMC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'USAA', 'USAA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNION_PACIFIC', 'UNION PACIFIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHROP_GRUMMAN', 'NORTHROP GRUMMAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALCOA', 'ALCOA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAPITAL_ONE_FINANCIAL', 'CAPITAL ONE FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONAL_OILWELL_VARCO', 'NATIONAL OILWELL VARCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'US_FOODS', 'US FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RAYTHEON', 'RAYTHEON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIME_WARNER_CABLE', 'TIME WARNER CABLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARROW_ELECTRONICS', 'ARROW ELECTRONICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AFLAC', 'AFLAC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STAPLES', 'STAPLES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABBOTT_LABORATORIES', 'ABBOTT LABORATORIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMMUNITY_HEALTH_SYSTEMS', 'COMMUNITY HEALTH SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FLUOR', 'FLUOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FREEPORT-MCMORAN', 'FREEPORT-MCMORAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'U.S._BANCORP', 'U.S. BANCORP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NUCOR', 'NUCOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KIMBERLY-CLARK', 'KIMBERLY-CLARK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HESS', 'HESS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHESAPEAKE_ENERGY', 'CHESAPEAKE ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XEROX', 'XEROX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MANPOWERGROUP', 'MANPOWERGROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMGEN', 'AMGEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABBVIE', 'ABBVIE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DANAHER', 'DANAHER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHIRLPOOL', 'WHIRLPOOL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PBF_ENERGY', 'PBF ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOLLYFRONTIER', 'HOLLYFRONTIER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ELI_LILLY', 'ELI LILLY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DEVON_ENERGY', 'DEVON ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PROGRESSIVE', 'PROGRESSIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CUMMINS', 'CUMMINS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ICAHN_ENTERPRISES', 'ICAHN ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTONATION', 'AUTONATION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KOHLS', 'KOHL''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PACCAR', 'PACCAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOLLAR_GENERAL', 'DOLLAR GENERAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARTFORD_FINANCIAL_SERVICES_GROUP', 'HARTFORD FINANCIAL SERVICES GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHWEST_AIRLINES', 'SOUTHWEST AIRLINES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANADARKO_PETROLEUM', 'ANADARKO PETROLEUM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHERN', 'SOUTHERN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUPERVALU', 'SUPERVALU')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KRAFT_FOODS_GROUP', 'KRAFT FOODS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GOODYEAR_TIRE_&_RUBBER', 'GOODYEAR TIRE & RUBBER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EOG_RESOURCES', 'EOG RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CENTURYLINK', 'CENTURYLINK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALTRIA_GROUP', 'ALTRIA GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TENET_HEALTHCARE', 'TENET HEALTHCARE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_MILLS', 'GENERAL MILLS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EBAY', 'EBAY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONAGRA_FOODS', 'CONAGRA FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEAR', 'LEAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRW_AUTOMOTIVE_HOLDINGS', 'TRW AUTOMOTIVE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_STATES_STEEL', 'UNITED STATES STEEL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PENSKE_AUTOMOTIVE_GROUP', 'PENSKE AUTOMOTIVE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AES', 'AES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COLGATE-PALMOLIVE', 'COLGATE-PALMOLIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GLOBAL_PARTNERS', 'GLOBAL PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'THERMO_FISHER_SCIENTIFIC', 'THERMO FISHER SCIENTIFIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PG&E_CORP.', 'PG&E CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEXTERA_ENERGY', 'NEXTERA ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_ELECTRIC_POWER', 'AMERICAN ELECTRIC POWER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BAXTER_INTERNATIONAL', 'BAXTER INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CENTENE', 'CENTENE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STARBUCKS', 'STARBUCKS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GAP', 'GAP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BANK_OF_NEW_YORK_MELLON_CORP.', 'BANK OF NEW YORK MELLON CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MICRON_TECHNOLOGY', 'MICRON TECHNOLOGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JABIL_CIRCUIT', 'JABIL CIRCUIT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PNC_FINANCIAL_SERVICES_GROUP', 'PNC FINANCIAL SERVICES GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KINDER_MORGAN', 'KINDER MORGAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OFFICE_DEPOT', 'OFFICE DEPOT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRISTOL-MYERS_SQUIBB', 'BRISTOL-MYERS SQUIBB')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NRG_ENERGY', 'NRG ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MONSANTO', 'MONSANTO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PPG_INDUSTRIES', 'PPG INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENUINE_PARTS', 'GENUINE PARTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OMNICOM_GROUP', 'OMNICOM GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ILLINOIS_TOOL_WORKS', 'ILLINOIS TOOL WORKS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MURPHY_USA', 'MURPHY USA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LAND_OLAKES', 'LAND O''LAKES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_REFINING', 'WESTERN REFINING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_DIGITAL', 'WESTERN DIGITAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRSTENERGY', 'FIRSTENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARAMARK', 'ARAMARK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISH_NETWORK', 'DISH NETWORK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LAS_VEGAS_SANDS', 'LAS VEGAS SANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KELLOGG', 'KELLOGG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LOEWS', 'LOEWS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CBS', 'CBS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ECOLAB', 'ECOLAB')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHOLE_FOODS_MARKET', 'WHOLE FOODS MARKET')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHUBB', 'CHUBB')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEALTH_NET', 'HEALTH NET')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WASTE_MANAGEMENT', 'WASTE MANAGEMENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APACHE', 'APACHE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEXTRON', 'TEXTRON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYNNEX', 'SYNNEX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARRIOTT_INTERNATIONAL', 'MARRIOTT INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VIACOM', 'VIACOM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINCOLN_NATIONAL', 'LINCOLN NATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORDSTROM', 'NORDSTROM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'C.H._ROBINSON_WORLDWIDE', 'C.H. ROBINSON WORLDWIDE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EDISON_INTERNATIONAL', 'EDISON INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARATHON_OIL', 'MARATHON OIL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'YUM_BRANDS', 'YUM BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMPUTER_SCIENCES', 'COMPUTER SCIENCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PARKER-HANNIFIN', 'PARKER-HANNIFIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DAVITA_HEALTHCARE_PARTNERS', 'DAVITA HEALTHCARE PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARMAX', 'CARMAX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEXAS_INSTRUMENTS', 'TEXAS INSTRUMENTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WELLCARE_HEALTH_PLANS', 'WELLCARE HEALTH PLANS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARSH_&_MCLENNAN', 'MARSH & MCLENNAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONSOLIDATED_EDISON', 'CONSOLIDATED EDISON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ONEOK', 'ONEOK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VISA', 'VISA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JACOBS_ENGINEERING_GROUP', 'JACOBS ENGINEERING GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CSX', 'CSX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENTERGY', 'ENTERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FACEBOOK', 'FACEBOOK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOMINION_RESOURCES', 'DOMINION RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEUCADIA_NATIONAL', 'LEUCADIA NATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOYS_"R"_US', 'TOYS "R" US')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DTE_ENERGY', 'DTE ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERIPRISE_FINANCIAL', 'AMERIPRISE FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VF', 'VF')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRAXAIR', 'PRAXAIR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.C._PENNEY', 'J.C. PENNEY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTOMATIC_DATA_PROCESSING', 'AUTOMATIC DATA PROCESSING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'L-3_COMMUNICATIONS', 'L-3 COMMUNICATIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CDW', 'CDW')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GUARDIAN_LIFE_INS._CO._OF_AMERICA', 'GUARDIAN LIFE INS. CO. OF AMERICA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XCEL_ENERGY', 'XCEL ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORFOLK_SOUTHERN', 'NORFOLK SOUTHERN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PPL', 'PPL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'R.R._DONNELLEY_&_SONS', 'R.R. DONNELLEY & SONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUNTSMAN', 'HUNTSMAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BED_BATH_&_BEYOND', 'BED BATH & BEYOND')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STANLEY_BLACK_&_DECKER', 'STANLEY BLACK & DECKER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'L_BRANDS', 'L BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIBERTY_INTERACTIVE', 'LIBERTY INTERACTIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FARMERS_INSURANCE_EXCHANGE', 'FARMERS INSURANCE EXCHANGE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRST_DATA', 'FIRST DATA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SHERWIN-WILLIAMS', 'SHERWIN-WILLIAMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BLACKROCK', 'BLACKROCK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VOYA_FINANCIAL', 'VOYA FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROSS_STORES', 'ROSS STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEMPRA_ENERGY', 'SEMPRA ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ESTEE_LAUDER', 'ESTEE LAUDER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'H.J._HEINZ', 'H.J. HEINZ')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REINSURANCE_GROUP_OF_AMERICA', 'REINSURANCE GROUP OF AMERICA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUBLIC_SERVICE_ENTERPRISE_GROUP', 'PUBLIC SERVICE ENTERPRISE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAMERON_INTERNATIONAL', 'CAMERON INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NAVISTAR_INTERNATIONAL', 'NAVISTAR INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CST_BRANDS', 'CST BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STATE_STREET_CORP.', 'STATE STREET CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNUM_GROUP', 'UNUM GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HILTON_WORLDWIDE_HOLDINGS', 'HILTON WORLDWIDE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FAMILY_DOLLAR_STORES', 'FAMILY DOLLAR STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRINCIPAL_FINANCIAL', 'PRINCIPAL FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RELIANCE_STEEL_&_ALUMINUM', 'RELIANCE STEEL & ALUMINUM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AIR_PRODUCTS_&_CHEMICALS', 'AIR PRODUCTS & CHEMICALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASSURANT', 'ASSURANT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PETER_KIEWIT_SONS', 'PETER KIEWIT SONS''')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HENRY_SCHEIN', 'HENRY SCHEIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COGNIZANT_TECHNOLOGY_SOLUTIONS', 'COGNIZANT TECHNOLOGY SOLUTIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MGM_RESORTS_INTERNATIONAL', 'MGM RESORTS INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'W.W._GRAINGER', 'W.W. GRAINGER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GROUP_1_AUTOMOTIVE', 'GROUP 1 AUTOMOTIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BB&T_CORP.', 'BB&T CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROCK-TENN', 'ROCK-TENN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADVANCE_AUTO_PARTS', 'ADVANCE AUTO PARTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLY_FINANCIAL', 'ALLY FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AGCO', 'AGCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CORNING', 'CORNING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIOGEN', 'BIOGEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NGL_ENERGY_PARTNERS', 'NGL ENERGY PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STRYKER', 'STRYKER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOLINA_HEALTHCARE', 'MOLINA HEALTHCARE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRECISION_CASTPARTS', 'PRECISION CASTPARTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISCOVER_FINANCIAL_SERVICES', 'DISCOVER FINANCIAL SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENWORTH_FINANCIAL', 'GENWORTH FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EASTMAN_CHEMICAL', 'EASTMAN CHEMICAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DEAN_FOODS', 'DEAN FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTOZONE', 'AUTOZONE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASTERCARD', 'MASTERCARD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OWENS_&_MINOR', 'OWENS & MINOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HORMEL_FOODS', 'HORMEL FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GAMESTOP', 'GAMESTOP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTOLIV', 'AUTOLIV')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CENTERPOINT_ENERGY', 'CENTERPOINT ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIDELITY_NATIONAL_FINANCIAL', 'FIDELITY NATIONAL FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SONIC_AUTOMOTIVE', 'SONIC AUTOMOTIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HD_SUPPLY_HOLDINGS', 'HD SUPPLY HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHARTER_COMMUNICATIONS', 'CHARTER COMMUNICATIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CROWN_HOLDINGS', 'CROWN HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APPLIED_MATERIALS', 'APPLIED MATERIALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOSAIC', 'MOSAIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CBRE_GROUP', 'CBRE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVON_PRODUCTS', 'AVON PRODUCTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REPUBLIC_SERVICES', 'REPUBLIC SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL_HEALTH_SERVICES', 'UNIVERSAL HEALTH SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DARDEN_RESTAURANTS', 'DARDEN RESTAURANTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STEEL_DYNAMICS', 'STEEL DYNAMICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNTRUST_BANKS', 'SUNTRUST BANKS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAESARS_ENTERTAINMENT', 'CAESARS ENTERTAINMENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TARGA_RESOURCES', 'TARGA RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOLLAR_TREE', 'DOLLAR TREE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWS_CORP.', 'NEWS CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BALL', 'BALL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'THRIVENT_FINANCIAL_FOR_LUTHERANS', 'THRIVENT FINANCIAL FOR LUTHERANS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASCO', 'MASCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FRANKLIN_RESOURCES', 'FRANKLIN RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVIS_BUDGET_GROUP', 'AVIS BUDGET GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REYNOLDS_AMERICAN', 'REYNOLDS AMERICAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BECTON_DICKINSON', 'BECTON DICKINSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRICELINE_GROUP', 'PRICELINE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROADCOM', 'BROADCOM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TENNECO', 'TENNECO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAMPBELL_SOUP', 'CAMPBELL SOUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AECOM', 'AECOM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VISTEON', 'VISTEON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DELEK_US_HOLDINGS', 'DELEK US HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOVER', 'DOVER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BORGWARNER', 'BORGWARNER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JARDEN', 'JARDEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UGI', 'UGI')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MURPHY_OIL', 'MURPHY OIL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PVH', 'PVH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CORE-MARK_HOLDING', 'CORE-MARK HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CALPINE', 'CALPINE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'D.R._HORTON', 'D.R. HORTON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WEYERHAEUSER', 'WEYERHAEUSER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KKR', 'KKR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FMC_TECHNOLOGIES', 'FMC TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_FAMILY_INSURANCE_GROUP', 'AMERICAN FAMILY INSURANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPARTANNASH', 'SPARTANNASH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESCO_INTERNATIONAL', 'WESCO INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUANTA_SERVICES', 'QUANTA SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOHAWK_INDUSTRIES', 'MOHAWK INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOTOROLA_SOLUTIONS', 'MOTOROLA SOLUTIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LENNAR', 'LENNAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRAVELCENTERS_OF_AMERICA', 'TRAVELCENTERS OF AMERICA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEALED_AIR', 'SEALED AIR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EVERSOURCE_ENERGY', 'EVERSOURCE ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COCA-COLA_ENTERPRISES', 'COCA-COLA ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CELGENE', 'CELGENE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WILLIAMS', 'WILLIAMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASHLAND', 'ASHLAND')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERPUBLIC_GROUP', 'INTERPUBLIC GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BLACKSTONE_GROUP', 'BLACKSTONE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RALPH_LAUREN', 'RALPH LAUREN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUEST_DIAGNOSTICS', 'QUEST DIAGNOSTICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HERSHEY', 'HERSHEY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEREX', 'TEREX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOSTON_SCIENTIFIC', 'BOSTON SCIENTIFIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWMONT_MINING', 'NEWMONT MINING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLERGAN', 'ALLERGAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OREILLY_AUTOMOTIVE', 'O''REILLY AUTOMOTIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CASEYS_GENERAL_STORES', 'CASEY''S GENERAL STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CMS_ENERGY', 'CMS ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FOOT_LOCKER', 'FOOT LOCKER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'W.R._BERKLEY', 'W.R. BERKLEY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PETSMART', 'PETSMART')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PACIFIC_LIFE', 'PACIFIC LIFE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMMERCIAL_METALS', 'COMMERCIAL METALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AGILENT_TECHNOLOGIES', 'AGILENT TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUNTINGTON_INGALLS_INDUSTRIES', 'HUNTINGTON INGALLS INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MUTUAL_OF_OMAHA_INSURANCE', 'MUTUAL OF OMAHA INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIVE_NATION_ENTERTAINMENT', 'LIVE NATION ENTERTAINMENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DICKS_SPORTING_GOODS', 'DICK''S SPORTING GOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OSHKOSH', 'OSHKOSH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CELANESE', 'CELANESE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPIRIT_AEROSYSTEMS_HOLDINGS', 'SPIRIT AEROSYSTEMS HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_NATURAL_FOODS', 'UNITED NATURAL FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEABODY_ENERGY', 'PEABODY ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OWENS-ILLINOIS', 'OWENS-ILLINOIS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DILLARDS', 'DILLARD''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEVEL_3_COMMUNICATIONS', 'LEVEL 3 COMMUNICATIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PANTRY', 'PANTRY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LKQ', 'LKQ')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTEGRYS_ENERGY_GROUP', 'INTEGRYS ENERGY GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYMANTEC', 'SYMANTEC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BUCKEYE_PARTNERS', 'BUCKEYE PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RYDER_SYSTEM', 'RYDER SYSTEM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SANDISK', 'SANDISK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROCKWELL_AUTOMATION', 'ROCKWELL AUTOMATION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DANA_HOLDING', 'DANA HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LANSING_TRADE_GROUP', 'LANSING TRADE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NCR', 'NCR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPEDITORS_INTERNATIONAL_OF_WASHINGTON', 'EXPEDITORS INTERNATIONAL OF WASHINGTON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OMNICARE', 'OMNICARE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AK_STEEL_HOLDING', 'AK STEEL HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIFTH_THIRD_BANCORP', 'FIFTH THIRD BANCORP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEABOARD', 'SEABOARD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NISOURCE', 'NISOURCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABLEVISION_SYSTEMS', 'CABLEVISION SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANIXTER_INTERNATIONAL', 'ANIXTER INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EMCOR_GROUP', 'EMCOR GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIDELITY_NATIONAL_INFORMATION_SERVICES', 'FIDELITY NATIONAL INFORMATION SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BARNES_&_NOBLE', 'BARNES & NOBLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KBR', 'KBR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTO-OWNERS_INSURANCE', 'AUTO-OWNERS INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JONES_FINANCIAL', 'JONES FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVERY_DENNISON', 'AVERY DENNISON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NETAPP', 'NETAPP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IHEARTMEDIA', 'IHEARTMEDIA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISCOVERY_COMMUNICATIONS', 'DISCOVERY COMMUNICATIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARLEY-DAVIDSON', 'HARLEY-DAVIDSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SANMINA', 'SANMINA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRINITY_INDUSTRIES', 'TRINITY INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.B._HUNT_TRANSPORT_SERVICES', 'J.B. HUNT TRANSPORT SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHARLES_SCHWAB', 'CHARLES SCHWAB')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ERIE_INSURANCE_GROUP', 'ERIE INSURANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DR_PEPPER_SNAPPLE_GROUP', 'DR PEPPER SNAPPLE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMEREN', 'AMEREN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MATTEL', 'MATTEL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LABORATORY_CORP._OF_AMERICA', 'LABORATORY CORP. OF AMERICA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GANNETT', 'GANNETT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STARWOOD_HOTELS_&_RESORTS', 'STARWOOD HOTELS & RESORTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_CABLE', 'GENERAL CABLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'A-MARK_PRECIOUS_METALS', 'A-MARK PRECIOUS METALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRAYBAR_ELECTRIC', 'GRAYBAR ELECTRIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGY_FUTURE_HOLDINGS', 'ENERGY FUTURE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HRG_GROUP', 'HRG GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MRC_GLOBAL', 'MRC GLOBAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPECTRA_ENERGY', 'SPECTRA ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASBURY_AUTOMOTIVE_GROUP', 'ASBURY AUTOMOTIVE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PACKAGING_CORP._OF_AMERICA', 'PACKAGING CORP. OF AMERICA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WINDSTREAM_HOLDINGS', 'WINDSTREAM HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PULTEGROUP', 'PULTEGROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JETBLUE_AIRWAYS', 'JETBLUE AIRWAYS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWELL_RUBBERMAID', 'NEWELL RUBBERMAID')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CON-WAY', 'CON-WAY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CALUMET_SPECIALTY_PRODUCTS_PARTNERS', 'CALUMET SPECIALTY PRODUCTS PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPEDIA', 'EXPEDIA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_FINANCIAL_GROUP', 'AMERICAN FINANCIAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRACTOR_SUPPLY', 'TRACTOR SUPPLY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_RENTALS', 'UNITED RENTALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INGREDION', 'INGREDION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NAVIENT', 'NAVIENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEADWESTVACO', 'MEADWESTVACO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AGL_RESOURCES', 'AGL RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ST._JUDE_MEDICAL', 'ST. JUDE MEDICAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.M._SMUCKER', 'J.M. SMUCKER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_UNION', 'WESTERN UNION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CLOROX', 'CLOROX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOMTAR', 'DOMTAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KELLY_SERVICES', 'KELLY SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OLD_REPUBLIC_INTERNATIONAL', 'OLD REPUBLIC INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADVANCED_MICRO_DEVICES', 'ADVANCED MICRO DEVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NETFLIX', 'NETFLIX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOOZ_ALLEN_HAMILTON_HOLDING', 'BOOZ ALLEN HAMILTON HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUINTILES_TRANSNATIONAL_HOLDINGS', 'QUINTILES TRANSNATIONAL HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WYNN_RESORTS', 'WYNN RESORTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JONES_LANG_LASALLE', 'JONES LANG LASALLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGIONS_FINANCIAL', 'REGIONS FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CH2M_HILL', 'CH2M HILL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_&_SOUTHERN_FINANCIAL_GROUP', 'WESTERN & SOUTHERN FINANCIAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LITHIA_MOTORS', 'LITHIA MOTORS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SALESFORCE.COM', 'SALESFORCE.COM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALASKA_AIR_GROUP', 'ALASKA AIR GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOST_HOTELS_&_RESORTS', 'HOST HOTELS & RESORTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARMAN_INTERNATIONAL_INDUSTRIES', 'HARMAN INTERNATIONAL INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMPHENOL', 'AMPHENOL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REALOGY_HOLDINGS', 'REALOGY HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ESSENDANT', 'ESSENDANT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HANESBRANDS', 'HANESBRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KINDRED_HEALTHCARE', 'KINDRED HEALTHCARE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARRIS_GROUP', 'ARRIS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INSIGHT_ENTERPRISES', 'INSIGHT ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANCE_DATA_SYSTEMS', 'ALLIANCE DATA SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIFEPOINT_HEALTH', 'LIFEPOINT HEALTH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PIONEER_NATURAL_RESOURCES', 'PIONEER NATURAL RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WYNDHAM_WORLDWIDE', 'WYNDHAM WORLDWIDE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OWENS_CORNING', 'OWENS CORNING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLEGHANY', 'ALLEGHANY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCGRAW_HILL_FINANCIAL', 'MCGRAW HILL FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIG_LOTS', 'BIG LOTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHERN_TIER_ENERGY', 'NORTHERN TIER ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEXION', 'HEXION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARKEL', 'MARKEL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NOBLE_ENERGY', 'NOBLE ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEIDOS_HOLDINGS', 'LEIDOS HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROCKWELL_COLLINS', 'ROCKWELL COLLINS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AIRGAS', 'AIRGAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPRAGUE_RESOURCES', 'SPRAGUE RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'YRC_WORLDWIDE', 'YRC WORLDWIDE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HANOVER_INSURANCE_GROUP', 'HANOVER INSURANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FISERV', 'FISERV')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LORILLARD', 'LORILLARD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_TIRE_DISTRIBUTORS_HOLDINGS', 'AMERICAN TIRE DISTRIBUTORS HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABM_INDUSTRIES', 'ABM INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SONOCO_PRODUCTS', 'SONOCO PRODUCTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARRIS', 'HARRIS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TELEPHONE_&_DATA_SYSTEMS', 'TELEPHONE & DATA SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WISCONSIN_ENERGY', 'WISCONSIN ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINN_ENERGY', 'LINN ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RAYMOND_JAMES_FINANCIAL', 'RAYMOND JAMES FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BERRY_PLASTICS_GROUP', 'BERRY PLASTICS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGENCY_ENERGY_PARTNERS', 'REGENCY ENERGY PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCANA', 'SCANA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CINCINNATI_FINANCIAL', 'CINCINNATI FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ATMOS_ENERGY', 'ATMOS ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEPCO_HOLDINGS', 'PEPCO HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FLOWSERVE', 'FLOWSERVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SIMON_PROPERTY_GROUP', 'SIMON PROPERTY GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONSTELLATION_BRANDS', 'CONSTELLATION BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUAD/GRAPHICS', 'QUAD/GRAPHICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BURLINGTON_STORES', 'BURLINGTON STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEIMAN_MARCUS_GROUP', 'NEIMAN MARCUS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BEMIS', 'BEMIS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COACH', 'COACH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONTINENTAL_RESOURCES', 'CONTINENTAL RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASCENA_RETAIL_GROUP', 'ASCENA RETAIL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ZOETIS', 'ZOETIS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ORBITAL_ATK', 'ORBITAL ATK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FRONTIER_COMMUNICATIONS', 'FRONTIER COMMUNICATIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEVI_STRAUSS', 'LEVI STRAUSS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPX', 'SPX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CF_INDUSTRIES_HOLDINGS', 'CF INDUSTRIES HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MICHAELS_COS.', 'MICHAELS COS.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'M&T_BANK_CORP.', 'M&T BANK CORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RUSH_ENTERPRISES', 'RUSH ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALERIS', 'ALERIS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEXEO_SOLUTIONS_HOLDINGS', 'NEXEO SOLUTIONS HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KEURIG_GREEN_MOUNTAIN', 'KEURIG GREEN MOUNTAIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUPERIOR_ENERGY_SERVICES', 'SUPERIOR ENERGY SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WILLIAMS-SONOMA', 'WILLIAMS-SONOMA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROBERT_HALF_INTERNATIONAL', 'ROBERT HALF INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NVIDIA', 'NVIDIA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRST_AMERICAN_FINANCIAL', 'FIRST AMERICAN FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ZIMMER_HOLDINGS', 'ZIMMER HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MDU_RESOURCES_GROUP', 'MDU RESOURCES GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JUNIPER_NETWORKS', 'JUNIPER NETWORKS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARTHUR_J._GALLAGHER', 'ARTHUR J. GALLAGHER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COLFAX', 'COLFAX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CLIFFS_NATURAL_RESOURCES', 'CLIFFS NATURAL RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'YAHOO', 'YAHOO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASTEC', 'MASTEC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LAM_RESEARCH', 'LAM RESEARCH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AXIALL', 'AXIALL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERCONTINENTAL_EXCHANGE', 'INTERCONTINENTAL EXCHANGE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CINTAS', 'CINTAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COTY', 'COTY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CA', 'CA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANDERSONS', 'ANDERSONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VALSPAR', 'VALSPAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHERN_TRUST', 'NORTHERN TRUST')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTUIT', 'INTUIT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TUTOR_PERINI', 'TUTOR PERINI')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POLARIS_INDUSTRIES', 'POLARIS INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOSPIRA', 'HOSPIRA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FM_GLOBAL', 'FM GLOBAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NVR', 'NVR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIBERTY_MEDIA', 'LIBERTY MEDIA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGIZER_HOLDINGS', 'ENERGIZER HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BLOOMIN_BRANDS', 'BLOOMIN'' BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVAYA', 'AVAYA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTLAKE_CHEMICAL', 'WESTLAKE CHEMICAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HYATT_HOTELS', 'HYATT HOTELS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEAD_JOHNSON_NUTRITION', 'MEAD JOHNSON NUTRITION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ACTIVISION_BLIZZARD', 'ACTIVISION BLIZZARD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PROTECTIVE_LIFE', 'PROTECTIVE LIFE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENVISION_HEALTHCARE_HOLDINGS', 'ENVISION HEALTHCARE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FORTUNE_BRANDS_HOME_&_SECURITY', 'FORTUNE BRANDS HOME & SECURITY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RPM_INTERNATIONAL', 'RPM INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VWR', 'VWR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LPL_FINANCIAL_HOLDINGS', 'LPL FINANCIAL HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KEYCORP', 'KEYCORP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SWIFT_TRANSPORTATION', 'SWIFT TRANSPORTATION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALPHA_NATURAL_RESOURCES', 'ALPHA NATURAL RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HASBRO', 'HASBRO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RESOLUTE_FOREST_PRODUCTS', 'RESOLUTE FOREST PRODUCTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIFFANY', 'TIFFANY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCCORMICK', 'MCCORMICK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRAPHIC_PACKAGING_HOLDING', 'GRAPHIC PACKAGING HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREIF', 'GREIF')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLEGHENY_TECHNOLOGIES', 'ALLEGHENY TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SECURIAN_FINANCIAL_GROUP', 'SECURIAN FINANCIAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'B/E_AEROSPACE', 'B/E AEROSPACE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXELIS', 'EXELIS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADOBE_SYSTEMS', 'ADOBE SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOLSON_COORS_BREWING', 'MOLSON COORS BREWING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROUNDYS', 'ROUNDY''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CNO_FINANCIAL_GROUP', 'CNO FINANCIAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADAMS_RESOURCES_&_ENERGY', 'ADAMS RESOURCES & ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BELK', 'BELK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHIPOTLE_MEXICAN_GRILL', 'CHIPOTLE MEXICAN GRILL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_TOWER', 'AMERICAN TOWER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FMC', 'FMC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HILLSHIRE_BRANDS', 'HILLSHIRE BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMTRUST_FINANCIAL_SERVICES', 'AMTRUST FINANCIAL SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRUNSWICK', 'BRUNSWICK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PATTERSON', 'PATTERSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHWESTERN_ENERGY', 'SOUTHWESTERN ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMETEK', 'AMETEK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'T._ROWE_PRICE', 'T. ROWE PRICE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TORCHMARK', 'TORCHMARK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DARLING_INGREDIENTS', 'DARLING INGREDIENTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEGGETT_&_PLATT', 'LEGGETT & PLATT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WATSCO', 'WATSCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CRESTWOOD_EQUITY_PARTNERS', 'CRESTWOOD EQUITY PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XYLEM', 'XYLEM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SILGAN_HOLDINGS', 'SILGAN HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOLL_BROTHERS', 'TOLL BROTHERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MANITOWOC', 'MANITOWOC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCIENCE_APPLICATIONS_INTERNATIONAL', 'SCIENCE APPLICATIONS INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARLYLE_GROUP', 'CARLYLE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIMKEN', 'TIMKEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENESIS_ENERGY', 'GENESIS ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WPX_ENERGY', 'WPX ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAREFUSION', 'CAREFUSION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PITNEY_BOWES', 'PITNEY BOWES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INGLES_MARKETS', 'INGLES MARKETS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POLYONE', 'POLYONE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROOKDALE_SENIOR_LIVING', 'BROOKDALE SENIOR LIVING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMMSCOPE_HOLDING', 'COMMSCOPE HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERITOR', 'MERITOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JOY_GLOBAL', 'JOY GLOBAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIFIED_GROCERS', 'UNIFIED GROCERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIUMPH_GROUP', 'TRIUMPH GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MAGELLAN_HEALTH', 'MAGELLAN HEALTH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SALLY_BEAUTY_HOLDINGS', 'SALLY BEAUTY HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FLOWERS_FOODS', 'FLOWERS FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABERCROMBIE_&_FITCH', 'ABERCROMBIE & FITCH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEW_JERSEY_RESOURCES', 'NEW JERSEY RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FASTENAL', 'FASTENAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NII_HOLDINGS', 'NII HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONSOL_ENERGY', 'CONSOL ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'USG', 'USG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRINKS', 'BRINK''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HELMERICH_&_PAYNE', 'HELMERICH & PAYNE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEXMARK_INTERNATIONAL', 'LEXMARK INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_AXLE_&_MANUFACTURING', 'AMERICAN AXLE & MANUFACTURING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CROWN_CASTLE_INTERNATIONAL', 'CROWN CASTLE INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TARGA_ENERGY', 'TARGA ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OCEANEERING_INTERNATIONAL', 'OCEANEERING INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABOT', 'CABOT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIT_GROUP', 'CIT GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABELAS', 'CABELA''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FOREST_LABORATORIES', 'FOREST LABORATORIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DCP_MIDSTREAM_PARTNERS', 'DCP MIDSTREAM PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RYERSON_HOLDING', 'RYERSON HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QEP_RESOURCES', 'QEP RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'THOR_INDUSTRIES', 'THOR INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HSN', 'HSN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRAHAM_HOLDINGS', 'GRAHAM HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ELECTRONIC_ARTS', 'ELECTRONIC ARTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOISE_CASCADE', 'BOISE CASCADE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUB_GROUP', 'HUB GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CACI_INTERNATIONAL', 'CACI INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROPER_TECHNOLOGIES', 'ROPER TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOWERS_WATSON', 'TOWERS WATSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SMART_&_FINAL_STORES', 'SMART & FINAL STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIG_HEART_PET_BRANDS', 'BIG HEART PET BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FOSSIL_GROUP', 'FOSSIL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NASDAQ_OMX_GROUP', 'NASDAQ OMX GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COUNTRY_FINANCIAL', 'COUNTRY FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SNAP-ON', 'SNAP-ON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PINNACLE_WEST_CAPITAL', 'PINNACLE WEST CAPITAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ECHOSTAR', 'ECHOSTAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYSTEMAX', 'SYSTEMAX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHITEWAVE_FOODS', 'WHITEWAVE FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CUNA_MUTUAL_GROUP', 'CUNA MUTUAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COOPER_TIRE_&_RUBBER', 'COOPER TIRE & RUBBER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADT', 'ADT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CERNER', 'CERNER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CLEAN_HARBORS', 'CLEAN HARBORS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRST_SOLAR', 'FIRST SOLAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LENNOX_INTERNATIONAL', 'LENNOX INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENABLE_MIDSTREAM_PARTNERS', 'ENABLE MIDSTREAM PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUBBELL', 'HUBBELL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNISYS', 'UNISYS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANT_ENERGY', 'ALLIANT ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEALTH_CARE_REIT', 'HEALTH CARE REIT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOODYS', 'MOODY''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'C.R._BARD', 'C.R. BARD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'URBAN_OUTFITTERS', 'URBAN OUTFITTERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHURCH_&_DWIGHT', 'CHURCH & DWIGHT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_EAGLE_OUTFITTERS', 'AMERICAN EAGLE OUTFITTERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OAKTREE_CAPITAL_GROUP', 'OAKTREE CAPITAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGAL_BELOIT', 'REGAL BELOIT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MENS_WEARHOUSE', 'MEN''S WEARHOUSE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COOPER-STANDARD_HOLDINGS', 'COOPER-STANDARD HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'W.R._GRACE', 'W.R. GRACE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ULTA_SALON_COSMETICS_&_FRAGRANCE', 'ULTA SALON COSMETICS & FRAGRANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HAWAIIAN_ELECTRIC_INDUSTRIES', 'HAWAIIAN ELECTRIC INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SKYWEST', 'SKYWEST')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREEN_PLAINS', 'GREEN PLAINS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LVB_ACQUISITION', 'LVB ACQUISITION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NBTY', 'NBTY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARLISLE', 'CARLISLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_REFINING', 'UNITED REFINING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TESLA_MOTORS', 'TESLA MOTORS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GROUPON', 'GROUPON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LANDSTAR_SYSTEM', 'LANDSTAR SYSTEM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PATTERSON-UTI_ENERGY', 'PATTERSON-UTI ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EP_ENERGY', 'EP ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ON_SEMICONDUCTOR', 'ON SEMICONDUCTOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RENT-A-CENTER', 'RENT-A-CENTER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNGARD_DATA_SYSTEMS', 'SUNGARD DATA SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CITRIX_SYSTEMS', 'CITRIX SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMKOR_TECHNOLOGY', 'AMKOR TECHNOLOGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TD_AMERITRADE_HOLDING', 'TD AMERITRADE HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WORTHINGTON_INDUSTRIES', 'WORTHINGTON INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VALMONT_INDUSTRIES', 'VALMONT INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IRON_MOUNTAIN', 'IRON MOUNTAIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUGET_ENERGY', 'PUGET ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CME_GROUP', 'CME GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IAC/INTERACTIVECORP', 'IAC/INTERACTIVECORP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PAR_PETROLEUM', 'PAR PETROLEUM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TAYLOR_MORRISON_HOME', 'TAYLOR MORRISON HOME')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHIQUITA_BRANDS_INTERNATIONAL', 'CHIQUITA BRANDS INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERNATIONAL_FLAVORS_&_FRAGRANCES', 'INTERNATIONAL FLAVORS & FRAGRANCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHITING_PETROLEUM', 'WHITING PETROLEUM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNDER_ARMOUR', 'UNDER ARMOUR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VENTAS', 'VENTAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NUSTAR_ENERGY', 'NUSTAR ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SELECT_MEDICAL_HOLDINGS', 'SELECT MEDICAL HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DIEBOLD', 'DIEBOLD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_NATIONAL_INSURANCE', 'AMERICAN NATIONAL INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VARIAN_MEDICAL_SYSTEMS', 'VARIAN MEDICAL SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APOLLO_EDUCATION_GROUP', 'APOLLO EDUCATION GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTINGHOUSE_AIR_BRAKE_TECHNOLOGIES', 'WESTINGHOUSE AIR BRAKE TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNPOWER', 'SUNPOWER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WARNER_MUSIC_GROUP', 'WARNER MUSIC GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_WATER_WORKS', 'AMERICAN WATER WORKS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'H&R_BLOCK', 'H&R BLOCK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERCURY_GENERAL', 'MERCURY GENERAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TECO_ENERGY', 'TECO ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SERVICE_CORP._INTERNATIONAL', 'SERVICE CORP. INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VULCAN_MATERIALS', 'VULCAN MATERIALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROWN-FORMAN', 'BROWN-FORMAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGAL_ENTERTAINMENT_GROUP', 'REGAL ENTERTAINMENT GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEMPUR_SEALY_INTERNATIONAL', 'TEMPUR SEALY INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STEELCASE', 'STEELCASE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MWI_VETERINARY_SUPPLY', 'MWI VETERINARY SUPPLY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RADIOSHACK', 'RADIOSHACK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPROUTS_FARMERS_MARKET', 'SPROUTS FARMERS MARKET')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SABRE', 'SABRE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARTIN_MARIETTA_MATERIALS', 'MARTIN MARIETTA MATERIALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUNTINGTON_BANCSHARES', 'HUNTINGTON BANCSHARES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALERE', 'ALERE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TREEHOUSE_FOODS', 'TREEHOUSE FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARCH_COAL', 'ARCH COAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KLA-TENCOR', 'KLA-TENCOR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CRANE', 'CRANE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IASIS_HEALTHCARE', 'IASIS HEALTHCARE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BABCOCK_&_WILCOX', 'BABCOCK & WILCOX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DENTSPLY_INTERNATIONAL', 'DENTSPLY INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIBUNE_MEDIA', 'TRIBUNE MEDIA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCANSOURCE', 'SCANSOURCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVISION_COMMUNICATIONS', 'UNIVISION COMMUNICATIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRINKER_INTERNATIONAL', 'BRINKER INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXTERRAN_HOLDINGS', 'EXTERRAN HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARTERS', 'CARTER''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANALOG_DEVICES', 'ANALOG DEVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENESCO', 'GENESCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCOTTS_MIRACLE-GRO', 'SCOTTS MIRACLE-GRO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONVERGYS', 'CONVERGYS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXIDE_TECHNOLOGIES', 'EXIDE TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WABCO_HOLDINGS', 'WABCO HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KENNAMETAL', 'KENNAMETAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERCO', 'AMERCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BON-TON_STORES', 'BON-TON STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEAM_HEALTH_HOLDINGS', 'TEAM HEALTH HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGENERON_PHARMACEUTICALS', 'REGENERON PHARMACEUTICALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPRINGLEAF_HOLDINGS', 'SPRINGLEAF HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINCOLN_ELECTRIC_HOLDINGS', 'LINCOLN ELECTRIC HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DRESSER-RAND_GROUP', 'DRESSER-RAND GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WEST', 'WEST')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BENCHMARK_ELECTRONICS', 'BENCHMARK ELECTRONICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PALL', 'PALL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OLD_DOMINION_FREIGHT_LINE', 'OLD DOMINION FREIGHT LINE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MSC_INDUSTRIAL_DIRECT', 'MSC INDUSTRIAL DIRECT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SENTRY_INSURANCE_GROUP', 'SENTRY INSURANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SIGMA-ALDRICH', 'SIGMA-ALDRICH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WGL_HOLDINGS', 'WGL HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WEIS_MARKETS', 'WEIS MARKETS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SANDERSON_FARMS', 'SANDERSON FARMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STANCORP_FINANCIAL_GROUP', 'STANCORP FINANCIAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HYSTER-YALE_MATERIALS_HANDLING', 'HYSTER-YALE MATERIALS HANDLING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WOLVERINE_WORLD_WIDE', 'WOLVERINE WORLD WIDE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DST_SYSTEMS', 'DST SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEGG_MASON', 'LEGG MASON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TERADATA', 'TERADATA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AARONS', 'AARON''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANTERO_RESOURCES', 'ANTERO RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'METALDYNE_PERFORMANCE_GROUP', 'METALDYNE PERFORMANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RANGE_RESOURCES', 'RANGE RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VORNADO_REALTY_TRUST', 'VORNADO REALTY TRUST')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOYD_GAMING', 'BOYD GAMING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COVANCE', 'COVANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARMSTRONG_WORLD_INDUSTRIES', 'ARMSTRONG WORLD INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CRACKER_BARREL_OLD_COUNTRY_STORE', 'CRACKER BARREL OLD COUNTRY STORE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHICOS_FAS', 'CHICO''S FAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCRIPPS_NETWORKS_INTERACTIVE', 'SCRIPPS NETWORKS INTERACTIVE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL_FOREST_PRODUCTS', 'UNIVERSAL FOREST PRODUCTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONCHO_RESOURCES', 'CONCHO RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ITT', 'ITT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HCC_INSURANCE_HOLDINGS', 'HCC INSURANCE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOOG', 'MOOG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IMS_HEALTH_HOLDINGS', 'IMS HEALTH HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CINEMARK_HOLDINGS', 'CINEMARK HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMERICA', 'COMERICA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQUITY_RESIDENTIAL', 'EQUITY RESIDENTIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RYLAND_GROUP', 'RYLAND GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GNC_HOLDINGS', 'GNC HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARCBEST', 'ARCBEST')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VECTREN', 'VECTREN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CURTISS-WRIGHT', 'CURTISS-WRIGHT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TUPPERWARE_BRANDS', 'TUPPERWARE BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTAR_ENERGY', 'WESTAR ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALBEMARLE', 'ALBEMARLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APTARGROUP', 'APTARGROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PINNACLE_FOODS', 'PINNACLE FOODS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PENN_NATIONAL_GAMING', 'PENN NATIONAL GAMING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.CREW_GROUP', 'J.CREW GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VANTIV', 'VANTIV')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KANSAS_CITY_SOUTHERN', 'KANSAS CITY SOUTHERN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CALERES', 'CALERES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NU_SKIN_ENTERPRISES', 'NU SKIN ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREAT_PLAINS_ENERGY', 'GREAT PLAINS ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KIRBY', 'KIRBY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_GROWTH_PROPERTIES', 'GENERAL GROWTH PROPERTIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROADRIDGE_FINANCIAL_SOLUTIONS', 'BROADRIDGE FINANCIAL SOLUTIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STERICYCLE', 'STERICYCLE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GLOBAL_PAYMENTS', 'GLOBAL PAYMENTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTEK', 'NORTEK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCHNITZER_STEEL_INDUSTRIES', 'SCHNITZER STEEL INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL', 'UNIVERSAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANN', 'ANN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOLOGIC', 'HOLOGIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PANERA_BREAD', 'PANERA BREAD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AOL', 'AOL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SM_ENERGY', 'SM ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PAYCHEX', 'PAYCHEX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRICESMART', 'PRICESMART')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTODESK', 'AUTODESK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AFFILIATED_MANAGERS_GROUP', 'AFFILIATED MANAGERS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOPS_HOLDING', 'TOPS HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DYNEGY', 'DYNEGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DSW', 'DSW')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VISHAY_INTERTECHNOLOGY', 'VISHAY INTERTECHNOLOGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'METTLER-TOLEDO_INTERNATIONAL', 'METTLER-TOLEDO INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNEDISON', 'SUNEDISON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TETRA_TECH', 'TETRA TECH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOMENTIVE_PERFORMANCE_MATERIALS', 'MOMENTIVE PERFORMANCE MATERIALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERSYS', 'ENERSYS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DONALDSON', 'DONALDSON')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQT', 'EQT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MONSTER_BEVERAGE', 'MONSTER BEVERAGE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PC_CONNECTION', 'PC CONNECTION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOTAL_SYSTEM_SERVICES', 'TOTAL SYSTEM SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SERVICEMASTER_GLOBAL_HOLDINGS', 'SERVICEMASTER GLOBAL HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEDICAL_MUTUAL_OF_OHIO', 'MEDICAL MUTUAL OF OHIO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APPLIED_INDUSTRIAL_TECHNOLOGIES', 'APPLIED INDUSTRIAL TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MAXIM_INTEGRATED_PRODUCTS', 'MAXIM INTEGRATED PRODUCTS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OGE_ENERGY', 'OGE ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'A._SCHULMAN', 'A. SCHULMAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQUINIX', 'EQUINIX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEDNAX', 'MEDNAX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQUIFAX', 'EQUIFAX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STANDARD_PACIFIC', 'STANDARD PACIFIC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DENBURY_RESOURCES', 'DENBURY RESOURCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIMAREX_ENERGY', 'CIMAREX ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MUTUAL_OF_AMERICA_LIFE_INSURANCE', 'MUTUAL OF AMERICA LIFE INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GUESS', 'GUESS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POST_HOLDINGS', 'POST HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEALTHSOUTH', 'HEALTHSOUTH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FERRELLGAS_PARTNERS', 'FERRELLGAS PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KB_HOME', 'KB HOME')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOSTON_PROPERTIES', 'BOSTON PROPERTIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIMBLE_NAVIGATION', 'TRIMBLE NAVIGATION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TELEDYNE_TECHNOLOGIES', 'TELEDYNE TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ACUITY_BRANDS', 'ACUITY BRANDS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SKECHERS_U.S.A.', 'SKECHERS U.S.A.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XILINX', 'XILINX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PLEXUS', 'PLEXUS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWFIELD_EXPLORATION', 'NEWFIELD EXPLORATION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRANSDIGM_GROUP', 'TRANSDIGM GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KAR_AUCTION_SERVICES', 'KAR AUCTION SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MUELLER_INDUSTRIES', 'MUELLER INDUSTRIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ZIONS_BANCORP.', 'ZIONS BANCORP.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INSPERITY', 'INSPERITY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XPO_LOGISTICS', 'XPO LOGISTICS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEARS_HOMETOWN_&_OUTLET_STORES', 'SEARS HOMETOWN & OUTLET STORES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'A.O._SMITH', 'A.O. SMITH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANCE_ONE_INTERNATIONAL', 'ALLIANCE ONE INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TAKE-TWO_INTERACTIVE_SOFTWARE', 'TAKE-TWO INTERACTIVE SOFTWARE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HHGREGG', 'HHGREGG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RPC', 'RPC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWMARKET', 'NEWMARKET')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BEACON_ROOFING_SUPPLY', 'BEACON ROOFING SUPPLY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EDWARDS_LIFESCIENCES', 'EDWARDS LIFESCIENCES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIPLE-S_MANAGEMENT', 'TRIPLE-S MANAGEMENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HAWAIIAN_HOLDINGS', 'HAWAIIAN HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEARTLAND_PAYMENT_SYSTEMS', 'HEARTLAND PAYMENT SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BELDEN', 'BELDEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MAGELLAN_MIDSTREAM_PARTNERS', 'MAGELLAN MIDSTREAM PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OUTERWALL', 'OUTERWALL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KAPSTONE_PAPER_&_PACKAGING', 'KAPSTONE PAPER & PACKAGING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANCE_HOLDINGS', 'ALLIANCE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SKYWORKS_SOLUTIONS', 'SKYWORKS SOLUTIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIENA', 'CIENA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRANITE_CONSTRUCTION', 'GRANITE CONSTRUCTION')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EDUCATION_MANAGEMENT', 'EDUCATION MANAGEMENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PARTY_CITY_HOLDINGS', 'PARTY CITY HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HCP', 'HCP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PAREXEL_INTERNATIONAL', 'PAREXEL INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DELTA_TUCKER_HOLDINGS', 'DELTA TUCKER HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PINNACLE_ENTERTAINMENT', 'PINNACLE ENTERTAINMENT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STIFEL_FINANCIAL', 'STIFEL FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POOL', 'POOL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OLIN', 'OLIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KNIGHTS_OF_COLUMBUS', 'KNIGHTS OF COLUMBUS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PERKINELMER', 'PERKINELMER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALEXION_PHARMACEUTICALS', 'ALEXION PHARMACEUTICALS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IHS', 'IHS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OIL_STATES_INTERNATIONAL', 'OIL STATES INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HNI', 'HNI')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINKEDIN', 'LINKEDIN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DIPLOMAT_PHARMACY', 'DIPLOMAT PHARMACY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROCADE_COMMUNICATIONS_SYSTEMS', 'BROCADE COMMUNICATIONS SYSTEMS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREENBRIER_COS.', 'GREENBRIER COS.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMC_NETWORKS', 'AMC NETWORKS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KEMPER', 'KEMPER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OCWEN_FINANCIAL', 'OCWEN FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUBLIC_STORAGE', 'PUBLIC STORAGE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRINET_GROUP', 'TRINET GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHEMTURA', 'CHEMTURA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYMETRA_FINANCIAL', 'SYMETRA FINANCIAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOWER_INTERNATIONAL', 'TOWER INTERNATIONAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERITAGE_HOMES', 'MERITAGE HOMES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARKWEST_ENERGY_PARTNERS', 'MARKWEST ENERGY PARTNERS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIO-RAD_LABORATORIES', 'BIO-RAD LABORATORIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRUEBLUE', 'TRUEBLUE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABOT_OIL_&_GAS', 'CABOT OIL & GAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARPENTER_TECHNOLOGY', 'CARPENTER TECHNOLOGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TORO', 'TORO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_EQUITY_INVESTMENT_LIFE_HOLDING', 'AMERICAN EQUITY INVESTMENT LIFE HOLDING')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPRESS', 'EXPRESS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EASTMAN_KODAK', 'EASTMAN KODAK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HAIN_CELESTIAL_GROUP', 'HAIN CELESTIAL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONSTAR_MORTGAGE_HOLDINGS', 'NATIONSTAR MORTGAGE HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IDEX', 'IDEX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POPULAR', 'POPULAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WERNER_ENTERPRISES', 'WERNER ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ESTERLINE_TECHNOLOGIES', 'ESTERLINE TECHNOLOGIES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTUITIVE_SURGICAL', 'INTUITIVE SURGICAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLISON_TRANSMISSION_HOLDINGS', 'ALLISON TRANSMISSION HOLDINGS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEMGROUP', 'SEMGROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHWEST_GAS', 'SOUTHWEST GAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'G-III_APPAREL_GROUP', 'G-III APPAREL GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONAL_FUEL_GAS', 'NATIONAL FUEL GAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'H.B._FULLER', 'H.B. FULLER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PENN_MUTUAL_LIFE_INSURANCE', 'PENN MUTUAL LIFE INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RCS_CAPITAL', 'RCS CAPITAL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COLUMBIA_SPORTSWEAR', 'COLUMBIA SPORTSWEAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMICA_MUTUAL_INSURANCE', 'AMICA MUTUAL INSURANCE')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRIMORIS_SERVICES', 'PRIMORIS SERVICES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGEN', 'ENERGEN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REXNORD', 'REXNORD')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEVENTY_SEVEN_ENERGY', 'SEVENTY SEVEN ENERGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WASTE_CONNECTIONS', 'WASTE CONNECTIONS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEP_BOYS-MANNY,_MOE_&_JACK', 'PEP BOYS-MANNY, MOE & JACK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARSCO', 'HARSCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOVNANIAN_ENTERPRISES', 'HOVNANIAN ENTERPRISES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WILLBROS_GROUP', 'WILLBROS GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WENDYS', 'WENDY''S')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERNATIONAL_GAME_TECHNOLOGY', 'INTERNATIONAL GAME TECHNOLOGY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYNOPSYS', 'SYNOPSYS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL_AMERICAN', 'UNIVERSAL AMERICAN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AAR', 'AAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SELECTIVE_INSURANCE_GROUP', 'SELECTIVE INSURANCE GROUP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GARTNER', 'GARTNER')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'E*TRADE_FINANCIAL', 'E*TRADE FINANCIAL')

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Adrián', 'Belen', 0 , 'MVD/Adrian_Belen.JPG', 0, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Adrián', 'Lopez', 0 , 'MVD/Adrian_Lopez.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Alberto', 'Da Cunha', 1 , 'MVD/Alberto_Dacunha.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Alberto', 'Hernández', 0 , 'MVD/Alberto_Hernandez.jpg', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Alejandro', 'Capece', 0 , 'MVD/Alejandro Capece.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Alejandro', 'Latchinian', 0 , 'MVD/Alejandro_Latchinian.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Alfonso', 'Rodriguez', 1 , 'MVD/Alfonso_Rodriguez.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Alvaro', 'Restuccia', 1 , 'MVD/Alvaro_Restuccia.jpeg', 1, [dbo].[GradeFromStr]('CL'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Andrés', 'Bores', 0 , 'MVD/Andres_Bores.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Andrés', 'Maedo', 1 , 'MVD/Andres_Maedo.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Andrés', 'Nieves', 0 , 'MVD/Andres_Nieves.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Aniela', 'Amy', 0 , 'MVD/Aniela_Amy.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Ariel', 'Sisro', 0 , 'MVD/Ariel_Sisro.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Beerbal', 'Abdulkhader', 1 , 'MVD/Beerbal_Abdulkhader.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Bruno', 'Candia', 1 , 'MVD/Bruno_Candia.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Camila', 'Roji', 0 , 'MVD/Camila_Roji.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Camila', 'Sorio', 0 , 'MVD/Camila_Sorio.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Camilo', 'Gomez', 1 , 'MVD/Camilo_Gomez.jpeg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Damián', 'Pereira', 1 , 'MVD/Damian_Pereira.JPG', 1, [dbo].[GradeFromStr]('CL'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Daniel', 'Cabrera', 0 , 'MVD/Daniel_Cabrera.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Delia', 'Alvarez', 0 , 'MVD/Delia_Alvarez.jpg', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Eduardo', 'Ducer', 0 , 'MVD/Eduardo_Ducer.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Eugenia', 'Pais', 1 , 'MVD/Maria_Pais.jpg', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Federico', 'Canet', 1 , 'MVD/Federico_Canet.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Federico', 'García', 0 , 'MVD/Federico_Garcia.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Federico', 'Trujillo', 1 , 'MVD/Federico_Trujillo.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Fernando', 'Olmos', 1 , 'MVD/Fernando_Olmos.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Fernando', 'Cañas', 0 , 'MVD/Fernando_Canas.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Fernando', 'Stromillo', 0 , 'MVD/Fernando_Stromillo.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Gastón', 'Aroztegui', 0 , 'MVD/Gaston_Aroztegui.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Gerardo', 'Barbitta', 0 , 'MVD/Gerardo_Barbitta.jpg', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Giovanina', 'Chirione', 0 , 'MVD/Giovanina_Chirione.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Hernán', 'Rumbo', 0 , 'MVD/Hernan_Rumbo.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Horacio', 'Blanco', 0 , 'MVD/Horacio_Blanco.JPG', 1, [dbo].[GradeFromStr]('CL'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Hugo', 'Ocampo', 0 , 'MVD/Hugo_Ocampo.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Ignacio', 'Assandri', 1 , 'MVD/Ignacio_Assandri.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Ignacio', 'Loureiro', 0 , 'MVD/Ignacio_Loureiro.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Ignacio', 'Secco', 0 , 'MVD/Ignacio_Secco.jpeg', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Javier', 'Barrios', 0 , 'MVD/Javier_Barrios.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Javier', 'Calero', 0 , 'MVD/Javier_Calero.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Jimena', 'Irigaray', 0 , 'MVD/Jimena_Irigaray.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Jorge', 'Jova', 1 , NULL, 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Juan', 'Aguerre', 0 , 'MVD/Juan_Aguerre.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Juan', 'Estrada', 0 , 'MVD/Juan_Estrada.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Juan Manuel', 'Fagundez', 0 , NULL, 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'OPS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Leonardo', 'Mendizabal', 0 , 'MVD/Leonardo_Mendizabal.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Luciano', 'Deluca', 0 , 'MVD/Luciano_Deluca.JPG', 1, [dbo].[GradeFromStr]('SC'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Malvina', 'Jaume', 0 , 'MVD/Malvina_Jaume.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Marcelo', 'Zepedeo', 0 , 'MVD/Marcelo_Zepedeo.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Marcos', 'Guimaraes', 0 , 'MVD/Marcos_Guimaraes.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'María Julia', 'Etcheverry', 0 , 'MVD/Maria_Etcheverry.jpg', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'María Noel', 'Mosqueira', 0 , 'MVD/Maria_Mosqueira.JPG', 1, [dbo].[GradeFromStr]('TL'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Marlon', 'González', 0 , 'MVD/Marlon_Gonzalez.jpg', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Martín', 'Acosta', 0 , 'MVD/Martin_Acosta.jpg', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Martin', 'Caetano', 0 , 'MVD/Martin_Caetano.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Mathías', 'Rodríguez', 1 , 'MVD/Mathias_Rodriguez.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Mauricio', 'Mora', 0 , 'MVD/Mauricio_Mora.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Nicolás', 'Gómez', 1 , 'MVD/Nicolas_Gomez.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Nicolás', 'Lasarte', 1 , 'MVD/Nicolas_Lasarte.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Nicolas', 'Mañay', 0 , 'MVD/Nicolas_Manay.jpg', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Octavio', 'Garbarino', 1 , 'MVD/Octavio_Garbarino.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pablo', 'Cawen', 0 , 'MVD/Pablo_Cawen.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pablo', 'Da Silva', 0 , 'MVD/Pablo_DaSilva.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pablo', 'García', 0 , 'MVD/Pablo_Garcia.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pablo', 'Gus', 0 , NULL, 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'OPS'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pablo', 'Queirolo', 0 , 'MVD/Pablo_Queirolo.jpg', 1, [dbo].[GradeFromStr]('SC'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pablo', 'Uriarte', 0 , 'MVD/Pablo_Uriarte.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pedro', 'Minetti', 0 , 'MVD/Pedro_Minetti.jpg', 1, [dbo].[GradeFromStr]('SM'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Pedro', 'Tournier', 1 , 'MVD/Pedro_Tournier.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Raidel', 'Gonzalez', 0 , 'MVD/Raidel_Gonzalez.jpeg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Raúl', 'Fossemale', 0 , 'MVD/Raul_Fossemale.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Roberto', 'Assandri', 0 , 'MVD/Roberto_Assandri.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Rodrigo', 'Alvarez', 0 , 'MVD/Rodrigo_Alvarez.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Rodrigo', 'Valdez', 0 , 'MVD/Rodrigo_Valdez.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Ruben', 'Bracco', 0 , 'MVD/Ruben_Bracco.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Santiago', 'Ferreiro', 0 , 'MVD/Santiago_Ferreiro.jpg', 1, [dbo].[GradeFromStr]('CL'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Sebastian', 'Queirolo', 0 , 'MVD/Sebastian_Queirolo.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Silvia', 'Derkoyorikian', 0 , 'MVD/Silvia_Derkoyorikian.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DBA'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Valentín', 'Gadola', 0 , 'MVD/Valentin_Gadola.jpg', 1, [dbo].[GradeFromStr]('SC'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Valeria', 'Rotunno', 0 , 'MVD/Valeria_Rotunno.JPG', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'ADMIN'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Victoria', 'Andrada', 0 , 'MVD/Victoria_Andrada.JPG', 1, [dbo].[GradeFromStr]('ST'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'William', 'Claro', 1 , 'MVD/William_Claro.JPG', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Yago', 'Auza', 0 , 'MVD/Yago_Auza.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Yanara', 'Valdes', 0 , 'MVD/Yanara_Valdes.jpg', 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Yony', 'Gómez', 0 , 'MVD/Yony_Gomez.JPG', 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'MVD' AND [CR].[Code] = 'UX'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Adrián', 'Costa', 0 , NULL, 1, [dbo].[GradeFromStr]('CL'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'ROS' AND [CR].[Code] = 'PM'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Agustín', 'Narvaez', 1 , NULL, 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'ROS' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Andrea', 'Sabella', 1 , NULL, 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'ROS' AND [CR].[Code] = 'TST'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Ezequiel', 'Konjuh', 0 , NULL, 1, [dbo].[GradeFromStr]('EN'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'ROS' AND [CR].[Code] = 'DEV'
INSERT INTO [dbo].[Candidate] ([DeliveryUnitId], [RelationType], [FirstName], [LastName], [InBench], [Picture], [IsActive], [Grade], [CandidateRoleId]) SELECT [DU].[Id], 1, 'Luis', 'Fregeiro', 0 , NULL, 1, [dbo].[GradeFromStr]('SE'), [CR].[Id] FROM [dbo].[DeliveryUnit] AS [DU] CROSS JOIN [dbo].[CandidateRole] AS [CR] WHERE [DU].[Code] = 'ROS' AND [CR].[Code] = 'DEV'

----------------------------------------------------------------------------------------------------

DECLARE @candidateLimit INT = 500
DECLARE @candidateIdx INT = 1

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
  SET @candidateRoleId = [dbo].[RandomCandidateRole](RAND())

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
    [CandidateRoleId],
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
    @candidateRoleId,
    NULL,
    NULL
  )
  
  SET @candidateIdx = @candidateIdx + 1
 END

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
                        FROM [dbo].[Candidate] AS [C]
                        INNER JOIN [dbo].[CandidateRole] AS [CR] ON [CR].[Id] = [C].[CandidateRoleId]
                        WHERE [CR].[Code] IN ('ADMIN'))
  AND [SkillId] IN (SELECT [Id]
                    FROM [dbo].[Skill] AS [S]
                    WHERE [S].[TechnologyId] IS NOT NULL OR [S].[TechnologyRoleId] IS NOT NULL OR [S].[TechnologyVersionId] IS NOT NULL OR [S].[BusinessAreaId] IS NOT NULL)

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
/*
UPDATE [C]
SET [DocNumber] = (SELECT MIN([D].[DocNumber]) FROM [Documentos].[dbo].[Docs] AS [D] WHERE ([D].[FirstName] LIKE ([C].[FirstName] + '%')) AND ([D].[LastName] LIKE ([C].[LastName] + '%')))
FROM [dbo].[Candidate] AS [C]
WHERE [C].[DeliveryUnitId] = 13
*/

DECLARE @candidateId INT
DECLARE @rndDocId INT

DECLARE candidateproject_cursor CURSOR FOR   
SELECT [Id]
FROM [dbo].[Candidate]
  
OPEN candidateproject_cursor  

FETCH NEXT FROM candidateproject_cursor   
INTO @candidateId

WHILE @@FETCH_STATUS = 0  
 BEGIN
  SET @rndDocId = CAST((2000000.0 + (RAND() * 1000000.0)) AS INT)

/*
  UPDATE [C]
  SET [CurrentProjectId] = CASE WHEN [C].[RelationType] <> 1 THEN NULL WHEN [C].[InBench] = 1 THEN NULL ELSE [dbo].[RandomProject](RAND()) END,
      [CurrentProjectJoin] = CASE WHEN [C].[RelationType] <> 1 THEN NULL WHEN [C].[InBench] = 1 THEN [dbo].[RandomDate](50, RAND()) ELSE [dbo].[RandomDate](1000, RAND()) END,
      [FirstName] = CASE WHEN [C].[DeliveryUnitId] = 13 AND [C].[FirstName] IS NOT NULL THEN [C].[FirstName] WHEN [D].[FirstName] IS NULL THEN [C].[FirstName] ELSE [D].[FirstName] END,
      [LastName] = CASE WHEN [C].[DeliveryUnitId] = 13 AND [C].[LastName] IS NOT NULL THEN [C].[LastName] WHEN [D].[LastName] IS NULL THEN [C].[LastName] ELSE [D].[LastName] END,
      [DocType] = 1, -- 1: NationalIdentity, 2: Passport
      [DocNumber] = [D].[DocNumber],
      [EmployeeNumber] = CASE WHEN [C].[RelationType] = 1 THEN CAST((RAND() * 10000.0) AS INT) ELSE NULL END
  FROM [dbo].[Candidate] AS [C]
  CROSS JOIN [Documentos].[dbo].[Docs] AS [D]
  WHERE [C].[Id] = @candidateId
    AND [D].[Id] = @rndDocId
*/

  UPDATE [C]
  SET [CurrentProjectId] = CASE WHEN [C].[RelationType] <> 1 THEN NULL WHEN [C].[InBench] = 1 THEN NULL ELSE [dbo].[RandomProject](RAND()) END,
      [CurrentProjectJoin] = CASE WHEN [C].[RelationType] <> 1 THEN NULL WHEN [C].[InBench] = 1 THEN [dbo].[RandomDate](50, RAND()) ELSE [dbo].[RandomDate](1000, RAND()) END,
      [EmployeeNumber] = CASE WHEN [C].[RelationType] = 1 THEN CAST((RAND() * 10000.0) AS INT) ELSE NULL END
  FROM [dbo].[Candidate] AS [C]
  WHERE [C].[Id] = @candidateId

  FETCH NEXT FROM candidateproject_cursor   
  INTO @candidateId
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
