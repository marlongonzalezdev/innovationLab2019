using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.api.Domain.DTOs;

namespace matching_learning.api.Repositories.Common
{
    public class DeliveryUnitRepository : IDeliveryUnitRepository
    {
        public List<DeliveryUnit> GetDeliveryUnits()
        {
            var res = new List<DeliveryUnit>();

            var regionRepository = new RegionRepository();

            var regions = regionRepository.GetRegions();

            var query = "SELECT [Id], " +
                        "       [Code]," +
                        "       [Name]," +
                        "       [RegionId]" +
                        "FROM [dbo].[DeliveryUnit]";

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
                            res.Add(new DeliveryUnit()
                            {
                                Id = reader.GetInt32(0),
                                Code = reader.GetString(1),
                                Name = reader.GetString(2),
                                RegionId = reader.GetInt32(3),
                                Region = regions.FirstOrDefault(r => r.Id == reader.GetInt32(3)),
                            });
                        }
                    }
                }
            }

            return (res);
        }
    }
}
