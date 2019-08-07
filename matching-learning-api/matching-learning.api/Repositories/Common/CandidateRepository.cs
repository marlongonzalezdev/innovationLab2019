using System.Collections.Generic;
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

            var query = "SELECT [Id], " +
                        "       [DeliveryUnitId]," +
                        "       [RelationType]," +
                        "       [FirstName]," +
                        "       [LastName]," +
                        "       [DocType]," +
                        "       [DocNumber]," +
                        "       [EmployeeNumber]," +
                        "       [InBench]" +
                        "FROM [dbo].[Candidate]";

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
                            res.Add(new Candidate()
                            {
                                Id = reader.GetInt32(0),
                                DeliveryUnitId = reader.GetInt32(1),
                                DeliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == reader.GetInt32(1)),
                                RelationType = (CandidateRelationType)reader.GetInt32(2),
                                FirstName = reader.GetString(3),
                                LastName = reader.GetString(4),
                                DocType = (DocumentType?)(reader.IsDBNull(5) ? (int?)null : reader.GetInt32(5)),
                                DocNumber = (reader.IsDBNull(6) ? (string)null : reader.GetString(6)),
                                EmployeeNumber = reader.GetInt32(7),
                                InBench = reader.GetBoolean(8),
                            });
                        }
                    }
                }
            }

            return (res);
        }
    }
}
