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
                        DataRow dr = dt.Rows[0];

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
                        DataRow dr = dt.Rows[0];

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

                        res.Add(new SkillEstimatedExpertise()
                        {
                            Id = dr.Db2Int("Id"),
                            Candidate = candidate,
                            Skill = skill,
                            Expertise = dr.Db2Decimal("Expertise"),
                        });
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
                        var associatedSkill = GetSkillById(dr.Db2Int("AssociatedSkillId"));

                        res.Add(new SkillRelation()
                        {
                            Id = dr.Db2Int("Id"),
                            Skill = mainSkill,
                            AssociatedSkill = associatedSkill,
                            RelationType = (SkillRelationType)dr.Db2Int("RelationType"),
                            ConversionFactor = dr.Db2Decimal("ConversionFactor"),
                        });
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
                        var associatedSkill = GetSkillById(dr.Db2Int("AssociatedSkillId"));

                        res.Add(new SkillRelation()
                        {
                            Id = dr.Db2Int("Id"),
                            Skill = mainSkill,
                            AssociatedSkill = associatedSkill,
                            RelationType = (SkillRelationType)dr.Db2Int("RelationType"),
                            ConversionFactor = dr.Db2Decimal("ConversionFactor"),
                        });
                    }
                }
            }

            return (res);
        }
        #endregion

        #region Save
        #region Save BusinessArea
        public void SaveBusinessArea(BusinessArea ba)
        {
            if (ba.Id < 0)
            {
                insertBusinessArea(ba);
            }
            else
            {
                updateBusinessArea(ba);
            }
        }

        private void insertBusinessArea(BusinessArea ba)
        {
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

                        cmdBA.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdBA.Parameters["@code"].Value = ba.Code;

                        cmdBA.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmdBA.Parameters["@name"].Value = ba.Name;

                        cmdBA.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmdBA.Parameters["@defaultExpertise"].Value = ba.DefaultExpertise;

                        cmdBA.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = ba.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        private void updateBusinessArea(BusinessArea ba)
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

                        cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmd.Parameters["@code"].Value = ba.Code;

                        cmd.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmd.Parameters["@name"].Value = ba.Name;

                        cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmd.Parameters["@defaultExpertise"].Value = ba.DefaultExpertise;

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
        }
        #endregion

        #region Save SoftSkill
        public void SaveSoftSkill(SoftSkill ss)
        {
            if (ss.Id < 0)
            {
                insertSoftSkill(ss);
            }
            else
            {
                updateSoftSkill(ss);
            }
        }

        private void insertSoftSkill(SoftSkill ss)
        {
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

                        cmdSS.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSS.Parameters["@code"].Value = ss.Code;

                        cmdSS.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmdSS.Parameters["@name"].Value = ss.Name;

                        cmdSS.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmdSS.Parameters["@defaultExpertise"].Value = ss.DefaultExpertise;

                        cmdSS.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = ss.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        private void updateSoftSkill(SoftSkill ss)
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

                        cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmd.Parameters["@code"].Value = ss.Code;

                        cmd.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmd.Parameters["@name"].Value = ss.Name;

                        cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmd.Parameters["@defaultExpertise"].Value = ss.DefaultExpertise;

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
        }
        #endregion

        #region Save Technology
        public void SaveTechnology(Technology tech)
        {
            if (tech.Id < 0)
            {
                insertTechnology(tech);
            }
            else
            {
                updateTechnology(tech);
            }
        }

        private void insertTechnology(Technology tech)
        {
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

                        cmdSS.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSS.Parameters["@code"].Value = tech.Code;

                        cmdSS.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmdSS.Parameters["@name"].Value = tech.Name;

                        cmdSS.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmdSS.Parameters["@defaultExpertise"].Value = tech.DefaultExpertise;

                        cmdSS.Parameters.Add("@isVersioned", SqlDbType.Bit);
                        cmdSS.Parameters["@isVersioned"].Value = tech.IsVersioned;

                        cmdSS.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = tech.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        private void updateTechnology(Technology tech)
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

                        cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmd.Parameters["@code"].Value = tech.Code;

                        cmd.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmd.Parameters["@name"].Value = tech.Name;

                        cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmd.Parameters["@defaultExpertise"].Value = tech.DefaultExpertise;

                        cmd.Parameters.Add("@isVersioned", SqlDbType.Bit);
                        cmd.Parameters["@isVersioned"].Value = tech.IsVersioned;

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
        }
        #endregion

        #region Save TechnologyRole
        public void SaveTechnologyRole(TechnologyRole tr)
        {
            if (tr.Id < 0)
            {
                insertTechnologyRole(tr);
            }
            else
            {
                updateTechnologyRole(tr);
            }
        }

        private void insertTechnologyRole(TechnologyRole tr)
        {
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

                        cmdTR.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdTR.Parameters["@code"].Value = tr.Code;

                        cmdTR.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmdTR.Parameters["@name"].Value = tr.Name;

                        cmdTR.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmdTR.Parameters["@defaultExpertise"].Value = tr.DefaultExpertise;

                        cmdTR.ExecuteNonQuery();
                    }

                    using (var cmdSkill = new SqlCommand(stmntSkill, conn))
                    {
                        cmdSkill.Transaction = trans;

                        cmdSkill.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmdSkill.Parameters["@code"].Value = tr.Code;

                        cmdSkill.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        private void updateTechnologyRole(TechnologyRole tr)
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

                        cmd.Parameters.Add("@code", SqlDbType.NVarChar);
                        cmd.Parameters["@code"].Value = tr.Code;

                        cmd.Parameters.Add("@name", SqlDbType.NVarChar);
                        cmd.Parameters["@name"].Value = tr.Name;

                        cmd.Parameters.Add("@defaultExpertise", SqlDbType.Decimal);
                        cmd.Parameters["@defaultExpertise"].Value = tr.DefaultExpertise;

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
        }
        #endregion
        #endregion
    }
}
