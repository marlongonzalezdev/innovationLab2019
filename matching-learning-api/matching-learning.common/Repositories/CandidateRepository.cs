using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Repositories
{
    public class CandidateRepository : ICandidateRepository
    {
        public List<Candidate> GetCandidates()
        {
            var res = new List<Candidate>();

            var deliveryUnitsRepository = new DeliveryUnitRepository();

            var deliveryUnits = deliveryUnitsRepository.GetDeliveryUnits();

            var candidateRolesHistory = getCandidatesRoleHistory();

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
                        var candidateId = dr.Db2Int("Id");

                        var rolesHistory = new List<CandidateRoleHistory>();

                        if (candidateRolesHistory.ContainsKey(candidateId))
                        {
                            rolesHistory = candidateRolesHistory[candidateId];
                        }

                        res.Add(new Candidate()
                        {
                            Id = candidateId,
                            DeliveryUnitId = dr.Db2Int("DeliveryUnitId"),
                            DeliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == dr.Db2Int("DeliveryUnitId")),
                            RelationType = (CandidateRelationType)dr.Db2Int("RelationType"),
                            FirstName = dr.Db2String("FirstName"),
                            LastName = dr.Db2String("LastName"),
                            DocType = (DocumentType?)dr.Db2NullableInt("DocType"),
                            DocNumber = dr.Db2String("DocNumber"),
                            EmployeeNumber = dr.Db2NullableInt("EmployeeNumber"),
                            InBench = dr.Db2Bool("InBench"),
                            RolesHistory = rolesHistory,
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

            var candidateRolesHistory = getCandidatesRoleHistoryByCandidateId(id);

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
                            RolesHistory = candidateRolesHistory,
                        };
                    }
                }
            }

            return (res);
        }

        #region Candicate Role History
        private Dictionary<int, List<CandidateRoleHistory>> getCandidatesRoleHistory()
        {
            var res = new Dictionary<int, List<CandidateRoleHistory>>();

            var candidateRoleRepository = new CandidateRoleRepository();

            var candidateRoles = candidateRoleRepository.GetCandidateRoles();

            var query = "SELECT [CCR].[Id], " +
                        "       [CCR].[CandidateId]," +
                        "       [CCR].[CandidateRoleId]," +
                        "       [CCR].[StartDate]," +
                        "       [CCR].[EndDate] " +
                        "FROM [dbo].[CandidateCandidateRole] AS [CCR]";

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
                        int candidateId = dr.Db2Int("CandidateId");

                        if (!res.ContainsKey(candidateId))
                        {
                            res.Add(candidateId, new List<CandidateRoleHistory>());
                        }

                        res[candidateId].Add(new CandidateRoleHistory()
                        {
                            Id = dr.Db2Int("Id"),
                            Role = candidateRoles.FirstOrDefault(du => du.Id == dr.Db2Int("CandidateRoleId")),
                            Start = dr.Db2DateTime("StartDate"),
                            End = dr.Db2NullableDateTime("EndDate"),
                        });
                    }
                }
            }

            return (res);
        }

        public List<CandidateRoleHistory> getCandidatesRoleHistoryByCandidateId(int candidateId)
        {
            var res = new List<CandidateRoleHistory>();

            var candidateRoleRepository = new CandidateRoleRepository();

            var candidateRoles = candidateRoleRepository.GetCandidateRoles();

            var query = "SELECT [CCR].[Id], " +
                        "       [CCR].[CandidateId]," +
                        "       [CCR].[CandidateRoleId]," +
                        "       [CCR].[StartDate]," +
                        "       [CCR].[EndDate] " +
                        "FROM [dbo].[CandidateCandidateRole] AS [CCR] " +
                        "WHERE [CCR].[CandidateId] = @candidateId";

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@candidateId", SqlDbType.Int);
                    cmd.Parameters["@candidateId"].Value = candidateId;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        res.Add(new CandidateRoleHistory()
                        {
                            Id = dr.Db2Int("Id"),
                            Role = candidateRoles.FirstOrDefault(du => du.Id == dr.Db2Int("CandidateRoleId")),
                            Start = dr.Db2DateTime("StartDate"),
                            End = dr.Db2NullableDateTime("EndDate"),
                        });
                    }
                }
            }

            return (res);
        }
        #endregion

        #region Save
        public int SaveCandidate(Candidate ca)
        {
            int res;

            if (ca.Id < 0)
            {
                res = insertCandidate(ca);
            }
            else
            {
                res = updateCandidate(ca);
            }

            return (res);
        }

        private int insertCandidate(Candidate ca)
        {
            int res;

            var stmntIns = "INSERT INTO [dbo].[Candidate] (" +
                          " [DeliveryUnitId]," +
                          " [RelationType]," +
                          " [FirstName]," +
                          " [LastName]," +
                          " [DocType]," +
                          " [DocNumber]," +
                          " [EmployeeNumber]," +
                          " [InBench] " +
                          ") " +
                          "VALUES (" +
                          "  @deliveryUnitId," +
                          "  @relationType," +
                          "  @firstName," +
                          "  @lastName," +
                          "  @docType," +
                          "  @docNumber," +
                          "  @employeeNumber," +
                          "  @inBench" +
                          ")";

            var stmntId = "SELECT @@IDENTITY";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmdIns = new SqlCommand(stmntIns, conn))
                    {
                        cmdIns.Transaction = trans;

                        cmdIns.Parameters.Add("@deliveryUnitId", SqlDbType.Int);
                        cmdIns.Parameters["@deliveryUnitId"].Value = ca.DeliveryUnitId;

                        cmdIns.Parameters.Add("@relationType", SqlDbType.Int);
                        cmdIns.Parameters["@relationType"].Value = ca.RelationType;

                        cmdIns.Parameters.Add("@firstName", SqlDbType.NVarChar);
                        cmdIns.Parameters["@firstName"].Value = ca.FirstName;

                        cmdIns.Parameters.Add("@lastName", SqlDbType.NVarChar);
                        cmdIns.Parameters["@lastName"].Value = ca.LastName;

                        cmdIns.Parameters.Add("@docType", SqlDbType.Int);
                        cmdIns.Parameters["@docType"].IsNullable = true;
                        if (ca.DocType.HasValue)
                        {
                            cmdIns.Parameters["@docType"].Value = ca.DocType.Value;
                        }
                        else
                        {
                            cmdIns.Parameters["@docType"].Value = DBNull.Value;
                        }

                        cmdIns.Parameters.Add("@docNumber", SqlDbType.NVarChar);
                        cmdIns.Parameters["@docNumber"].IsNullable = true;
                        if (!string.IsNullOrEmpty(ca.DocNumber))
                        {
                            cmdIns.Parameters["@docNumber"].Value = ca.DocNumber;
                        }
                        else
                        {
                            cmdIns.Parameters["@docNumber"].Value = DBNull.Value;
                        }

                        cmdIns.Parameters.Add("@employeeNumber", SqlDbType.Int);
                        cmdIns.Parameters["@employeeNumber"].IsNullable = true;
                        if (ca.EmployeeNumber.HasValue)
                        {
                            cmdIns.Parameters["@employeeNumber"].Value = ca.EmployeeNumber.Value;
                        }
                        else
                        {
                            cmdIns.Parameters["@employeeNumber"].Value = DBNull.Value;
                        }

                        cmdIns.Parameters.Add("@inBench", SqlDbType.Bit);
                        cmdIns.Parameters["@inBench"].Value = ca.InBench;

                        cmdIns.ExecuteNonQuery();
                    }

                    using (var cmdId = new SqlCommand(stmntId, conn))
                    {
                        cmdId.Transaction = trans;

                        var id = cmdId.ExecuteScalar();
                        
                        res = Convert.ToInt32(id);
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (res);
        }

        private int updateCandidate(Candidate ca)
        {
            var stmnt = "UPDATE [dbo].[Candidate] " +
                        "SET [DeliveryUnitId] = @deliveryUnitId," +
                        "    [RelationType] = @relationType," +
                        "    [FirstName] = @firstName," +
                        "    [LastName] = @lastName," +
                        "    [DocType] = @docType," +
                        "    [DocNumber] = @docNumber," +
                        "    [EmployeeNumber] = @employeeNumber," +
                        "    [InBench] = @inBench " +
                        "WHERE [Id] = @id";

            SqlTransaction trans;

            using (var conn = new SqlConnection(DBCommon.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmd = new SqlCommand(stmnt, conn))
                    {
                        cmd.Transaction = trans;

                        cmd.Parameters.Add("@id", SqlDbType.Int);
                        cmd.Parameters["@id"].Value = ca.Id;

                        cmd.Parameters.Add("@deliveryUnitId", SqlDbType.Int);
                        cmd.Parameters["@deliveryUnitId"].Value = ca.DeliveryUnitId;

                        cmd.Parameters.Add("@relationType", SqlDbType.Int);
                        cmd.Parameters["@relationType"].Value = ca.RelationType;

                        cmd.Parameters.Add("@firstName", SqlDbType.NVarChar);
                        cmd.Parameters["@firstName"].Value = ca.FirstName;

                        cmd.Parameters.Add("@lastName", SqlDbType.NVarChar);
                        cmd.Parameters["@lastName"].Value = ca.LastName;

                        cmd.Parameters.Add("@docType", SqlDbType.Int);
                        cmd.Parameters["@docType"].IsNullable = true;
                        if (ca.DocType.HasValue)
                        {
                            cmd.Parameters["@docType"].Value = ca.DocType.Value;
                        }
                        else
                        {
                            cmd.Parameters["@docType"].Value = DBNull.Value;
                        }

                        cmd.Parameters.Add("@docNumber", SqlDbType.NVarChar);
                        cmd.Parameters["@docNumber"].IsNullable = true;
                        if (!string.IsNullOrEmpty(ca.DocNumber))
                        {
                            cmd.Parameters["@docNumber"].Value = ca.DocNumber;
                        }
                        else
                        {
                            cmd.Parameters["@docNumber"].Value = DBNull.Value;
                        }

                        cmd.Parameters.Add("@employeeNumber", SqlDbType.Int);
                        cmd.Parameters["@employeeNumber"].IsNullable = true;
                        if (ca.EmployeeNumber.HasValue)
                        {
                            cmd.Parameters["@employeeNumber"].Value = ca.EmployeeNumber.Value;
                        }
                        else
                        {
                            cmd.Parameters["@employeeNumber"].Value = DBNull.Value;
                        }

                        cmd.Parameters.Add("@inBench", SqlDbType.Bit);
                        cmd.Parameters["@inBench"].Value = ca.InBench;

                        cmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (ca.Id);
        }
        #endregion
    }
}
