﻿using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Utils;

namespace matching_learning.common.Repositories
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
                        res.Add(getRegionFromDataRow(dr));
                    }
                }
            }

            res.Sort();

            return (res);
        }
        
        private Region getRegionFromDataRow(DataRow dr)
        {
            Region res = null;

            res = new Region()
            {
                Id = dr.Db2Int("Id"),
                Code = dr.Db2String("Code"),
                Name = dr.Db2String("Name"),
            };

            return (res);
        }
    }
}
