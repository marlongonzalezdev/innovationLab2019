using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Utils;

namespace matching_learning.common.Repositories
{
    public class ProjectRepository : IProjectRepository
    {
        public List<Project> GetProjects()
        {
            var res = new List<Project>();

            var query = "SELECT [Id], " +
                        "       [Code]," +
                        "       [Name] " +
                        "FROM [dbo].[Project]";

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
                        res.Add(getProjectFromDataRow(dr));
                    }
                }
            }

            return (res);
        }

        public Project GetProjectById(int id)
        {
            Project res = null;

            var query = "SELECT [P].[Id], " +
                        "       [P].[Code]," +
                        "       [P].[Name] " +
                        "FROM [dbo].[Project] AS [P] " +
                        "WHERE [P].[Id] = @id";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int);
                    cmd.Parameters["@id"].Value = id;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count == 1)
                    {
                        DataRow dr = dt.Rows[0];

                        res = getProjectFromDataRow(dr);
                    }
                }
            }

            return (res);
        }
        
        private Project getProjectFromDataRow(DataRow dr)
        {
            Project res = null;

            res = new Project()
            {
                Id = dr.Db2Int("Id"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
            };

            return (res);
        }
    }
}
