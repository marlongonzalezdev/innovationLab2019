using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Utils;

namespace matching_learning.common.Repositories
{
    public class CandidateRoleRepository : ICandidateRoleRepository
    {
        #region Retrieve
        public List<CandidateRole> GetCandidateRoles()
        {
            var res = new List<CandidateRole>();
            
            var query = "SELECT [CR].[Id], " +
                        "       [CR].[Code]," +
                        "       [CR].[Name] " +
                        "FROM [dbo].[CandidateRole] AS [CR]";

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
                        res.Add(getCandidateRoleFromDataRow(dr));
                    }
                }
            }

            return (res);
        }

        public CandidateRole GetCandidateRoleById(int id)
        {
            CandidateRole res = null;

            var query = "SELECT [CR].[Id], " +
                        "       [CR].[Code]," +
                        "       [CR].[Name] " +
                        "FROM [dbo].[CandidateRole] AS [CR] " +
                        "WHERE [CR].[Id] = @id";

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
                        res = getCandidateRoleFromDataRow(dt.Rows[0]);
                    }
                }
            }

            return (res);
        }
        
        private CandidateRole getCandidateRoleFromDataRow(DataRow dr)
        {
            CandidateRole res = null;

            res = new CandidateRole()
            {
                Id = dr.Db2Int("Id"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
            };

            return (res);
        }
        #endregion
    }
}
