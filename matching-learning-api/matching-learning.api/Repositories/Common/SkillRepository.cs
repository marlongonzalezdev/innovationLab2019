using System.Collections.Generic;
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
                        "       [BA].[Code]," +
                        "       [BA].[Name]" +
                        "FROM [dbo].[GlobalSkill] AS [GS]";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            res.Add(new Skill()
                            {
                                Id = reader.GetInt32(0),
                                Category = (SkillCategory)reader.GetInt32(2),
                                Code = reader.GetString(3),
                                Name = reader.GetString(4),
                            });
                        }
                    }
                }
            }

            return (res);
        }
    }
}
