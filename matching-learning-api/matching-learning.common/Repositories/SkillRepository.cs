using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.DTOs.Views;
using matching_learning.common.Domain.Enums;
using matching_learning.common.Utils;

namespace matching_learning.common.Repositories
{
    public class SkillRepository : ISkillRepository
    {
        #region Retrieve
        #region SkillView
        public List<SkillView> GetSkillViews()
        {
            var res = new List<SkillView>();

            var skills = GetSkills();

            if ((skills == null) || (skills.Count == 0)) { return (res); }

            skills = skills.Where(s => s.Category != SkillCategory.TechnologyVersion && s.Category != SkillCategory.TechnologyRole).ToList();

            foreach (var skill in skills)
            {
                res.Add(getSkillViewFromSkill(skill));
            }

            return (res);
        }

        public SkillView GetSkillViewById(int id)
        {
            SkillView res = null;

            var skill = GetSkillById(id);

            res = getSkillViewFromSkill(skill);

            return (res);
        }

        public SkillView GetSkillViewByCode(string code)
        {
            SkillView res = null;

            var skill = GetSkillByCode(code);

            res = getSkillViewFromSkill(skill);

            return (res);
        }

        private SkillView getSkillViewFromSkill(Skill skill)
        {
            SkillView res = null;

            if (skill == null) { return (null); }

            switch (skill.Category)
            {
                case SkillCategory.BusinessArea:
                    res = getFromSkill(skill);
                    break;

                case SkillCategory.SoftSkill:
                    res = getFromSkill(skill);
                    break;

                case SkillCategory.Technology:
                    res = getFromSkill(skill);

                    var tech = GetTechnologyById(skill.Id);

                    res.IsVersioned = tech.IsVersioned;
                    if (tech.IsVersioned && tech.Versions != null)
                    {
                        res.Versions = tech.Versions.Select(tv => getFromTechnologyVersion(tv, skill.RelatedId)).ToList();
                    }

                    if (tech.Roles != null)
                    {
                        res.Roles = tech.Roles.Select(tr => getFromTechnologyRole(tr, skill.RelatedId)).ToList();
                    }
                    break;

                case SkillCategory.TechnologyRole:
                case SkillCategory.TechnologyVersion:
                    throw new NotSupportedException($"Error: skill category {skill.Category} is part of technology view.");

                default:
                    throw new NotSupportedException($"Error: skill category {skill.Category} is out of range.");
            }

            return (res);
        }

        private SkillView getFromSkill(Skill s)
        {
            SkillView res;

            res = new SkillView()
            {
                Id = s.Id,
                RelatedId = s.RelatedId,
                Category = s.Category,
                Code = s.Code,
                Name = s.Name,
                DefaultExpertise = s.DefaultExpertise,
                IsVersioned = false,
                Versions = null,
                Roles = null,
            };

            return (res);
        }

        private SkillVersionView getFromTechnologyVersion(TechnologyVersion tv, int parentTechnologyId)
        {
            SkillVersionView res;

            res = new SkillVersionView()
            {
                Id = tv.Id,
                RelatedId = tv.RelatedId,
                ParentTechnologyId = parentTechnologyId,
                DefaultExpertise = tv.DefaultExpertise,
                Version = tv.Version,
                StartDate = tv.StartDate,
            };

            return (res);
        }
        private SkillRoleView getFromTechnologyRole(TechnologyRole tr, int parentTechnologyId)
        {
            SkillRoleView res;

            res = new SkillRoleView()
            {
                Id = tr.Id,
                RelatedId = tr.RelatedId,
                Code = tr.Code,
                Name = tr.Name,
                DefaultExpertise = tr.DefaultExpertise,
                ParentTechnologyId = parentTechnologyId,
            };

            return (res);
        }

        public int Id { get; set; }

        public int RelatedId { get; set; }

        public int ParentTechnologyId { get; set; }

        public decimal DefaultExpertise { get; set; }

        public string Version { get; set; }

        public DateTime StartDate { get; set; }
        #endregion

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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            if (res.IsVersioned)
            {
                res.Versions = getTechnologyVersionsByTechnologyId(res.Id);
            }

            res.Roles = getTechnologyRolesByTechnologyId(res.Id);

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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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
            TechnologyVersion res = null;

            res = new TechnologyVersion()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                ParentTechnologyId = dr.Db2Int("TechnologyId"),
                Version = dr.Db2String("Version"),
                StartDate = dr.Db2DateTime("StartDate"),
            };

            return (res);
        }

        private List<TechnologyVersion> getTechnologyVersionsByTechnologyId(int id)
        {
            var res = new List<TechnologyVersion>();

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TV].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [T].[Code] + ' v' + [TV].[Version] AS [Code]," +
                        "       [T].[Name] + ' v' + [TV].[Version] AS [Name]," +
                        "       [TV].[DefaultExpertise]," +
                        "       [TV].[TechnologyId]," +
                        "       [TV].[Version]," +
                        "       [TV].[StartDate] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [S].[TechnologyId]" +
                        "INNER JOIN [dbo].[TechnologyVersion] AS [TV] ON [TV].[TechnologyId] = [T].[Id]" +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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
                        res.Add(getTechnologyVersionFromDataRow(dr));
                    }
                }
            }

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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            res = new TechnologyRole()
            {
                Id = dr.Db2Int("SkillId"),
                RelatedId = dr.Db2Int("RelatedId"),
                Category = (SkillCategory)dr.Db2Int("Category"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
                DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                ParentTechnologyId = dr.Db2Int("TechnologyId"),
            };

            return (res);
        }

        private List<TechnologyRole> getTechnologyRolesByTechnologyId(int id)
        {
            var res = new List<TechnologyRole>();

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TR].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [TR].[Code]," +
                        "       [TR].[Name]," +
                        "       [TR].[DefaultExpertise]," +
                        "       [TR].[TechnologyId] " +
                        "FROM [dbo].[Skill] AS [S]" +
                        "INNER JOIN [dbo].[Technology] AS [T] ON [T].[Id] = [S].[TechnologyId]" +
                        "INNER JOIN [dbo].[TechnologyRole] AS [TR] ON [TR].[TechnologyId] = [T].[Id]" +
                        "WHERE [S].[Id] = @skillId";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(getTechnologyRoleFromDataRow(dr));
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
                        "FROM [dbo].[SkillEstimatedExpertise] AS [SEE]" +
                        "INNER JOIN [dbo].[candidate] AS [C] ON [C].[Id] = [SEE].[CandidateId]" +
                        "                                   AND [C].[IsActive] = 1";

            var candidateRepository = new CandidateRepository();
            var candidates = candidateRepository.GetCandidates();
            var skills = GetSkills();

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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
        #region Save SkillView
        public int SaveSkillView(SkillView sv)
        {
            int res = -1;

            switch (sv.Category)
            {
                case SkillCategory.BusinessArea:
                    var ba = new BusinessArea()
                    {
                        Id = sv.Id,
                        RelatedId = sv.RelatedId,
                        Category = sv.Category,
                        Code = sv.Code,
                        Name = sv.Name,
                        DefaultExpertise = sv.DefaultExpertise,
                    };

                    res = SaveBusinessArea(ba);
                    break;

                case SkillCategory.SoftSkill:
                    var ss = new SoftSkill()
                    {
                        Id = sv.Id,
                        RelatedId = sv.RelatedId,
                        Category = sv.Category,
                        Code = sv.Code,
                        Name = sv.Name,
                        DefaultExpertise = sv.DefaultExpertise,
                    };

                    res = SaveSoftSkill(ss);
                    break;

                case SkillCategory.Technology:
                    List<TechnologyVersion> versions = null;
                    List<TechnologyRole> roles = null;

                    if (sv.IsVersioned)
                    {
                        versions = new List<TechnologyVersion>();

                        if (sv.Versions != null && sv.Versions.Count > 0)
                        {
                            foreach (var tv in sv.Versions)
                            {
                                versions.Add(new TechnologyVersion()
                                {
                                    Id = tv.Id,
                                    RelatedId = tv.RelatedId,
                                    Category = SkillCategory.TechnologyVersion,
                                    ParentTechnologyId = tv.ParentTechnologyId,
                                    Version = tv.Version,
                                    StartDate = tv.StartDate,
                                });
                            }
                        }
                    }

                    roles = new List<TechnologyRole>();

                    if (sv.Roles != null && sv.Roles.Count > 0)
                    {
                        foreach (var tr in sv.Roles)
                        {
                            roles.Add(new TechnologyRole()
                            {
                                Id = tr.Id,
                                RelatedId = tr.RelatedId,
                                Category = SkillCategory.TechnologyRole,
                                Code = tr.Code,
                                Name = tr.Name,
                                ParentTechnologyId = tr.ParentTechnologyId,
                            });
                        }
                    }

                    var tech = new Technology()
                    {
                        Id = sv.Id,
                        RelatedId = sv.RelatedId,
                        Category = sv.Category,
                        Code = sv.Code,
                        Name = sv.Name,
                        DefaultExpertise = sv.DefaultExpertise,
                        IsVersioned = sv.IsVersioned,
                        Versions = versions,
                        Roles = roles,
                    };

                    res = SaveTechnology(tech);
                    break;

                case SkillCategory.TechnologyRole:
                    throw new NotSupportedException($"Error: skill view technology role save is not supported. Skill views technology role can be saved only as part of Technology.");

                case SkillCategory.TechnologyVersion:
                    throw new NotSupportedException($"Error: skill view technology version save is not supported. Skill views technology version can be saved only as part of Technology.");

                default:
                    throw new NotSupportedException($"Error: skill view category {sv.Category} is out of range.");
            }

            return (res);
        }
        #endregion

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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

                    using (var cmdTechId = new SqlCommand(stmntId, conn))
                    {
                        cmdTechId.Transaction = trans;

                        var techId = cmdTechId.ExecuteScalar();

                        tech.RelatedId = Convert.ToInt32(techId);
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

                        var skillId = cmdId.ExecuteScalar();

                        tech.Id = Convert.ToInt32(skillId);
                        res = tech.Id;
                    }

                    saveRelatedEntities(tech, conn, trans);

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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

                    saveRelatedEntities(tech, conn, trans);

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

        private void saveRelatedEntities(Technology tech, SqlConnection conn, SqlTransaction trans)
        {
            if (tech.IsVersioned && tech.Versions != null && tech.Versions.Count > 0)
            {
                foreach (var tv in tech.Versions)
                {
                    saveTechnologyVersion(tv, tech.RelatedId, conn, trans);
                }
            }

            if (tech.Roles != null && tech.Roles.Count > 0)
            {
                foreach (var tr in tech.Roles)
                {
                    saveTechnologyRole(tr, tech.RelatedId, conn, trans);
                }
            }
        }
        #endregion

        #region Save TechnologyVersion
        private int saveTechnologyVersion(TechnologyVersion tv, int techId, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            // Set new techId as parent.
            if (tv.ParentTechnologyId == -1) { tv.ParentTechnologyId = techId; }

            if (tv.Id < 0)
            {
                res = insertTechnologyVersion(tv, conn, trans);
            }
            else
            {
                res = updateTechnologyVersion(tv, conn, trans);
            }

            return (res);
        }

        private int insertTechnologyVersion(TechnologyVersion tv, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            var stmntTech = "INSERT INTO [dbo].[TechnologyVersion] (" +
                          " [TechnologyId]," +
                          " [DefaultExpertise]," +
                          " [Version]," +
                          " [StartDate] " +
                          ") " +
                          "VALUES (" +
                          "  @technologyId," +
                          "  @defaultExpertise," +
                          "  @version," +
                          "  @startDate" +
                          ")";

            var stmntSkill = "INSERT INTO [dbo].[Skill] (" +
                             "  [TechnologyVersionId] " +
                             ") " +
                             "SELECT [Id] " +
                             "FROM [dbo].[TechnologyVersion]" +
                             "WHERE [TechnologyId] = @technologyId" +
                             "  AND [Version] = @version";

            var stmntId = "SELECT @@IDENTITY";

            using (var cmdSS = new SqlCommand(stmntTech, conn))
            {
                cmdSS.Transaction = trans;

                setParamsTechnologyVersion(cmdSS, tv);

                cmdSS.ExecuteNonQuery();
            }

            using (var cmdSkill = new SqlCommand(stmntSkill, conn))
            {
                cmdSkill.Transaction = trans;

                cmdSkill.Parameters.Add("@technologyId", SqlDbType.Int);
                cmdSkill.Parameters["@technologyId"].Value = tv.ParentTechnologyId;

                cmdSkill.Parameters.Add("@version", SqlDbType.NVarChar);
                cmdSkill.Parameters["@version"].Value = tv.Version;

                cmdSkill.ExecuteNonQuery();
            }

            using (var cmdId = new SqlCommand(stmntId, conn))
            {
                cmdId.Transaction = trans;

                var id = cmdId.ExecuteScalar();

                res = Convert.ToInt32(id);
            }

            return (res);
        }

        private int updateTechnologyVersion(TechnologyVersion tv, SqlConnection conn, SqlTransaction trans)
        {
            var stmnt = "UPDATE [dbo].[TechnologyVersion] " +
                        "SET [TechnologyId] = @technologyId," +
                        "    [DefaultExpertise] = @defaultExpertise," +
                        "    [Version] = @version," +
                        "    [StartDate] = @startDate " +
                        "WHERE [Id] = @tvId";

            using (var cmd = new SqlCommand(stmnt, conn))
            {
                cmd.Transaction = trans;

                cmd.Parameters.Add("@tvId", SqlDbType.Int);
                cmd.Parameters["@tvId"].Value = tv.RelatedId;

                setParamsTechnologyVersion(cmd, tv);

                cmd.ExecuteNonQuery();
            }

            return (tv.Id);
        }

        private void setParamsTechnologyVersion(SqlCommand cmd, TechnologyVersion tv)
        {
            cmd.Parameters.Add("@technologyId", SqlDbType.Int);
            cmd.Parameters["@technologyId"].Value = tv.ParentTechnologyId;

            cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
            cmd.Parameters["@defaultExpertise"].Value = tv.DefaultExpertise;

            cmd.Parameters.Add("@version", SqlDbType.NVarChar);
            cmd.Parameters["@version"].Value = tv.Version;

            cmd.Parameters.Add("@startDate", SqlDbType.DateTime);
            cmd.Parameters["@startDate"].Value = tv.StartDate;
        }
        #endregion

        #region Save TechnologyRole
        private int saveTechnologyRole(TechnologyRole tr, int techId, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            // Set new techId as parent.
            if (tr.ParentTechnologyId == -1) { tr.ParentTechnologyId = techId; }

            if (tr.Id < 0)
            {
                res = insertTechnologyRole(tr, conn, trans);
            }
            else
            {
                res = updateTechnologyRole(tr, conn, trans);
            }

            return (res);
        }

        private int insertTechnologyRole(TechnologyRole tr, SqlConnection conn, SqlTransaction trans)
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


            using (var cmdTR = new SqlCommand(stmntTR, conn))
            {
                cmdTR.Transaction = trans;

                cmdTR.Parameters.Add("@technologyId", SqlDbType.Int);
                cmdTR.Parameters["@technologyId"].Value = tr.ParentTechnologyId;

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

            return (res);
        }

        private int updateTechnologyRole(TechnologyRole tr, SqlConnection conn, SqlTransaction trans)
        {
            var stmnt = "UPDATE [dbo].[TechnologyRole] " +
                        "SET [TechnologyId] = @technologyId," +
                        "    [Code] = @code," +
                        "    [Name] = @name," +
                        "    [DefaultExpertise] = @defaultExpertise " +
                        "WHERE [Id] = @ssId";


            using (var cmd = new SqlCommand(stmnt, conn))
            {
                cmd.Transaction = trans;

                cmd.Parameters.Add("@technologyId", SqlDbType.Int);
                cmd.Parameters["@technologyId"].Value = tr.ParentTechnologyId;

                cmd.Parameters.Add("@ssId", SqlDbType.Int);
                cmd.Parameters["@ssId"].Value = tr.RelatedId;

                setParamsTechnologyRole(cmd, tr);

                cmd.ExecuteNonQuery();
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
