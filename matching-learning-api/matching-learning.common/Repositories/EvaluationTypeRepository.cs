using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public class EvaluationTypeRepository : IEvaluationTypeRepository
    {
        public List<EvaluationType> GetEvaluationTypes()
        {
            var res = new List<EvaluationType>();

            var query = "SELECT [ET].[Id], " +
                        "       [ET].[Name]," +
                        "       [ET].[Priority] " +
                        "FROM [dbo].[EvaluationType] AS [ET]";

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
                        res.Add(new EvaluationType()
                        {
                            Id = dr.Db2Int("Id"),
                            Name = dr.Db2String("Name"),
                            Priority = dr.Db2Decimal("Priority"),
                        });
                    }
                }
            }

            return (res);
        }

        public EvaluationType GetEvaluationTypeById(int id)
        {
            EvaluationType res = null;
            
            var query = "SELECT [ET].[Id], " +
                        "       [ET].[Name]," +
                        "       [ET].[Priority] " +
                        "FROM [dbo].[EvaluationType] AS [ET] " +
                        "WHERE [ET].[Id] = @id";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
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

                        res = new EvaluationType()
                        {
                            Id = dr.Db2Int("Id"),
                            Name = dr.Db2String("Name"),
                            Priority = dr.Db2Decimal("Priority"),
                        };
                    }
                }
            }

            return (res);
        }
    }
}
