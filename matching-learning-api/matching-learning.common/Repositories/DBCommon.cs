﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace matching_learning.common.Repositories
{
    public static class DBCommon
    {
        public static void SetPaginationParams(int pageIdx, int pageSize, SqlCommand cmd)
        {
            cmd.Parameters.Add("@pageIdx", SqlDbType.Int);
            cmd.Parameters["@pageIdx"].Value = pageIdx;

            cmd.Parameters.Add("@pageSize", SqlDbType.Int);
            cmd.Parameters["@pageSize"].Value = pageSize;
        }

        public static string ConvertListIntToString(List<int> input)
        {
            string res = "";

            var strInput = input.Select(i => i.ToString()).ToArray();

            res = string.Join(',', strInput);

            return (res);
        }

        #region DB conversions
        #region string conversions
        public static string Db2String(this DataRow dr, string columnName)
        {
            if (dr[columnName] == DBNull.Value)
            {
                return (null);
            }

            return ((string)dr[columnName]);
        }
#endregion

#region int conversions
        public static int Db2Int(this DataRow dr, string columnName)
        {
            return ((int)dr[columnName]);
        }

        public static int? Db2NullableInt(this DataRow dr, string columnName)
        {
            if (dr[columnName] == DBNull.Value)
            {
                return (null);
            }

            return (dr.Db2Int(columnName));
        }
#endregion

#region long conversions
        public static long Db2Long(this DataRow dr, string columnName)
        {
            return ((long)dr[columnName]);
        }

        public static long? Db2NullableLong(this DataRow dr, string columnName)
        {
            if (dr[columnName] == DBNull.Value)
            {
                return (null);
            }

            return (dr.Db2Long(columnName));
        }
#endregion

#region bool conversions
        public static bool Db2Bool(this DataRow dr, string columnName)
        {
            return ((bool)dr[columnName]);
        }

        public static bool? Db2NullableBool(this DataRow dr, string columnName)
        {
            if (dr[columnName] == DBNull.Value)
            {
                return (null);
            }

            return (dr.Db2Bool(columnName));
        }
#endregion

#region datetime conversions
        public static DateTime Db2DateTime(this DataRow dr, string columnName)
        {
            return ((DateTime)dr[columnName]);
        }

        public static DateTime? Db2NullableDateTime(this DataRow dr, string columnName)
        {
            if (dr[columnName] == DBNull.Value)
            {
                return (null);
            }

            return (dr.Db2DateTime(columnName));
        }
#endregion

#region decimal conversions
        public static decimal Db2Decimal(this DataRow dr, string columnName)
        {
            return ((decimal)dr[columnName]);
        }

        public static decimal? Db2NullableDecimal(this DataRow dr, string columnName)
        {
            if (dr[columnName] == DBNull.Value)
            {
                return (null);
            }

            return (dr.Db2Decimal(columnName));
        }
#endregion
#endregion
    }
}
