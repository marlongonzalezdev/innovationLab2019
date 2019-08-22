﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Repositories
{
    public class SkillRepository : ISkillRepository
    {
        #region Retrieve
        #region Skill
        public List<Skill> GetSkills()
        {
            var res = new List<Skill>();

            var query = "SELECT [GS].[SkillId], " +
                        "       [GS].[RelatedId]," +
                        "       [GS].[Category]," +
                        "       [GS].[Code]," +
                        "       [GS].[Name]," +
                        "       [GS].[DefaultExpertise] " +
                        "FROM [dbo].[GlobalSkill] AS [GS]";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(getSkillFromDataRow(dr));
                    }
                }
            }

            return (res);
        }

        public Skill GetSkillById(int id)
        {
            Skill res = null;

            var query = "SELECT [GS].[SkillId], " +
                        "       [GS].[RelatedId]," +
                        "       [GS].[Category]," +
                        "       [GS].[Code]," +
                        "       [GS].[Name]," +
                        "       [GS].[DefaultExpertise] " +
                        "FROM [dbo].[GlobalSkill] AS [GS] " +
                        "WHERE [GS].[SkillId] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getSkillFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        public Skill GetSkillByCode(string code)
        {
            Skill res = null;

            var query = "SELECT [GS].[SkillId], " +
                        "       [GS].[RelatedId]," +
                        "       [GS].[Category]," +
                        "       [GS].[Code]," +
                        "       [GS].[Name]," +
                        "       [GS].[DefaultExpertise] " +
                        "FROM [dbo].[GlobalSkill] AS [GS] " +
                        "WHERE [GS].[Code] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getSkillFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        private Skill getSkillFromDataRow(DataRow dr)
        {
            Skill res = null;

            res = new Skill()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
            };

            return (res);
        }
        #endregion

        #region BusinessArea
        public BusinessArea GetBusinessAreaById(int id)
        {
            BusinessArea res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [BA].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [BA].[Code]," +
                        "       [BA].[Name]," +
                        "       [BA].[DefaultExpertise] " +
                        "FROM [dbo].[Skill] AS [S] " +
                        "INNER JOIN [dbo].[BusinessArea] AS [BA] ON [BA].[Id] = [S].[BusinessAreaId] " +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.BusinessArea;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getBusinessAreaFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        public BusinessArea GetBusinessAreaByCode(string code)
        {
            BusinessArea res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [BA].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [BA].[Code]," +
                        "       [BA].[Name]," +
                        "       [BA].[DefaultExpertise] " +
                        "FROM [dbo].[Skill] AS [S] " +
                        "INNER JOIN [dbo].[BusinessArea] AS [BA] ON [BA].[Id] = [S].[BusinessAreaId] " +
                        "WHERE [BA].[Code] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.BusinessArea;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getBusinessAreaFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        private BusinessArea getBusinessAreaFromDataRow(DataRow dr)
        {
            BusinessArea res = null;

            res = new BusinessArea()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
            };

            return (res);
        }
        #endregion

        #region SoftSkill
        public SoftSkill GetSoftSkillById(int id)
        {
            SoftSkill res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [SK].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [SK].[Code]," +
                        "       [SK].[Name]," +
                        "       [SK].[DefaultExpertise] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[SoftSkill] AS [SK] ON [SK].[Id] = [S].[SoftSkillId]" +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.SoftSkill;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getSoftSkillFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        public SoftSkill GetSoftSkillByCode(string code)
        {
            SoftSkill res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [SK].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [SK].[Code]," +
                        "       [SK].[Name]," +
                        "       [SK].[DefaultExpertise] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[SoftSkill] AS [SK] ON [SK].[Id] = [S].[SoftSkillId]" +
                        "WHERE [SK].[Code] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.SoftSkill;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getSoftSkillFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        private SoftSkill getSoftSkillFromDataRow(DataRow dr)
        {
            SoftSkill res = null;

            res = new SoftSkill()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
            };

            return (res);
        }
        #endregion

        #region Technology
        public Technology GetTechnologyById(int id)
        {
            Technology res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [T].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [T].[Code]," +
                        "       [T].[Name]," +
                        "       [T].[DefaultExpertise]," +
                        "       [T].[IsVersioned] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [S].[TechnologyId]" +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.Technology;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getTechnologyFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        public Technology GetTechnologyByCode(string code)
        {
            Technology res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [T].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [T].[Code]," +
                        "       [T].[Name]," +
                        "       [T].[DefaultExpertise]," +
                        "       [T].[IsVersioned] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [S].[TechnologyId]" +
                        "WHERE [T].[Code] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.Technology;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getTechnologyFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        private Technology getTechnologyFromDataRow(DataRow dr)
        {
            Technology res = null;

            res = new Technology()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                IsVersioned = dr.Db2Bool("IsVersioned"),
            };

            return (res);
        }
        #endregion

        #region TechnologyVersion
        public TechnologyVersion GetTechnologyVersionById(int id)
        {
            TechnologyVersion res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                         "       [TV].[Id] AS [RelatedId]," +
                         "       @category AS [Category]," +
                         "       [T].[Code] + ' v' + [TV].[Version] AS [Code]," +
                         "       [T].[Name] + ' v' + [TV].[Version] AS [Name]," +
                         "       [TV].[DefaultExpertise]," +
                         "       [TV].[Version]," +
                         "       [TV].[StartDate]," +
                         "       [TV].[TechnologyId] " +
                         "FROM [dbo].[Skill] AS [S]" +
                         "INNER JOIN [dbo].[TechnologyVersion] AS [TV] ON [TV].[Id] = [S].[TechnologyVersionId]" +
                         "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [TV].[TechnologyId]" +
                         "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.TechnologyVersion;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getTechnologyVersionFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        public TechnologyVersion GetTechnologyVersionByCode(string code)
        {
            TechnologyVersion res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                         "       [TV].[Id] AS [RelatedId]," +
                         "       @category AS [Category]," +
                         "       [T].[Code] + ' v' + [TV].[Version] AS [Code]," +
                         "       [T].[Name] + ' v' + [TV].[Version] AS [Name]," +
                         "       [TV].[DefaultExpertise]," +
                         "       [TV].[Version]," +
                         "       [TV].[StartDate]," +
                         "       [TV].[TechnologyId] " +
                         "FROM [dbo].[Skill] AS [S]" +
                         "INNER JOIN [dbo].[TechnologyVersion] AS [TV] ON [TV].[Id] = [S].[TechnologyVersionId]" +
                         "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [TV].[TechnologyId]" +
                         "WHERE [T].[Code] + ' v' + [TV].[Version] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.TechnologyVersion;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getTechnologyVersionFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        private TechnologyVersion getTechnologyVersionFromDataRow(DataRow dr)
        {
            var parent = GetTechnologyById(dr.Db2Int("TechnologyId"));

            return (getTechnologyVersionFromDataRow(dr, parent));
        }

        private TechnologyVersion getTechnologyVersionFromDataRow(DataRow dr, Technology parent)
        {
            TechnologyVersion res = null;

            res = new TechnologyVersion()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                ParentTechnology = parent,
                Version = dr.Db2String("Version"),
                StartDate = dr.Db2DateTime("StartDate"),
            };

            return (res);
        }

        #endregion

        #region TechnologyRole
        public TechnologyRole GetTechnologyRoleById(int id)
        {
            TechnologyRole res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TR].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [TR].[Code]," +
                        "       [TR].[Name]," +
                        "       [TR].[DefaultExpertise]," +
                        "       [TR].[TechnologyId] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[TechnologyRole] AS [TR] ON [TR].[Id] = [S].[TechnologyRoleId]" +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.TechnologyRole;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getTechnologyRoleFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        public TechnologyRole GetTechnologyRoleByCode(string code)
        {
            TechnologyRole res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TR].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [TR].[Code]," +
                        "       [TR].[Name]," +
                        "       [TR].[DefaultExpertise]," +
                        "       [TR].[TechnologyId] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[TechnologyRole] AS [TR] ON [TR].[Id] = [S].[TechnologyRoleId]" +
                        "WHERE [TR].[Code] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.TechnologyRole;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        res = getTechnologyRoleFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }

        private TechnologyRole getTechnologyRoleFromDataRow(DataRow dr)
        {
            TechnologyRole res = null;

            var parent = GetTechnologyById(dr.Db2Int("TechnologyId"));

            res = new TechnologyRole()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                ParentTechnology = parent,
            };

            return (res);
        }
        #endregion

        #region TechnologyVersion others
        public List<TechnologyVersion> GetTechnologyVersionsByTechnologyId(int id)
        {
            var res = new List<TechnologyVersion>();

            var parent = GetTechnologyById(id);

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TV].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [T].[Code] + ' v' + [TV].[Version] AS [Code]," +
                        "       [T].[Name] + ' v' + [TV].[Version] AS [Name]," +
                        "       [TV].[DefaultExpertise]," +
                        "       [TV].[Version]," +
                        "       [TV].[StartDate] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [S].[TechnologyId]" +
                        "INNER JOIN [dbo].[TechnologyVersion] AS [TV] ON [TV].[TechnologyId] = [T].[Id]" +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.TechnologyVersion;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(getTechnologyVersionFromDataRow(dr, parent));
                    }
                }
            }

            return (res);
        }

        public List<TechnologyVersion> GetTechnologyVersionsByTechnologyCode(string code)
        {
            var res = new List<TechnologyVersion>();

            var parent = GetTechnologyByCode(code);

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TV].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [T].[Code] + ' v' + [TV].[Version] AS [Code]," +
                        "       [T].[Name] + ' v' + [TV].[Version] AS [Name]," +
                        "       [TV].[DefaultExpertise]," +
                        "       [TV].[Version]," +
                        "       [TV].[StartDate] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [S].[TechnologyId]" +
                        "INNER JOIN [dbo].[TechnologyVersion] AS [TV] ON [TV].[TechnologyId] = [T].[Id]" +
                        "WHERE [T].[Code] = @code";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                    cmd.Parameters["@code"].Value = code;

                    cmd.Parameters.Add("@category", SqlDbType.Int);
                    cmd.Parameters["@category"].Value = SkillCategory.TechnologyVersion;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(getTechnologyVersionFromDataRow(dr, parent));
                    }
                }
            }

            return (res);
        }
        #endregion

        #region SkillEstimatedExpertise
        public List<SkillEstimatedExpertise> GetSkillEstimatedExpertises()
        {
            var res = new List<SkillEstimatedExpertise>();

            var query = "SELECT [SEE].[Id], " +
                        "       [SEE].[CandidateId], " +
                        "       [SEE].[SkillId], " +
                        "       [SEE].[Expertise] " +
                        "FROM [dbo].[SkillEstimatedExpertise] AS [SEE]";

            var candidateRepository = new CandidateRepository();
            var candidates = candidateRepository.GetCandidates();
            var skills = GetSkills();

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        var candidate = candidates.FirstOrDefault(c => c.Id == dr.Db2Int("CandidateId"));
                        var skill = skills.FirstOrDefault(s => s.Id == dr.Db2Int("SkillId"));

                        res.Add(getSkillEstimatedExpertiseFromDataRow(dr, candidate, skill));
                    }
                }
            }

            return (res);
        }

        public List<SkillEstimatedExpertise> GetSkillEstimatedExpertisesBySkillIds(List<int> ids)
        {
            var all = GetSkillEstimatedExpertises();

            var res = all.Where(see => ids.Contains(see.Skill.Id));

            return (res.ToList());
        }

        private SkillEstimatedExpertise getSkillEstimatedExpertiseFromDataRow(DataRow dr, Candidate candidate, Skill skill)
        {
            SkillEstimatedExpertise res = null;

            var parent = GetTechnologyById(dr.Db2Int("TechnologyId"));

            res = new SkillEstimatedExpertise()
            {
                Id = dr.Db2Int("Id"),
                Candidate = candidate,
                Skill = skill,
                Expertise = dr.Db2Decimal("Expertise"),
            };

            return (res);
        }
        #endregion

        #region SkillRelation
        public List<SkillRelation> GetSkillRelationsBySkillId(int id)
        {
            var res = new List<SkillRelation>();

            var query = "SELECT [SR].[Id], " +
                        "       [SR].[SkillId], " +
                        "       [SR].[AssociatedSkillId]," +
                        "       [SR].[RelationType]," +
                        "       [SR].[ConversionFactor] " +
                        "FROM [dbo].[SkillRelation] AS [SR] " +
                        "WHERE [SR].[SkillId] = @skillId";

            var mainSkill = GetSkillById(id);

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillId", SqlDbType.Int);
                    cmd.Parameters["@skillId"].Value = id;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(getSkillRelationFromDataRow(dr, mainSkill));
                    }
                }
            }

            return (res);
        }

        public List<SkillRelation> GetSkillRelationsBySkillCode(string code)
        {
            var res = new List<SkillRelation>();

            var query = "SELECT [SR].[Id], " +
                        "       [SR].[SkillId], " +
                        "       [SR].[AssociatedSkillId]," +
                        "       [SR].[RelationType]," +
                        "       [SR].[ConversionFactor] " +
                        "FROM [dbo].[SkillRelation] AS [SR] " +
                        "INNER JOIN  [dbo].[GlobalSkill] AS [GS] ON [GS][.[SkillId] = [SR].[SkillId] " +
                        "WHERE [GS].[Code] = @skillCode";

            var mainSkill = GetSkillByCode(code);

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@skillCode", SqlDbType.Int);
                    cmd.Parameters["@skillCode"].Value = code;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(getSkillRelationFromDataRow(dr, mainSkill));
                    }
                }
            }

            return (res);
        }

        private SkillRelation getSkillRelationFromDataRow(DataRow dr, Skill mainSkill)
        {
            SkillRelation res = null;

            var associatedSkill = GetSkillById(dr.Db2Int("AssociatedSkillId"));

            res = new SkillRelation()
            {
                Id = dr.Db2Int("Id"),
                Skill = mainSkill,
                AssociatedSkill = associatedSkill,
                RelationType = (SkillRelationType)dr.Db2Int("RelationType"),
                ConversionFactor = dr.Db2Decimal("ConversionFactor"),
            };

            return (res);
        }
        #endregion
        #endregion

        #region Save
        #region Save BusinessArea
        public int SaveBusinessArea(BusinessArea ba)
        {
            int res;

            if (ba.Id < 0)
            {
                res = insertBusinessArea(ba);
            }
            else
            {
                res = updateBusinessArea(ba);
            }

            return (res);
        }

        private int insertBusinessArea(BusinessArea ba)
        {
            int res;

            var stmntBA = "INSERT INTO [dbo].[BusinessArea] (" +
                          " [Code]," +
                          " [Name]," +
                          " [DefaultExpertise] " +
                          ") " +
                          "VALUES (" +
                          "  @code," +
                          "  @name," +
                          "  @defaultExpertise" +
                          ")";

            var stmntSkill = "INSERT INTO [dbo].[Skill] (" +
                             "  [BusinessAreaId] " +
                             ") " +
                             "SELECT [Id] " +
                             "FROM [dbo].[BusinessArea]" +
                             "WHERE [Code] = @code";

            var stmntId = "SELECT @@IDENTITY";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmdBA = new SqlCommand(stmntBA, conn))
                    {
                        cmdBA.Transaction = trans;

                        setParamsBusinessArea(cmdBA, ba);

                        cmdBA.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = ba.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    using (var cmdId = new SqlCommand(stmntId, conn))
                    {
                        cmdId.Transaction = trans;

                        var id = cmdId.ExecuteScalar();

                        res = Convert.ToInt32(id);
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (res);
        }

        private int updateBusinessArea(BusinessArea ba)
        {
            var stmnt = "UPDATE [dbo].[BusinessArea] " +
                        "SET [Code] = @code," +
                        "    [Name] = @name," +
                        "    [DefaultExpertise] = @defaultExpertise " +
                        "WHERE [Id] = @baId";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmd = new SqlCommand(stmnt, conn))
                    {
                        cmd.Transaction = trans;

                        cmd.Parameters.Add("@baId", SqlDbType.Int);
                        cmd.Parameters["@baId"].Value = ba.RelatedId;

                        setParamsBusinessArea(cmd, ba);

                        cmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (ba.Id);
        }

        private void setParamsBusinessArea(SqlCommand cmd, BusinessArea ba)
        {
            cmd.Parameters.Add("@code", SqlDbType.NVarChar);
            cmd.Parameters["@code"].Value = ba.Code;

            cmd.Parameters.Add("@name", SqlDbType.NVarChar);
            cmd.Parameters["@name"].Value = ba.Name;

            cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
            cmd.Parameters["@defaultExpertise"].Value = ba.DefaultExpertise;
        }
        #endregion

        #region Save SoftSkill
        public int SaveSoftSkill(SoftSkill ss)
        {
            int res;

            if (ss.Id < 0)
            {
                res = insertSoftSkill(ss);
            }
            else
            {
                res = updateSoftSkill(ss);
            }

            return (res);
        }

        private int insertSoftSkill(SoftSkill ss)
        {
            int res;

            var stmntSS = "INSERT INTO [dbo].[SoftSkill] (" +
                          " [Code]," +
                          " [Name]," +
                          " [DefaultExpertise] " +
                          ") " +
                          "VALUES (" +
                          "  @code," +
                          "  @name," +
                          "  @defaultExpertise" +
                          ")";

            var stmntSkill = "INSERT INTO [dbo].[Skill] (" +
                             "  [SoftSkillId] " +
                             ") " +
                             "SELECT [Id] " +
                             "FROM [dbo].[SoftSkill]" +
                             "WHERE [Code] = @code";

            var stmntId = "SELECT @@IDENTITY";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmdSS = new SqlCommand(stmntSS, conn))
                    {
                        cmdSS.Transaction = trans;

                        setParamsSoftSkill(cmdSS, ss);

                        cmdSS.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = ss.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    using (var cmdId = new SqlCommand(stmntId, conn))
                    {
                        cmdId.Transaction = trans;

                        var id = cmdId.ExecuteScalar();

                        res = Convert.ToInt32(id);
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (res);
        }

        private int updateSoftSkill(SoftSkill ss)
        {
            var stmnt = "UPDATE [dbo].[SoftSkill] " +
                        "SET [Code] = @code," +
                        "    [Name] = @name," +
                        "    [DefaultExpertise] = @defaultExpertise " +
                        "WHERE [Id] = @ssId";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmd = new SqlCommand(stmnt, conn))
                    {
                        cmd.Transaction = trans;

                        cmd.Parameters.Add("@ssId", SqlDbType.Int);
                        cmd.Parameters["@ssId"].Value = ss.RelatedId;

                        setParamsSoftSkill(cmd, ss);

                        cmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (ss.Id);
        }


        private void setParamsSoftSkill(SqlCommand cmd, SoftSkill ss)
        {
            cmd.Parameters.Add("@code", SqlDbType.NVarChar);
            cmd.Parameters["@code"].Value = ss.Code;

            cmd.Parameters.Add("@name", SqlDbType.NVarChar);
            cmd.Parameters["@name"].Value = ss.Name;

            cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
            cmd.Parameters["@defaultExpertise"].Value = ss.DefaultExpertise;
        }
        #endregion

        #region Save Technology
        public int SaveTechnology(Technology tech)
        {
            int res;

            if (tech.Id < 0)
            {
                res = insertTechnology(tech);
            }
            else
            {
                res = updateTechnology(tech);
            }

            return (res);
        }

        private int insertTechnology(Technology tech)
        {
            int res;

            var stmntTech = "INSERT INTO [dbo].[Technology] (" +
                          " [Code]," +
                          " [Name]," +
                          " [DefaultExpertise]," +
                          " [IsVersioned] " +
                          ") " +
                          "VALUES (" +
                          "  @code," +
                          "  @name," +
                          "  @defaultExpertise," +
                          "  @isVersioned" +
                          ")";

            var stmntSkill = "INSERT INTO [dbo].[Skill] (" +
                             "  [TechnologyId] " +
                             ") " +
                             "SELECT [Id] " +
                             "FROM [dbo].[Technology]" +
                             "WHERE [Code] = @code";

            var stmntId = "SELECT @@IDENTITY";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmdSS = new SqlCommand(stmntTech, conn))
                    {
                        cmdSS.Transaction = trans;

                        setParamsTechnology(cmdSS, tech);

                        cmdSS.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = tech.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    using (var cmdId = new SqlCommand(stmntId, conn))
                    {
                        cmdId.Transaction = trans;

                        var id = cmdId.ExecuteScalar();

                        res = Convert.ToInt32(id);
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (res);
        }

        private int updateTechnology(Technology tech)
        {
            var stmnt = "UPDATE [dbo].[Technology] " +
                        "SET [Code] = @code," +
                        "    [Name] = @name," +
                        "    [DefaultExpertise] = @defaultExpertise," +
                        "    [IsVersioned] = @isVersioned " +
                        "WHERE [Id] = @techId";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmd = new SqlCommand(stmnt, conn))
                    {
                        cmd.Transaction = trans;

                        cmd.Parameters.Add("@techId", SqlDbType.Int);
                        cmd.Parameters["@techId"].Value = tech.RelatedId;

                        setParamsTechnology(cmd, tech);

                        cmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (tech.Id);
        }

        private void setParamsTechnology(SqlCommand cmd, Technology tech)
        {
            cmd.Parameters.Add("@code", SqlDbType.NVarChar);
            cmd.Parameters["@code"].Value = tech.Code;

            cmd.Parameters.Add("@name", SqlDbType.NVarChar);
            cmd.Parameters["@name"].Value = tech.Name;

            cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
            cmd.Parameters["@defaultExpertise"].Value = tech.DefaultExpertise;

            cmd.Parameters.Add("@isVersioned", SqlDbType.Bit);
            cmd.Parameters["@isVersioned"].Value = tech.IsVersioned;
        }
        #endregion

        #region Save TechnologyRole
        public int SaveTechnologyRole(TechnologyRole tr)
        {
            int res;

            if (tr.Id < 0)
            {
                res = insertTechnologyRole(tr);
            }
            else
            {
                res = updateTechnologyRole(tr);
            }

            return (res);
        }

        private int insertTechnologyRole(TechnologyRole tr)
        {
            int res;

            var stmntTR = "INSERT INTO [dbo].[TechnologyRole] (" +
                          " [TechnologyId]," +
                          " [Code]," +
                          " [Name]," +
                          " [DefaultExpertise] " +
                          ") " +
                          "VALUES (" +
                          "  @technologyId," +
                          "  @code," +
                          "  @name," +
                          "  @defaultExpertise" +
                          ")";

            var stmntSkill = "INSERT INTO [dbo].[Skill] (" +
                             "  [TechnologyRoleId] " +
                             ") " +
                             "SELECT [Id] " +
                             "FROM [dbo].[TechnologyRole]" +
                             "WHERE [Code] = @code";

            var stmntId = "SELECT @@IDENTITY";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmdTR = new SqlCommand(stmntTR, conn))
                    {
                        cmdTR.Transaction = trans;

                        cmdTR.Parameters.Add("@technologyId", SqlDbType.Int);
                        cmdTR.Parameters["@technologyId"].Value = tr.ParentTechnology.Id;

                        setParamsTechnologyRole(cmdTR, tr);

                        cmdTR.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = tr.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    using (var cmdId = new SqlCommand(stmntId, conn))
                    {
                        cmdId.Transaction = trans;

                        var id = cmdId.ExecuteScalar();

                        res = Convert.ToInt32(id);
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (res);
        }

        private int updateTechnologyRole(TechnologyRole tr)
        {
            var stmnt = "UPDATE [dbo].[TechnologyRole] " +
                        "SET [TechnologyId] = @technologyId," +
                        "    [Code] = @code," +
                        "    [Name] = @name," +
                        "    [DefaultExpertise] = @defaultExpertise " +
                        "WHERE [Id] = @ssId";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmd = new SqlCommand(stmnt, conn))
                    {
                        cmd.Transaction = trans;

                        cmd.Parameters.Add("@technologyId", SqlDbType.Int);
                        cmd.Parameters["@technologyId"].Value = tr.ParentTechnology.Id;

                        cmd.Parameters.Add("@ssId", SqlDbType.Int);
                        cmd.Parameters["@ssId"].Value = tr.RelatedId;

                        setParamsTechnologyRole(cmd, tr);

                        cmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (tr.Id);
        }

        private void setParamsTechnologyRole(SqlCommand cmd, TechnologyRole tr)
        {
            cmd.Parameters.Add("@code", SqlDbType.NVarChar);
            cmd.Parameters["@code"].Value = tr.Code;

            cmd.Parameters.Add("@name", SqlDbType.NVarChar);
            cmd.Parameters["@name"].Value = tr.Name;

            cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
            cmd.Parameters["@defaultExpertise"].Value = tr.DefaultExpertise;
        }
        #endregion
        #endregion
    }
}
