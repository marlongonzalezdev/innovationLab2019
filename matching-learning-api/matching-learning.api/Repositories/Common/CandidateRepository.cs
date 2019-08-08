using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Domain.Enums;

namespace matching_learning.api.Repositories.Common
{
    public class CandidateRepository : ICandidateRepository
    {
        public List<Candidate> GetCandidates()
        {
            var res = new List<Candidate>();

            var deliveryUnitsRepository = new DeliveryUnitRepository();

            var deliveryUnits = deliveryUnitsRepository.GetDeliveryUnits();

            var query = "SELECT [C].[Id], " +
                        "       [C].[DeliveryUnitId]," +
                        "       [C].[RelationType]," +
                        "       [C].[FirstName]," +
                        "       [C].[LastName]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench] " +
                        "FROM [dbo].[Candidate] AS [C]";

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
                        res.Add(new Candidate()
                        {
                            Id = dr.Db2Int("Id"),
                            DeliveryUnitId = dr.Db2Int("DeliveryUnitId"),
                            DeliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == dr.Db2Int("DeliveryUnitId")),
                            RelationType = (CandidateRelationType)dr.Db2Int("RelationType"),
                            FirstName = dr.Db2String("FirstName"),
                            LastName = dr.Db2String("LastName"),
                            DocType = (DocumentType?)dr.Db2NullableInt("DocType"),
                            DocNumber = dr.Db2String("DocNumber"),
                            EmployeeNumber = dr.Db2NullableInt("EmployeeNumber"),
                            InBench = dr.Db2Bool("InBench"),
                        });
                    }
                }
            }

            return (res);
        }

        public Candidate GetCandidateById(int id)
        {
            Candidate res = null;

            var deliveryUnitsRepository = new DeliveryUnitRepository();

            var deliveryUnits = deliveryUnitsRepository.GetDeliveryUnits();

            var query = "SELECT [C].[Id], " +
                        "       [C].[DeliveryUnitId]," +
                        "       [C].[RelationType]," +
                        "       [C].[FirstName]," +
                        "       [C].[LastName]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench] " +
                        "FROM [dbo].[Candidate] AS [C] " +
                        "WHERE [C].[Id] = @id";

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

                        res = new Candidate()
                        {
                            Id = dr.Db2Int("Id"),
                            DeliveryUnitId = dr.Db2Int("DeliveryUnitId"),
                            DeliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == dr.Db2Int("DeliveryUnitId")),
                            RelationType = (CandidateRelationType)dr.Db2Int("RelationType"),
                            FirstName = dr.Db2String("FirstName"),
                            LastName = dr.Db2String("LastName"),
                            DocType = (DocumentType?)dr.Db2NullableInt("DocType"),
                            DocNumber = dr.Db2String("DocNumber"),
                            EmployeeNumber = dr.Db2NullableInt("EmployeeNumber"),
                            InBench = dr.Db2Bool("InBench"),
                        };
                    }
                }
            }

            return (res);
        }
    }
}
