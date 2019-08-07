using System.Collections.Generic;
using System.Data.SqlClient;
using matching_learning.api.Domain.DTOs;

namespace matching_learning.api.Repositories.Common
{
    public class RegionRepository : IRegionRepository
    {
        public List<Region> GetRegions()
        {
            var res = new List<Region>();

            var query = "SELECT [Id], " +
                        "       [Code]," +
                        "       [Name] " +
                        "FROM [dbo].[Region]";
            
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
                            res.Add(new Region()
                            {
                                Id = reader.GetInt32(0),
                                Code = reader.GetString(1),
                                Name = reader.GetString(2),
                            });
                        }
                    }
                }
            }

            return (res);
        }
    }
}
