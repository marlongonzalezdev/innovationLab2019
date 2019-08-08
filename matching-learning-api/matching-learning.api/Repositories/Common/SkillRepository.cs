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
                        "       [GS].[Name] " +
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
                        });
                    }
                }
            }

            return (res);
        }
    }
}
