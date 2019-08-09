using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Domain.Enums;

namespace matching_learning.api.Repositories.Common
{
    public class SkillRepository : ISkillRepository
    {
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
                        res.Add(new Skill()
                        {
                            Id = dr.Db2Int("SkillId"),
                            RelatedId = dr.Db2Int("RelatedId"),
                            Category = (SkillCategory)dr.Db2Int("Category"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                        });
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
                        DataRow dr = dt.Rows[0];

                        res = new Skill()
                        {
                            Id = dr.Db2Int("SkillId"),
                            RelatedId = dr.Db2Int("RelatedId"),
                            Category = (SkillCategory)dr.Db2Int("Category"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                        };
                    }
                }
            }

            return (res);
        }

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
                        DataRow dr = dt.Rows[0];

                        res = new BusinessArea()
                        {
                            Id = dr.Db2Int("SkillId"),
                            RelatedId = dr.Db2Int("RelatedId"),
                            Category = (SkillCategory)dr.Db2Int("Category"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                        };
                    }
                }
            }

            return (res);
        }

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
                        DataRow dr = dt.Rows[0];

                        res = new SoftSkill()
                        {
                            Id = dr.Db2Int("SkillId"),
                            RelatedId = dr.Db2Int("RelatedId"),
                            Category = (SkillCategory)dr.Db2Int("Category"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                        };
                    }
                }
            }

            return (res);
        }

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
                        DataRow dr = dt.Rows[0];

                        res = new Technology()
                        {
                            Id = dr.Db2Int("SkillId"),
                            RelatedId = dr.Db2Int("RelatedId"),
                            Category = (SkillCategory)dr.Db2Int("Category"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                            IsVersioned = dr.Db2Bool("IsVersioned")
                        };
                    }
                }
            }

            return (res);
        }

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
                        DataRow dr = dt.Rows[0];

                        var parent = GetTechnologyById(dr.Db2Int("TechnologyId"));

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
                    }
                }
            }

            return (res);
        }

        public TechnologyRole GetTechnologyRoleById(int id)
        {
            TechnologyRole res = null;

            var query = "SELECT [S].[Id] AS [SkillId], " +
                        "       [TR].[Id] AS [RelatedId]," +
                        "       @category AS [Category]," +
                        "       [TR].[Code]," +
                        "       [TR].[Name]," +
                        "       [TR].[DefaultExpertise] " +
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
                        DataRow dr = dt.Rows[0];

                        res = new TechnologyRole()
                        {
                            Id = dr.Db2Int("SkillId"),
                            RelatedId = dr.Db2Int("RelatedId"),
                            Category = (SkillCategory)dr.Db2Int("Category"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            DefaultExpertise = dr.Db2Decimal("DefaultExpertise"),
                        };
                    }
                }
            }

            return (res);
        }

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
                        res.Add(new TechnologyVersion()
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
                        });
                    }
                }
            }

            return (res);
        }
    }
}
