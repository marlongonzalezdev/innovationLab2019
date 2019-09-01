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
DROP FUNCTION IF EXISTS [dbo].[RandomNotes]

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

CREATE FUNCTION [dbo].[RandomNotes] (@rnd FLOAT) RETURNS NVARCHAR(MAX)
AS
 BEGIN
  DECLARE @res NVARCHAR(MAX)

  IF (@rnd < 0.5)
   BEGIN
    SET @res = NULL
   END
  ELSE IF (@rnd < 0.6)
   BEGIN
    SET @res = 'It is recommended to repeat evaluation in 3 months.'
   END
  ELSE IF (@rnd < 0.75)
   BEGIN
    SET @res = 'It is recommended to repeat evaluation in 6 months.'
   END
  ELSE IF (@rnd < 0.95)
   BEGIN
    SET @res = 'It is recommended to repeat evaluation in 1 year.'
   END
  ELSE
   BEGIN
    SET @res = 'It is recommended to repeat evaluation in 2 years.'
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
  [IsActive]                      BIT NOT NULL CONSTRAINT [DF_Technology_IsActive] DEFAULT 1,

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
  [IsActive]                      BIT NOT NULL CONSTRAINT [DF_TechnologyVersion_IsActive] DEFAULT 1,

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
  [IsActive]                      BIT NOT NULL CONSTRAINT [DF_TechnologyRole_IsActive] DEFAULT 1,

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
  [IsActive]                      BIT NOT NULL CONSTRAINT [DF_SoftSkill_IsActive] DEFAULT 1,
  
  CONSTRAINT [PK_SoftSkill] PRIMARY KEY CLUSTERED ([Id] ASC),

  CONSTRAINT [UC_SoftSkill_Code] UNIQUE NONCLUSTERED ([Code] ASC),
)
GO

CREATE TABLE [dbo].[BusinessArea] (
  [Id]                            INT IDENTITY(1, 1) NOT NULL,
  [Code]                          [MLCode] NOT NULL,
  [Name]                          [MLName] NOT NULL,
  [DefaultExpertise]              [MLDecimal] NOT NULL CONSTRAINT [CH_BusinessArea_DefaultExpertise] CHECK ([DefaultExpertise] BETWEEN 0.0 AND 1.0),
  [IsActive]                      BIT NOT NULL CONSTRAINT [DF_BusinessArea_IsActive] DEFAULT 1,

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

CREATE VIEW [dbo].[GlobalSkill]
AS
  SELECT [S].[Id] AS [SkillId],
         [T].[Id] AS [RelatedId],
         1 AS [Category],
         [T].[Code],
         [T].[Name],
         [T].[IsActive],
         [T].[DefaultExpertise]
  FROM [dbo].[Technology] AS [T]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[TechnologyId] = [T].[Id]
  UNION ALL
  SELECT [S].[Id] AS [SkillId],
         [TV].[Id] AS [RelatedId],
         2 AS [Category],
         [T].[Code] + ' v' + [TV].[Version] AS [Code],
         [T].[Name] + ' v' + [TV].[Version] AS [Name],
         [TV].[IsActive],
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
         [TR].[IsActive],
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
         [SK].[IsActive],
         [SK].[DefaultExpertise]
  FROM [dbo].[SoftSkill] AS [SK]
  INNER JOIN [dbo].[Skill] AS [S] ON [S].[SoftSkillId] = [SK].[Id]
  UNION ALL
  SELECT [S].[Id] AS [SkillId],
         [BA].[Id] AS [RelatedId],
         5 AS [Category],
         [BA].[Code],
         [BA].[Name],
         [BA].[IsActive],
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

INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENDAVA', 'Endava')

INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WALMART', 'Walmart')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXXON_MOBIL', 'Exxon Mobil')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHEVRON', 'Chevron')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BERKSHIRE_HATHAWAY', 'Berkshire Hathaway')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APPLE', 'Apple')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_MOTORS', 'General Motors')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PHILLIPS_66', 'Phillips 66')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_ELECTRIC', 'General Electric')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FORD_MOTOR', 'Ford Motor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CVS_HEALTH', 'CVS Health')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCKESSON', 'McKesson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AT&T', 'AT&T')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VALERO_ENERGY', 'Valero Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITEDHEALTH_GROUP', 'UnitedHealth Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VERIZON', 'Verizon')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERISOURCEBERGEN', 'AmerisourceBergen')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FANNIE_MAE', 'Fannie Mae')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COSTCO', 'Costco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HP', 'HP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KROGER', 'Kroger')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JP_MORGAN_CHASE', 'JP Morgan Chase')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPRESS_SCRIPTS_HOLDING', 'Express Scripts Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BANK_OF_AMERICA_CORP.', 'Bank of America Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IBM', 'IBM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARATHON_PETROLEUM', 'Marathon Petroleum')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARDINAL_HEALTH', 'Cardinal Health')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOEING', 'Boeing')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CITIGROUP', 'Citigroup')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMAZON.COM', 'Amazon.com')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WELLS_FARGO', 'Wells Fargo')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MICROSOFT', 'Microsoft')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PROCTER_&_GAMBLE', 'Procter & Gamble')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOME_DEPOT', 'Home Depot')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARCHER_DANIELS_MIDLAND', 'Archer Daniels Midland')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WALGREENS', 'Walgreens')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TARGET', 'Target')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JOHNSON_&_JOHNSON', 'Johnson & Johnson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANTHEM', 'Anthem')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'METLIFE', 'MetLife')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GOOGLE', 'Google')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STATE_FARM_INSURANCE_COS.', 'State Farm Insurance Cos.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FREDDIE_MAC', 'Freddie Mac')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMCAST', 'Comcast')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEPSICO', 'PepsiCo')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_TECHNOLOGIES', 'United Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AIG', 'AIG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UPS', 'UPS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOW_CHEMICAL', 'Dow Chemical')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AETNA', 'Aetna')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LOWES', 'Lowe''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONOCOPHILLIPS', 'ConocoPhillips')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTEL', 'Intel')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGY_TRANSFER_EQUITY', 'Energy Transfer Equity')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CATERPILLAR', 'Caterpillar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRUDENTIAL_FINANCIAL', 'Prudential Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PFIZER', 'Pfizer')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISNEY', 'Disney')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUMANA', 'Humana')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENTERPRISE_PRODUCTS_PARTNERS', 'Enterprise Products Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CISCO_SYSTEMS', 'Cisco Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYSCO', 'Sysco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INGRAM_MICRO', 'Ingram Micro')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COCA-COLA', 'Coca-Cola')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LOCKHEED_MARTIN', 'Lockheed Martin')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FEDEX', 'FedEx')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JOHNSON_CONTROLS', 'Johnson Controls')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PLAINS_GP_HOLDINGS', 'Plains GP Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WORLD_FUEL_SERVICES', 'World Fuel Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHS', 'CHS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_AIRLINES_GROUP', 'American Airlines Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERCK', 'Merck')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BEST_BUY', 'Best Buy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DELTA_AIR_LINES', 'Delta Air Lines')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HONEYWELL_INTERNATIONAL', 'Honeywell International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HCA_HOLDINGS', 'HCA Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GOLDMAN_SACHS_GROUP', 'Goldman Sachs Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TESORO', 'Tesoro')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIBERTY_MUTUAL_INSURANCE_GROUP', 'Liberty Mutual Insurance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_CONTINENTAL_HOLDINGS', 'United Continental Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEW_YORK_LIFE_INSURANCE', 'New York Life Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ORACLE', 'Oracle')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MORGAN_STANLEY', 'Morgan Stanley')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TYSON_FOODS', 'Tyson Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SAFEWAY', 'Safeway')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONWIDE', 'Nationwide')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DEERE', 'Deere')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DUPONT', 'DuPont')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_EXPRESS', 'American Express')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLSTATE', 'Allstate')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIGNA', 'Cigna')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MONDELEZ_INTERNATIONAL', 'Mondelez International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIAA-CREF', 'TIAA-CREF')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTL_FCSTONE', 'INTL FCStone')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASSACHUSETTS_MUTUAL_LIFE_INSURANCE', 'Massachusetts Mutual Life Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DIRECTV', 'DirecTV')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HALLIBURTON', 'Halliburton')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TWENTY-FIRST_CENTURY_FOX', 'Twenty-First Century Fox')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( '3M', '3M')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEARS_HOLDINGS', 'Sears Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_DYNAMICS', 'General Dynamics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUBLIX_SUPER_MARKETS', 'Publix Super Markets')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PHILIP_MORRIS_INTERNATIONAL', 'Philip Morris International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TJX', 'TJX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIME_WARNER', 'Time Warner')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MACYS', 'Macy''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NIKE', 'Nike')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TECH_DATA', 'Tech Data')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVNET', 'Avnet')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHWESTERN_MUTUAL', 'Northwestern Mutual')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCDONALDS', 'McDonald''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXELON', 'Exelon')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRAVELERS_COS.', 'Travelers Cos.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUALCOMM', 'Qualcomm')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERNATIONAL_PAPER', 'International Paper')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OCCIDENTAL_PETROLEUM', 'Occidental Petroleum')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DUKE_ENERGY', 'Duke Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RITE_AID', 'Rite Aid')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GILEAD_SCIENCES', 'Gilead Sciences')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BAKER_HUGHES', 'Baker Hughes')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EMERSON_ELECTRIC', 'Emerson Electric')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EMC', 'EMC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'USAA', 'USAA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNION_PACIFIC', 'Union Pacific')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHROP_GRUMMAN', 'Northrop Grumman')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALCOA', 'Alcoa')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAPITAL_ONE_FINANCIAL', 'Capital One Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONAL_OILWELL_VARCO', 'National Oilwell Varco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'US_FOODS', 'US Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RAYTHEON', 'Raytheon')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIME_WARNER_CABLE', 'Time Warner Cable')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARROW_ELECTRONICS', 'Arrow Electronics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AFLAC', 'Aflac')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STAPLES', 'Staples')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABBOTT_LABORATORIES', 'Abbott Laboratories')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMMUNITY_HEALTH_SYSTEMS', 'Community Health Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FLUOR', 'Fluor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FREEPORT-MCMORAN', 'Freeport-McMoRan')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'U.S._BANCORP', 'U.S. Bancorp')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NUCOR', 'Nucor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KIMBERLY-CLARK', 'Kimberly-Clark')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HESS', 'Hess')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHESAPEAKE_ENERGY', 'Chesapeake Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XEROX', 'Xerox')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MANPOWERGROUP', 'ManpowerGroup')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMGEN', 'Amgen')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABBVIE', 'AbbVie')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DANAHER', 'Danaher')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHIRLPOOL', 'Whirlpool')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PBF_ENERGY', 'PBF Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOLLYFRONTIER', 'HollyFrontier')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ELI_LILLY', 'Eli Lilly')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DEVON_ENERGY', 'Devon Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PROGRESSIVE', 'Progressive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CUMMINS', 'Cummins')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ICAHN_ENTERPRISES', 'Icahn Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTONATION', 'AutoNation')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KOHLS', 'Kohl''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PACCAR', 'Paccar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOLLAR_GENERAL', 'Dollar General')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARTFORD_FINANCIAL_SERVICES_GROUP', 'Hartford Financial Services Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHWEST_AIRLINES', 'Southwest Airlines')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANADARKO_PETROLEUM', 'Anadarko Petroleum')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHERN', 'Southern')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUPERVALU', 'Supervalu')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KRAFT_FOODS_GROUP', 'Kraft Foods Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GOODYEAR_TIRE_&_RUBBER', 'Goodyear Tire & Rubber')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EOG_RESOURCES', 'EOG Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CENTURYLINK', 'CenturyLink')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALTRIA_GROUP', 'Altria Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TENET_HEALTHCARE', 'Tenet Healthcare')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_MILLS', 'General Mills')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EBAY', 'eBay')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONAGRA_FOODS', 'ConAgra Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEAR', 'Lear')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRW_AUTOMOTIVE_HOLDINGS', 'TRW Automotive Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_STATES_STEEL', 'United States Steel')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PENSKE_AUTOMOTIVE_GROUP', 'Penske Automotive Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AES', 'AES')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COLGATE-PALMOLIVE', 'Colgate-Palmolive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GLOBAL_PARTNERS', 'Global Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'THERMO_FISHER_SCIENTIFIC', 'Thermo Fisher Scientific')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PG&E_CORP.', 'PG&E Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEXTERA_ENERGY', 'NextEra Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_ELECTRIC_POWER', 'American Electric Power')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BAXTER_INTERNATIONAL', 'Baxter International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CENTENE', 'Centene')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STARBUCKS', 'Starbucks')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GAP', 'Gap')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BANK_OF_NEW_YORK_MELLON_CORP.', 'Bank of New York Mellon Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MICRON_TECHNOLOGY', 'Micron Technology')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JABIL_CIRCUIT', 'Jabil Circuit')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PNC_FINANCIAL_SERVICES_GROUP', 'PNC Financial Services Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KINDER_MORGAN', 'Kinder Morgan')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OFFICE_DEPOT', 'Office Depot')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRISTOL-MYERS_SQUIBB', 'Bristol-Myers Squibb')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NRG_ENERGY', 'NRG Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MONSANTO', 'Monsanto')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PPG_INDUSTRIES', 'PPG Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENUINE_PARTS', 'Genuine Parts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OMNICOM_GROUP', 'Omnicom Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ILLINOIS_TOOL_WORKS', 'Illinois Tool Works')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MURPHY_USA', 'Murphy USA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LAND_OLAKES', 'Land O''Lakes')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_REFINING', 'Western Refining')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_DIGITAL', 'Western Digital')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRSTENERGY', 'FirstEnergy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARAMARK', 'Aramark')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISH_NETWORK', 'DISH Network')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LAS_VEGAS_SANDS', 'Las Vegas Sands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KELLOGG', 'Kellogg')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LOEWS', 'Loews')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CBS', 'CBS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ECOLAB', 'Ecolab')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHOLE_FOODS_MARKET', 'Whole Foods Market')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHUBB', 'Chubb')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEALTH_NET', 'Health Net')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WASTE_MANAGEMENT', 'Waste Management')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APACHE', 'Apache')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEXTRON', 'Textron')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYNNEX', 'Synnex')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARRIOTT_INTERNATIONAL', 'Marriott International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VIACOM', 'Viacom')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINCOLN_NATIONAL', 'Lincoln National')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORDSTROM', 'Nordstrom')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'C.H._ROBINSON_WORLDWIDE', 'C.H. Robinson Worldwide')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EDISON_INTERNATIONAL', 'Edison International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARATHON_OIL', 'Marathon Oil')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'YUM_BRANDS', 'Yum Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMPUTER_SCIENCES', 'Computer Sciences')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PARKER-HANNIFIN', 'Parker-Hannifin')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DAVITA_HEALTHCARE_PARTNERS', 'DaVita HealthCare Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARMAX', 'CarMax')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEXAS_INSTRUMENTS', 'Texas Instruments')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WELLCARE_HEALTH_PLANS', 'WellCare Health Plans')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARSH_&_MCLENNAN', 'Marsh & McLennan')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONSOLIDATED_EDISON', 'Consolidated Edison')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ONEOK', 'Oneok')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VISA', 'Visa')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JACOBS_ENGINEERING_GROUP', 'Jacobs Engineering Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CSX', 'CSX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENTERGY', 'Entergy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FACEBOOK', 'Facebook')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOMINION_RESOURCES', 'Dominion Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEUCADIA_NATIONAL', 'Leucadia National')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOYS_"R"_US', 'Toys "R" Us')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DTE_ENERGY', 'DTE Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERIPRISE_FINANCIAL', 'Ameriprise Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VF', 'VF')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRAXAIR', 'Praxair')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.C._PENNEY', 'J.C. Penney')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTOMATIC_DATA_PROCESSING', 'Automatic Data Processing')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'L-3_COMMUNICATIONS', 'L-3 Communications')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CDW', 'CDW')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GUARDIAN_LIFE_INS._CO._OF_AMERICA', 'Guardian Life Ins. Co. of America')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XCEL_ENERGY', 'Xcel Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORFOLK_SOUTHERN', 'Norfolk Southern')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PPL', 'PPL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'R.R._DONNELLEY_&_SONS', 'R.R. Donnelley & Sons')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUNTSMAN', 'Huntsman')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BED_BATH_&_BEYOND', 'Bed Bath & Beyond')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STANLEY_BLACK_&_DECKER', 'Stanley Black & Decker')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'L_BRANDS', 'L Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIBERTY_INTERACTIVE', 'Liberty Interactive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FARMERS_INSURANCE_EXCHANGE', 'Farmers Insurance Exchange')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRST_DATA', 'First Data')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SHERWIN-WILLIAMS', 'Sherwin-Williams')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BLACKROCK', 'BlackRock')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VOYA_FINANCIAL', 'Voya Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROSS_STORES', 'Ross Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEMPRA_ENERGY', 'Sempra Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ESTEE_LAUDER', 'Estee Lauder')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'H.J._HEINZ', 'H.J. Heinz')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REINSURANCE_GROUP_OF_AMERICA', 'Reinsurance Group of America')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUBLIC_SERVICE_ENTERPRISE_GROUP', 'Public Service Enterprise Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAMERON_INTERNATIONAL', 'Cameron International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NAVISTAR_INTERNATIONAL', 'Navistar International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CST_BRANDS', 'CST Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STATE_STREET_CORP.', 'State Street Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNUM_GROUP', 'Unum Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HILTON_WORLDWIDE_HOLDINGS', 'Hilton Worldwide Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FAMILY_DOLLAR_STORES', 'Family Dollar Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRINCIPAL_FINANCIAL', 'Principal Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RELIANCE_STEEL_&_ALUMINUM', 'Reliance Steel & Aluminum')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AIR_PRODUCTS_&_CHEMICALS', 'Air Products & Chemicals')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASSURANT', 'Assurant')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PETER_KIEWIT_SONS', 'Peter Kiewit Sons''')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HENRY_SCHEIN', 'Henry Schein')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COGNIZANT_TECHNOLOGY_SOLUTIONS', 'Cognizant Technology Solutions')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MGM_RESORTS_INTERNATIONAL', 'MGM Resorts International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'W.W._GRAINGER', 'W.W. Grainger')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GROUP_1_AUTOMOTIVE', 'Group 1 Automotive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BB&T_CORP.', 'BB&T Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROCK-TENN', 'Rock-Tenn')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADVANCE_AUTO_PARTS', 'Advance Auto Parts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLY_FINANCIAL', 'Ally Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AGCO', 'AGCO')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CORNING', 'Corning')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIOGEN', 'Biogen')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NGL_ENERGY_PARTNERS', 'NGL Energy Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STRYKER', 'Stryker')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOLINA_HEALTHCARE', 'Molina Healthcare')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRECISION_CASTPARTS', 'Precision Castparts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISCOVER_FINANCIAL_SERVICES', 'Discover Financial Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENWORTH_FINANCIAL', 'Genworth Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EASTMAN_CHEMICAL', 'Eastman Chemical')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DEAN_FOODS', 'Dean Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTOZONE', 'AutoZone')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASTERCARD', 'MasterCard')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OWENS_&_MINOR', 'Owens & Minor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HORMEL_FOODS', 'Hormel Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GAMESTOP', 'GameStop')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTOLIV', 'Autoliv')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CENTERPOINT_ENERGY', 'CenterPoint Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIDELITY_NATIONAL_FINANCIAL', 'Fidelity National Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SONIC_AUTOMOTIVE', 'Sonic Automotive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HD_SUPPLY_HOLDINGS', 'HD Supply Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHARTER_COMMUNICATIONS', 'Charter Communications')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CROWN_HOLDINGS', 'Crown Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APPLIED_MATERIALS', 'Applied Materials')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOSAIC', 'Mosaic')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CBRE_GROUP', 'CBRE Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVON_PRODUCTS', 'Avon Products')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REPUBLIC_SERVICES', 'Republic Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL_HEALTH_SERVICES', 'Universal Health Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DARDEN_RESTAURANTS', 'Darden Restaurants')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STEEL_DYNAMICS', 'Steel Dynamics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNTRUST_BANKS', 'SunTrust Banks')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAESARS_ENTERTAINMENT', 'Caesars Entertainment')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TARGA_RESOURCES', 'Targa Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOLLAR_TREE', 'Dollar Tree')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWS_CORP.', 'News Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BALL', 'Ball')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'THRIVENT_FINANCIAL_FOR_LUTHERANS', 'Thrivent Financial for Lutherans')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASCO', 'Masco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FRANKLIN_RESOURCES', 'Franklin Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVIS_BUDGET_GROUP', 'Avis Budget Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REYNOLDS_AMERICAN', 'Reynolds American')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BECTON_DICKINSON', 'Becton Dickinson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRICELINE_GROUP', 'Priceline Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROADCOM', 'Broadcom')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TENNECO', 'Tenneco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAMPBELL_SOUP', 'Campbell Soup')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AECOM', 'AECOM')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VISTEON', 'Visteon')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DELEK_US_HOLDINGS', 'Delek US Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOVER', 'Dover')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BORGWARNER', 'BorgWarner')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JARDEN', 'Jarden')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UGI', 'UGI')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MURPHY_OIL', 'Murphy Oil')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PVH', 'PVH')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CORE-MARK_HOLDING', 'Core-Mark Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CALPINE', 'Calpine')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'D.R._HORTON', 'D.R. Horton')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WEYERHAEUSER', 'Weyerhaeuser')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KKR', 'KKR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FMC_TECHNOLOGIES', 'FMC Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_FAMILY_INSURANCE_GROUP', 'American Family Insurance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPARTANNASH', 'SpartanNash')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESCO_INTERNATIONAL', 'WESCO International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUANTA_SERVICES', 'Quanta Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOHAWK_INDUSTRIES', 'Mohawk Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOTOROLA_SOLUTIONS', 'Motorola Solutions')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LENNAR', 'Lennar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRAVELCENTERS_OF_AMERICA', 'TravelCenters of America')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEALED_AIR', 'Sealed Air')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EVERSOURCE_ENERGY', 'Eversource Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COCA-COLA_ENTERPRISES', 'Coca-Cola Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CELGENE', 'Celgene')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WILLIAMS', 'Williams')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASHLAND', 'Ashland')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERPUBLIC_GROUP', 'Interpublic Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BLACKSTONE_GROUP', 'Blackstone Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RALPH_LAUREN', 'Ralph Lauren')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUEST_DIAGNOSTICS', 'Quest Diagnostics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HERSHEY', 'Hershey')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEREX', 'Terex')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOSTON_SCIENTIFIC', 'Boston Scientific')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWMONT_MINING', 'Newmont Mining')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLERGAN', 'Allergan')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OREILLY_AUTOMOTIVE', 'O''Reilly Automotive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CASEYS_GENERAL_STORES', 'Casey''s General Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CMS_ENERGY', 'CMS Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FOOT_LOCKER', 'Foot Locker')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'W.R._BERKLEY', 'W.R. Berkley')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PETSMART', 'PetSmart')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PACIFIC_LIFE', 'Pacific Life')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMMERCIAL_METALS', 'Commercial Metals')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AGILENT_TECHNOLOGIES', 'Agilent Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUNTINGTON_INGALLS_INDUSTRIES', 'Huntington Ingalls Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MUTUAL_OF_OMAHA_INSURANCE', 'Mutual of Omaha Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIVE_NATION_ENTERTAINMENT', 'Live Nation Entertainment')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DICKS_SPORTING_GOODS', 'Dick''s Sporting Goods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OSHKOSH', 'Oshkosh')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CELANESE', 'Celanese')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPIRIT_AEROSYSTEMS_HOLDINGS', 'Spirit AeroSystems Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_NATURAL_FOODS', 'United Natural Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEABODY_ENERGY', 'Peabody Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OWENS-ILLINOIS', 'Owens-Illinois')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DILLARDS', 'Dillard''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEVEL_3_COMMUNICATIONS', 'Level 3 Communications')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PANTRY', 'Pantry')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LKQ', 'LKQ')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTEGRYS_ENERGY_GROUP', 'Integrys Energy Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYMANTEC', 'Symantec')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BUCKEYE_PARTNERS', 'Buckeye Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RYDER_SYSTEM', 'Ryder System')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SANDISK', 'SanDisk')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROCKWELL_AUTOMATION', 'Rockwell Automation')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DANA_HOLDING', 'Dana Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LANSING_TRADE_GROUP', 'Lansing Trade Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NCR', 'NCR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPEDITORS_INTERNATIONAL_OF_WASHINGTON', 'Expeditors International of Washington')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OMNICARE', 'Omnicare')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AK_STEEL_HOLDING', 'AK Steel Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIFTH_THIRD_BANCORP', 'Fifth Third Bancorp')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEABOARD', 'Seaboard')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NISOURCE', 'NiSource')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABLEVISION_SYSTEMS', 'Cablevision Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANIXTER_INTERNATIONAL', 'Anixter International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EMCOR_GROUP', 'EMCOR Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIDELITY_NATIONAL_INFORMATION_SERVICES', 'Fidelity National Information Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BARNES_&_NOBLE', 'Barnes & Noble')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KBR', 'KBR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTO-OWNERS_INSURANCE', 'Auto-Owners Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JONES_FINANCIAL', 'Jones Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVERY_DENNISON', 'Avery Dennison')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NETAPP', 'NetApp')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IHEARTMEDIA', 'iHeartMedia')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DISCOVERY_COMMUNICATIONS', 'Discovery Communications')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARLEY-DAVIDSON', 'Harley-Davidson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SANMINA', 'Sanmina')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRINITY_INDUSTRIES', 'Trinity Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.B._HUNT_TRANSPORT_SERVICES', 'J.B. Hunt Transport Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHARLES_SCHWAB', 'Charles Schwab')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ERIE_INSURANCE_GROUP', 'Erie Insurance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DR_PEPPER_SNAPPLE_GROUP', 'Dr Pepper Snapple Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMEREN', 'Ameren')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MATTEL', 'Mattel')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LABORATORY_CORP._OF_AMERICA', 'Laboratory Corp. of America')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GANNETT', 'Gannett')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STARWOOD_HOTELS_&_RESORTS', 'Starwood Hotels & Resorts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_CABLE', 'General Cable')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'A-MARK_PRECIOUS_METALS', 'A-Mark Precious Metals')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRAYBAR_ELECTRIC', 'Graybar Electric')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGY_FUTURE_HOLDINGS', 'Energy Future Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HRG_GROUP', 'HRG Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MRC_GLOBAL', 'MRC Global')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPECTRA_ENERGY', 'Spectra Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASBURY_AUTOMOTIVE_GROUP', 'Asbury Automotive Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PACKAGING_CORP._OF_AMERICA', 'Packaging Corp. of America')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WINDSTREAM_HOLDINGS', 'Windstream Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PULTEGROUP', 'PulteGroup')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JETBLUE_AIRWAYS', 'JetBlue Airways')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWELL_RUBBERMAID', 'Newell Rubbermaid')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CON-WAY', 'Con-way')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CALUMET_SPECIALTY_PRODUCTS_PARTNERS', 'Calumet Specialty Products Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPEDIA', 'Expedia')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_FINANCIAL_GROUP', 'American Financial Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRACTOR_SUPPLY', 'Tractor Supply')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_RENTALS', 'United Rentals')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INGREDION', 'Ingredion')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NAVIENT', 'Navient')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEADWESTVACO', 'MeadWestvaco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AGL_RESOURCES', 'AGL Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ST._JUDE_MEDICAL', 'St. Jude Medical')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.M._SMUCKER', 'J.M. Smucker')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_UNION', 'Western Union')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CLOROX', 'Clorox')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DOMTAR', 'Domtar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KELLY_SERVICES', 'Kelly Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OLD_REPUBLIC_INTERNATIONAL', 'Old Republic International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADVANCED_MICRO_DEVICES', 'Advanced Micro Devices')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NETFLIX', 'Netflix')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOOZ_ALLEN_HAMILTON_HOLDING', 'Booz Allen Hamilton Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUINTILES_TRANSNATIONAL_HOLDINGS', 'Quintiles Transnational Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WYNN_RESORTS', 'Wynn Resorts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JONES_LANG_LASALLE', 'Jones Lang LaSalle')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGIONS_FINANCIAL', 'Regions Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CH2M_HILL', 'CH2M Hill')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTERN_&_SOUTHERN_FINANCIAL_GROUP', 'Western & Southern Financial Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LITHIA_MOTORS', 'Lithia Motors')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SALESFORCE.COM', 'salesforce.com')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALASKA_AIR_GROUP', 'Alaska Air Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOST_HOTELS_&_RESORTS', 'Host Hotels & Resorts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARMAN_INTERNATIONAL_INDUSTRIES', 'Harman International Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMPHENOL', 'Amphenol')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REALOGY_HOLDINGS', 'Realogy Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ESSENDANT', 'Essendant')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HANESBRANDS', 'Hanesbrands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KINDRED_HEALTHCARE', 'Kindred Healthcare')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARRIS_GROUP', 'ARRIS Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INSIGHT_ENTERPRISES', 'Insight Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANCE_DATA_SYSTEMS', 'Alliance Data Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIFEPOINT_HEALTH', 'LifePoint Health')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PIONEER_NATURAL_RESOURCES', 'Pioneer Natural Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WYNDHAM_WORLDWIDE', 'Wyndham Worldwide')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OWENS_CORNING', 'Owens Corning')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLEGHANY', 'Alleghany')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCGRAW_HILL_FINANCIAL', 'McGraw Hill Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIG_LOTS', 'Big Lots')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHERN_TIER_ENERGY', 'Northern Tier Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEXION', 'Hexion')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARKEL', 'Markel')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NOBLE_ENERGY', 'Noble Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEIDOS_HOLDINGS', 'Leidos Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROCKWELL_COLLINS', 'Rockwell Collins')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AIRGAS', 'Airgas')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPRAGUE_RESOURCES', 'Sprague Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'YRC_WORLDWIDE', 'YRC Worldwide')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HANOVER_INSURANCE_GROUP', 'Hanover Insurance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FISERV', 'Fiserv')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LORILLARD', 'Lorillard')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_TIRE_DISTRIBUTORS_HOLDINGS', 'American Tire Distributors Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABM_INDUSTRIES', 'ABM Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SONOCO_PRODUCTS', 'Sonoco Products')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARRIS', 'Harris')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TELEPHONE_&_DATA_SYSTEMS', 'Telephone & Data Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WISCONSIN_ENERGY', 'Wisconsin Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINN_ENERGY', 'Linn Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RAYMOND_JAMES_FINANCIAL', 'Raymond James Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BERRY_PLASTICS_GROUP', 'Berry Plastics Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGENCY_ENERGY_PARTNERS', 'Regency Energy Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCANA', 'SCANA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CINCINNATI_FINANCIAL', 'Cincinnati Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ATMOS_ENERGY', 'Atmos Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEPCO_HOLDINGS', 'Pepco Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FLOWSERVE', 'Flowserve')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SIMON_PROPERTY_GROUP', 'Simon Property Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONSTELLATION_BRANDS', 'Constellation Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QUAD/GRAPHICS', 'Quad/Graphics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BURLINGTON_STORES', 'Burlington Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEIMAN_MARCUS_GROUP', 'Neiman Marcus Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BEMIS', 'Bemis')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COACH', 'Coach')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONTINENTAL_RESOURCES', 'Continental Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ASCENA_RETAIL_GROUP', 'Ascena Retail Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ZOETIS', 'Zoetis')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ORBITAL_ATK', 'Orbital ATK')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FRONTIER_COMMUNICATIONS', 'Frontier Communications')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEVI_STRAUSS', 'Levi Strauss')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPX', 'SPX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CF_INDUSTRIES_HOLDINGS', 'CF Industries Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MICHAELS_COS.', 'Michaels Cos.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'M&T_BANK_CORP.', 'M&T Bank Corp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RUSH_ENTERPRISES', 'Rush Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALERIS', 'Aleris')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEXEO_SOLUTIONS_HOLDINGS', 'Nexeo Solutions Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KEURIG_GREEN_MOUNTAIN', 'Keurig Green Mountain')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUPERIOR_ENERGY_SERVICES', 'Superior Energy Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WILLIAMS-SONOMA', 'Williams-Sonoma')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROBERT_HALF_INTERNATIONAL', 'Robert Half International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NVIDIA', 'Nvidia')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRST_AMERICAN_FINANCIAL', 'First American Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ZIMMER_HOLDINGS', 'Zimmer Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MDU_RESOURCES_GROUP', 'MDU Resources Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JUNIPER_NETWORKS', 'Juniper Networks')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARTHUR_J._GALLAGHER', 'Arthur J. Gallagher')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COLFAX', 'Colfax')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CLIFFS_NATURAL_RESOURCES', 'Cliffs Natural Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'YAHOO', 'Yahoo')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MASTEC', 'MasTec')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LAM_RESEARCH', 'Lam Research')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AXIALL', 'Axiall')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERCONTINENTAL_EXCHANGE', 'Intercontinental Exchange')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CINTAS', 'Cintas')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COTY', 'Coty')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CA', 'CA')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANDERSONS', 'Andersons')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VALSPAR', 'Valspar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTHERN_TRUST', 'Northern Trust')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTUIT', 'Intuit')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TUTOR_PERINI', 'Tutor Perini')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POLARIS_INDUSTRIES', 'Polaris Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOSPIRA', 'Hospira')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FM_GLOBAL', 'FM Global')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NVR', 'NVR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LIBERTY_MEDIA', 'Liberty Media')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGIZER_HOLDINGS', 'Energizer Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BLOOMIN_BRANDS', 'Bloomin'' Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AVAYA', 'Avaya')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTLAKE_CHEMICAL', 'Westlake Chemical')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HYATT_HOTELS', 'Hyatt Hotels')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEAD_JOHNSON_NUTRITION', 'Mead Johnson Nutrition')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ACTIVISION_BLIZZARD', 'Activision Blizzard')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PROTECTIVE_LIFE', 'Protective Life')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENVISION_HEALTHCARE_HOLDINGS', 'Envision Healthcare Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FORTUNE_BRANDS_HOME_&_SECURITY', 'Fortune Brands Home & Security')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RPM_INTERNATIONAL', 'RPM International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VWR', 'VWR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LPL_FINANCIAL_HOLDINGS', 'LPL Financial Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KEYCORP', 'KeyCorp')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SWIFT_TRANSPORTATION', 'Swift Transportation')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALPHA_NATURAL_RESOURCES', 'Alpha Natural Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HASBRO', 'Hasbro')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RESOLUTE_FOREST_PRODUCTS', 'Resolute Forest Products')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIFFANY', 'Tiffany')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MCCORMICK', 'McCormick')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRAPHIC_PACKAGING_HOLDING', 'Graphic Packaging Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREIF', 'Greif')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLEGHENY_TECHNOLOGIES', 'Allegheny Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SECURIAN_FINANCIAL_GROUP', 'Securian Financial Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'B/E_AEROSPACE', 'B/E Aerospace')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXELIS', 'Exelis')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADOBE_SYSTEMS', 'Adobe Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOLSON_COORS_BREWING', 'Molson Coors Brewing')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROUNDYS', 'Roundy''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CNO_FINANCIAL_GROUP', 'CNO Financial Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADAMS_RESOURCES_&_ENERGY', 'Adams Resources & Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BELK', 'Belk')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHIPOTLE_MEXICAN_GRILL', 'Chipotle Mexican Grill')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_TOWER', 'American Tower')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FMC', 'FMC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HILLSHIRE_BRANDS', 'Hillshire Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMTRUST_FINANCIAL_SERVICES', 'AmTrust Financial Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRUNSWICK', 'Brunswick')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PATTERSON', 'Patterson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHWESTERN_ENERGY', 'Southwestern Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMETEK', 'Ametek')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'T._ROWE_PRICE', 'T. Rowe Price')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TORCHMARK', 'Torchmark')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DARLING_INGREDIENTS', 'Darling Ingredients')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEGGETT_&_PLATT', 'Leggett & Platt')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WATSCO', 'Watsco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CRESTWOOD_EQUITY_PARTNERS', 'Crestwood Equity Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XYLEM', 'Xylem')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SILGAN_HOLDINGS', 'Silgan Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOLL_BROTHERS', 'Toll Brothers')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MANITOWOC', 'Manitowoc')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCIENCE_APPLICATIONS_INTERNATIONAL', 'Science Applications International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARLYLE_GROUP', 'Carlyle Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TIMKEN', 'Timken')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENESIS_ENERGY', 'Genesis Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WPX_ENERGY', 'WPX Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CAREFUSION', 'CareFusion')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PITNEY_BOWES', 'Pitney Bowes')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INGLES_MARKETS', 'Ingles Markets')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POLYONE', 'PolyOne')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROOKDALE_SENIOR_LIVING', 'Brookdale Senior Living')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMMSCOPE_HOLDING', 'CommScope Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERITOR', 'Meritor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'JOY_GLOBAL', 'Joy Global')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIFIED_GROCERS', 'Unified Grocers')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIUMPH_GROUP', 'Triumph Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MAGELLAN_HEALTH', 'Magellan Health')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SALLY_BEAUTY_HOLDINGS', 'Sally Beauty Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FLOWERS_FOODS', 'Flowers Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ABERCROMBIE_&_FITCH', 'Abercrombie & Fitch')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEW_JERSEY_RESOURCES', 'New Jersey Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FASTENAL', 'Fastenal')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NII_HOLDINGS', 'NII Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONSOL_ENERGY', 'Consol Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'USG', 'USG')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRINKS', 'Brink''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HELMERICH_&_PAYNE', 'Helmerich & Payne')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEXMARK_INTERNATIONAL', 'Lexmark International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_AXLE_&_MANUFACTURING', 'American Axle & Manufacturing')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CROWN_CASTLE_INTERNATIONAL', 'Crown Castle International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TARGA_ENERGY', 'Targa Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OCEANEERING_INTERNATIONAL', 'Oceaneering International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABOT', 'Cabot')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIT_GROUP', 'CIT Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABELAS', 'Cabela''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FOREST_LABORATORIES', 'Forest Laboratories')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DCP_MIDSTREAM_PARTNERS', 'DCP Midstream Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RYERSON_HOLDING', 'Ryerson Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'QEP_RESOURCES', 'QEP Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'THOR_INDUSTRIES', 'Thor Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HSN', 'HSN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRAHAM_HOLDINGS', 'Graham Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ELECTRONIC_ARTS', 'Electronic Arts')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOISE_CASCADE', 'Boise Cascade')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUB_GROUP', 'Hub Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CACI_INTERNATIONAL', 'CACI International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ROPER_TECHNOLOGIES', 'Roper Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOWERS_WATSON', 'Towers Watson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SMART_&_FINAL_STORES', 'Smart & Final Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIG_HEART_PET_BRANDS', 'Big Heart Pet Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FOSSIL_GROUP', 'Fossil Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NASDAQ_OMX_GROUP', 'Nasdaq OMX Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COUNTRY_FINANCIAL', 'Country Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SNAP-ON', 'Snap-on')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PINNACLE_WEST_CAPITAL', 'Pinnacle West Capital')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ECHOSTAR', 'EchoStar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYSTEMAX', 'Systemax')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHITEWAVE_FOODS', 'WhiteWave Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CUNA_MUTUAL_GROUP', 'CUNA Mutual Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COOPER_TIRE_&_RUBBER', 'Cooper Tire & Rubber')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ADT', 'ADT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CERNER', 'Cerner')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CLEAN_HARBORS', 'Clean Harbors')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FIRST_SOLAR', 'First Solar')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LENNOX_INTERNATIONAL', 'Lennox International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENABLE_MIDSTREAM_PARTNERS', 'Enable Midstream Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUBBELL', 'Hubbell')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNISYS', 'Unisys')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANT_ENERGY', 'Alliant Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEALTH_CARE_REIT', 'Health Care REIT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOODYS', 'Moody''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'C.R._BARD', 'C.R. Bard')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'URBAN_OUTFITTERS', 'Urban Outfitters')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHURCH_&_DWIGHT', 'Church & Dwight')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_EAGLE_OUTFITTERS', 'American Eagle Outfitters')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OAKTREE_CAPITAL_GROUP', 'Oaktree Capital Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGAL_BELOIT', 'Regal Beloit')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MENS_WEARHOUSE', 'Men''s Wearhouse')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COOPER-STANDARD_HOLDINGS', 'Cooper-Standard Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'W.R._GRACE', 'W.R. Grace')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ULTA_SALON_COSMETICS_&_FRAGRANCE', 'Ulta Salon Cosmetics & Fragrance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HAWAIIAN_ELECTRIC_INDUSTRIES', 'Hawaiian Electric Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SKYWEST', 'SkyWest')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREEN_PLAINS', 'Green Plains')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LVB_ACQUISITION', 'LVB Acquisition')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NBTY', 'NBTY')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARLISLE', 'Carlisle')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNITED_REFINING', 'United Refining')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TESLA_MOTORS', 'Tesla Motors')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GROUPON', 'Groupon')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LANDSTAR_SYSTEM', 'Landstar System')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PATTERSON-UTI_ENERGY', 'Patterson-UTI Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EP_ENERGY', 'EP Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ON_SEMICONDUCTOR', 'ON Semiconductor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RENT-A-CENTER', 'Rent-A-Center')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNGARD_DATA_SYSTEMS', 'SunGard Data Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CITRIX_SYSTEMS', 'Citrix Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMKOR_TECHNOLOGY', 'Amkor Technology')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TD_AMERITRADE_HOLDING', 'TD Ameritrade Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WORTHINGTON_INDUSTRIES', 'Worthington Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VALMONT_INDUSTRIES', 'Valmont Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IRON_MOUNTAIN', 'Iron Mountain')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUGET_ENERGY', 'Puget Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CME_GROUP', 'CME Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IAC/INTERACTIVECORP', 'IAC/InterActiveCorp')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PAR_PETROLEUM', 'Par Petroleum')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TAYLOR_MORRISON_HOME', 'Taylor Morrison Home')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHIQUITA_BRANDS_INTERNATIONAL', 'Chiquita Brands International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERNATIONAL_FLAVORS_&_FRAGRANCES', 'International Flavors & Fragrances')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WHITING_PETROLEUM', 'Whiting Petroleum')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNDER_ARMOUR', 'Under Armour')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VENTAS', 'Ventas')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NUSTAR_ENERGY', 'NuStar Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SELECT_MEDICAL_HOLDINGS', 'Select Medical Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DIEBOLD', 'Diebold')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_NATIONAL_INSURANCE', 'American National Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VARIAN_MEDICAL_SYSTEMS', 'Varian Medical Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APOLLO_EDUCATION_GROUP', 'Apollo Education Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTINGHOUSE_AIR_BRAKE_TECHNOLOGIES', 'Westinghouse Air Brake Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNPOWER', 'SunPower')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WARNER_MUSIC_GROUP', 'Warner Music Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_WATER_WORKS', 'American Water Works')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'H&R_BLOCK', 'H&R Block')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERCURY_GENERAL', 'Mercury General')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TECO_ENERGY', 'TECO Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SERVICE_CORP._INTERNATIONAL', 'Service Corp. International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VULCAN_MATERIALS', 'Vulcan Materials')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROWN-FORMAN', 'Brown-Forman')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGAL_ENTERTAINMENT_GROUP', 'Regal Entertainment Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEMPUR_SEALY_INTERNATIONAL', 'Tempur Sealy International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STEELCASE', 'Steelcase')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MWI_VETERINARY_SUPPLY', 'MWI Veterinary Supply')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RADIOSHACK', 'RadioShack')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPROUTS_FARMERS_MARKET', 'Sprouts Farmers Market')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SABRE', 'Sabre')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARTIN_MARIETTA_MATERIALS', 'Martin Marietta Materials')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HUNTINGTON_BANCSHARES', 'Huntington Bancshares')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALERE', 'Alere')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TREEHOUSE_FOODS', 'TreeHouse Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARCH_COAL', 'Arch Coal')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KLA-TENCOR', 'KLA-Tencor')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CRANE', 'Crane')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IASIS_HEALTHCARE', 'Iasis Healthcare')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BABCOCK_&_WILCOX', 'Babcock & Wilcox')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DENTSPLY_INTERNATIONAL', 'Dentsply International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIBUNE_MEDIA', 'Tribune Media')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCANSOURCE', 'ScanSource')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVISION_COMMUNICATIONS', 'Univision Communications')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BRINKER_INTERNATIONAL', 'Brinker International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXTERRAN_HOLDINGS', 'Exterran Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARTERS', 'Carter''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANALOG_DEVICES', 'Analog Devices')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENESCO', 'Genesco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCOTTS_MIRACLE-GRO', 'Scotts Miracle-Gro')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONVERGYS', 'Convergys')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXIDE_TECHNOLOGIES', 'Exide Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WABCO_HOLDINGS', 'WABCO Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KENNAMETAL', 'Kennametal')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERCO', 'Amerco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BON-TON_STORES', 'Bon-Ton Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TEAM_HEALTH_HOLDINGS', 'Team Health Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REGENERON_PHARMACEUTICALS', 'Regeneron Pharmaceuticals')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SPRINGLEAF_HOLDINGS', 'Springleaf Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINCOLN_ELECTRIC_HOLDINGS', 'Lincoln Electric Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DRESSER-RAND_GROUP', 'Dresser-Rand Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WEST', 'West')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BENCHMARK_ELECTRONICS', 'Benchmark Electronics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PALL', 'Pall')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OLD_DOMINION_FREIGHT_LINE', 'Old Dominion Freight Line')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MSC_INDUSTRIAL_DIRECT', 'MSC Industrial Direct')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SENTRY_INSURANCE_GROUP', 'Sentry Insurance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SIGMA-ALDRICH', 'Sigma-Aldrich')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WGL_HOLDINGS', 'WGL Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WEIS_MARKETS', 'Weis Markets')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SANDERSON_FARMS', 'Sanderson Farms')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STANCORP_FINANCIAL_GROUP', 'StanCorp Financial Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HYSTER-YALE_MATERIALS_HANDLING', 'Hyster-Yale Materials Handling')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WOLVERINE_WORLD_WIDE', 'Wolverine World Wide')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DST_SYSTEMS', 'DST Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LEGG_MASON', 'Legg Mason')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TERADATA', 'Teradata')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AARONS', 'Aaron''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANTERO_RESOURCES', 'Antero Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'METALDYNE_PERFORMANCE_GROUP', 'Metaldyne Performance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RANGE_RESOURCES', 'Range Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VORNADO_REALTY_TRUST', 'Vornado Realty Trust')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOYD_GAMING', 'Boyd Gaming')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COVANCE', 'Covance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARMSTRONG_WORLD_INDUSTRIES', 'Armstrong World Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CRACKER_BARREL_OLD_COUNTRY_STORE', 'Cracker Barrel Old Country Store')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHICOS_FAS', 'Chico''s FAS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCRIPPS_NETWORKS_INTERACTIVE', 'Scripps Networks Interactive')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL_FOREST_PRODUCTS', 'Universal Forest Products')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CONCHO_RESOURCES', 'Concho Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ITT', 'ITT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HCC_INSURANCE_HOLDINGS', 'HCC Insurance Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOOG', 'Moog')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IMS_HEALTH_HOLDINGS', 'IMS Health Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CINEMARK_HOLDINGS', 'Cinemark Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COMERICA', 'Comerica')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQUITY_RESIDENTIAL', 'Equity Residential')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RYLAND_GROUP', 'Ryland Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GNC_HOLDINGS', 'GNC Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ARCBEST', 'ArcBest')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VECTREN', 'Vectren')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CURTISS-WRIGHT', 'Curtiss-Wright')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TUPPERWARE_BRANDS', 'Tupperware Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WESTAR_ENERGY', 'Westar Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALBEMARLE', 'Albemarle')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APTARGROUP', 'AptarGroup')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PINNACLE_FOODS', 'Pinnacle Foods')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PENN_NATIONAL_GAMING', 'Penn National Gaming')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'J.CREW_GROUP', 'J.Crew Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VANTIV', 'Vantiv')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KANSAS_CITY_SOUTHERN', 'Kansas City Southern')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CALERES', 'Caleres')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NU_SKIN_ENTERPRISES', 'Nu Skin Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREAT_PLAINS_ENERGY', 'Great Plains Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KIRBY', 'Kirby')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GENERAL_GROWTH_PROPERTIES', 'General Growth Properties')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROADRIDGE_FINANCIAL_SOLUTIONS', 'Broadridge Financial Solutions')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STERICYCLE', 'Stericycle')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GLOBAL_PAYMENTS', 'Global Payments')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NORTEK', 'Nortek')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SCHNITZER_STEEL_INDUSTRIES', 'Schnitzer Steel Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL', 'Universal')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ANN', 'ANN')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOLOGIC', 'Hologic')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PANERA_BREAD', 'Panera Bread')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AOL', 'AOL')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SM_ENERGY', 'SM Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PAYCHEX', 'Paychex')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRICESMART', 'PriceSmart')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AUTODESK', 'Autodesk')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AFFILIATED_MANAGERS_GROUP', 'Affiliated Managers Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOPS_HOLDING', 'Tops Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DYNEGY', 'Dynegy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DSW', 'DSW')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'VISHAY_INTERTECHNOLOGY', 'Vishay Intertechnology')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'METTLER-TOLEDO_INTERNATIONAL', 'Mettler-Toledo International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SUNEDISON', 'SunEdison')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TETRA_TECH', 'Tetra Tech')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MOMENTIVE_PERFORMANCE_MATERIALS', 'Momentive Performance Materials')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERSYS', 'EnerSys')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DONALDSON', 'Donaldson')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQT', 'EQT')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MONSTER_BEVERAGE', 'Monster Beverage')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PC_CONNECTION', 'PC Connection')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOTAL_SYSTEM_SERVICES', 'Total System Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SERVICEMASTER_GLOBAL_HOLDINGS', 'ServiceMaster Global Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEDICAL_MUTUAL_OF_OHIO', 'Medical Mutual of Ohio')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'APPLIED_INDUSTRIAL_TECHNOLOGIES', 'Applied Industrial Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MAXIM_INTEGRATED_PRODUCTS', 'Maxim Integrated Products')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OGE_ENERGY', 'OGE Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'A._SCHULMAN', 'A. Schulman')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQUINIX', 'Equinix')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MEDNAX', 'Mednax')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EQUIFAX', 'Equifax')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STANDARD_PACIFIC', 'Standard Pacific')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DENBURY_RESOURCES', 'Denbury Resources')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIMAREX_ENERGY', 'Cimarex Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MUTUAL_OF_AMERICA_LIFE_INSURANCE', 'Mutual of America Life Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GUESS', 'Guess')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POST_HOLDINGS', 'Post Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEALTHSOUTH', 'HealthSouth')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'FERRELLGAS_PARTNERS', 'Ferrellgas Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KB_HOME', 'KB Home')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BOSTON_PROPERTIES', 'Boston Properties')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIMBLE_NAVIGATION', 'Trimble Navigation')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TELEDYNE_TECHNOLOGIES', 'Teledyne Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ACUITY_BRANDS', 'Acuity Brands')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SKECHERS_U.S.A.', 'Skechers U.S.A.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XILINX', 'Xilinx')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PLEXUS', 'Plexus')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWFIELD_EXPLORATION', 'Newfield Exploration')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRANSDIGM_GROUP', 'TransDigm Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KAR_AUCTION_SERVICES', 'Kar Auction Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MUELLER_INDUSTRIES', 'Mueller Industries')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ZIONS_BANCORP.', 'Zions Bancorp.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INSPERITY', 'Insperity')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'XPO_LOGISTICS', 'XPO Logistics')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEARS_HOMETOWN_&_OUTLET_STORES', 'Sears Hometown & Outlet Stores')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'A.O._SMITH', 'A.O. Smith')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANCE_ONE_INTERNATIONAL', 'Alliance One International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TAKE-TWO_INTERACTIVE_SOFTWARE', 'Take-Two Interactive Software')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HHGREGG', 'hhgregg')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RPC', 'RPC')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NEWMARKET', 'NewMarket')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BEACON_ROOFING_SUPPLY', 'Beacon Roofing Supply')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EDWARDS_LIFESCIENCES', 'Edwards Lifesciences')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRIPLE-S_MANAGEMENT', 'Triple-S Management')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HAWAIIAN_HOLDINGS', 'Hawaiian Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HEARTLAND_PAYMENT_SYSTEMS', 'Heartland Payment Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BELDEN', 'Belden')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MAGELLAN_MIDSTREAM_PARTNERS', 'Magellan Midstream Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OUTERWALL', 'Outerwall')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KAPSTONE_PAPER_&_PACKAGING', 'KapStone Paper & Packaging')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLIANCE_HOLDINGS', 'Alliance Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SKYWORKS_SOLUTIONS', 'Skyworks Solutions')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CIENA', 'Ciena')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GRANITE_CONSTRUCTION', 'Granite Construction')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EDUCATION_MANAGEMENT', 'Education Management')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PARTY_CITY_HOLDINGS', 'Party City Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HCP', 'HCP')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PAREXEL_INTERNATIONAL', 'Parexel International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DELTA_TUCKER_HOLDINGS', 'Delta Tucker Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PINNACLE_ENTERTAINMENT', 'Pinnacle Entertainment')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'STIFEL_FINANCIAL', 'Stifel Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POOL', 'Pool')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OLIN', 'Olin')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KNIGHTS_OF_COLUMBUS', 'Knights of Columbus')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PERKINELMER', 'PerkinElmer')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALEXION_PHARMACEUTICALS', 'Alexion Pharmaceuticals')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IHS', 'IHS')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OIL_STATES_INTERNATIONAL', 'Oil States International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HNI', 'HNI')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'LINKEDIN', 'LinkedIn')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'DIPLOMAT_PHARMACY', 'Diplomat Pharmacy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BROCADE_COMMUNICATIONS_SYSTEMS', 'Brocade Communications Systems')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GREENBRIER_COS.', 'Greenbrier Cos.')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMC_NETWORKS', 'AMC Networks')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'KEMPER', 'Kemper')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'OCWEN_FINANCIAL', 'Ocwen Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PUBLIC_STORAGE', 'Public Storage')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRINET_GROUP', 'TriNet Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CHEMTURA', 'Chemtura')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYMETRA_FINANCIAL', 'Symetra Financial')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TOWER_INTERNATIONAL', 'Tower International')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MERITAGE_HOMES', 'Meritage Homes')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'MARKWEST_ENERGY_PARTNERS', 'MarkWest Energy Partners')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'BIO-RAD_LABORATORIES', 'Bio-Rad Laboratories')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TRUEBLUE', 'TrueBlue')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CABOT_OIL_&_GAS', 'Cabot Oil & Gas')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'CARPENTER_TECHNOLOGY', 'Carpenter Technology')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'TORO', 'Toro')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMERICAN_EQUITY_INVESTMENT_LIFE_HOLDING', 'American Equity Investment Life Holding')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EXPRESS', 'Express')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'EASTMAN_KODAK', 'Eastman Kodak')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HAIN_CELESTIAL_GROUP', 'Hain Celestial Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONSTAR_MORTGAGE_HOLDINGS', 'Nationstar Mortgage Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'IDEX', 'IDEX')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'POPULAR', 'Popular')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WERNER_ENTERPRISES', 'Werner Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ESTERLINE_TECHNOLOGIES', 'Esterline Technologies')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTUITIVE_SURGICAL', 'Intuitive Surgical')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ALLISON_TRANSMISSION_HOLDINGS', 'Allison Transmission Holdings')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEMGROUP', 'SemGroup')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SOUTHWEST_GAS', 'Southwest Gas')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'G-III_APPAREL_GROUP', 'G-III Apparel Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'NATIONAL_FUEL_GAS', 'National Fuel Gas')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'H.B._FULLER', 'H.B. Fuller')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PENN_MUTUAL_LIFE_INSURANCE', 'Penn Mutual Life Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'RCS_CAPITAL', 'RCS Capital')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'COLUMBIA_SPORTSWEAR', 'Columbia Sportswear')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AMICA_MUTUAL_INSURANCE', 'Amica Mutual Insurance')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PRIMORIS_SERVICES', 'Primoris Services')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'ENERGEN', 'Energen')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'REXNORD', 'Rexnord')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SEVENTY_SEVEN_ENERGY', 'Seventy Seven Energy')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WASTE_CONNECTIONS', 'Waste Connections')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'PEP_BOYS-MANNY,_MOE_&_JACK', 'Pep Boys-Manny, Moe & Jack')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HARSCO', 'Harsco')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'HOVNANIAN_ENTERPRISES', 'Hovnanian Enterprises')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WILLBROS_GROUP', 'Willbros Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'WENDYS', 'Wendy''s')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'INTERNATIONAL_GAME_TECHNOLOGY', 'International Game Technology')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SYNOPSYS', 'Synopsys')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'UNIVERSAL_AMERICAN', 'Universal American')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'AAR', 'AAR')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'SELECTIVE_INSURANCE_GROUP', 'Selective Insurance Group')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'GARTNER', 'Gartner')
INSERT INTO [dbo].[Project] ([Code], [Name]) VALUES ( 'E*TRADE_FINANCIAL', 'E*Trade Financial')

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
DECLARE @limitSeeImpact FLOAT = 0.75

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
           [Date],
           [Notes]
         )
         VALUES (
           @candidateId,
           [dbo].[RandomEvaluationType](RAND()),
           [dbo].[RandomDate](2000, RAND()),
           [dbo].[RandomNotes](RAND())
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
WHERE [CandidateId] IN (SELECT [C].[Id]
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

UPDATE [dbo].[Candidate]
SET [CurrentProjectId] = 1, -- Endava
    [InBench] = 0,
    [CurrentProjectJoin] = [dbo].[RandomDate](1000, RAND())
WHERE [RelationType] = 1 AND [CandidateRoleId] = 8 -- 8: Admin

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
DROP FUNCTION IF EXISTS [dbo].[RandomNotes]

DROP FUNCTION IF EXISTS [dbo].[GradeFromStr]
GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
