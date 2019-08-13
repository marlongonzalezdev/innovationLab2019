using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
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
                        "       [RegionId] " +
                        "FROM [dbo].[DeliveryUnit]";

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
                        res.Add(new DeliveryUnit()
                        {
                            Id = dr.Db2Int("Id"),
                            Code = dr.Db2String("Code"),
                            Name = dr.Db2String("Name"),
                            RegionId = dr.Db2Int("RegionId"),
                            Region = regions.FirstOrDefault(r => r.Id == dr.Db2Int("RegionId")),
                        });
                    }
                }
            }

            return (res);
        }
    }
}
