using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.Enums;
using matching_learning.common.Utils;

namespace matching_learning.common.Repositories
{
    public class CandidateRepository : ICandidateRepository
    {
        #region Retrieve
        #region Candicate
        public List<Candidate> GetCandidates()
        {
            var res = new List<Candidate>();

            var query = "SELECT [C].[Id], " +
                          "       [C].[DeliveryUnitId]," +
                          "       [C].[RelationType]," +
                          "       [C].[FirstName]," +
                          "       [C].[LastName]," +
                          "       [C].[DocType]," +
                          "       [C].[DocNumber]," +
                          "       [C].[EmployeeNumber]," +
                          "       [C].[InBench]," +
                          "       [C].[Picture]," +
                          "       [C].[IsActive] " +
                          "FROM [dbo].[Candidate] AS [C]";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    res = getCandidates(conn, cmd);
                }
            }

            return (res);
        }

        public List<Candidate> GetCandidatesPaginated(int pageIdx, int pageSize)
        {
            var res = new List<Candidate>();

            var query = "SELECT [C].[Id], " +
                        "       [C].[DeliveryUnitId]," +
                        "       [C].[RelationType]," +
                        "       [C].[FirstName]," +
                        "       [C].[LastName]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench]," +
                        "       [C].[Picture]," +
                        "       [C].[IsActive] " +
                        "FROM [dbo].[Candidate] AS [C] " +
                        "ORDER BY [C].[Id] " +
                        "OFFSET(@pageIdx * @pageSize) ROWS " +
                        "FETCH NEXT @pageSize ROWS ONLY";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    DBCommon.SetPaginationParams(pageIdx, pageSize, cmd);

                    res = getCandidates(conn, cmd);
                }
            }

            return (res);
        }

        public List<Candidate> GetCandidateByIds(List<int> ids)
        {
            var res = new List<Candidate>();

            string idsStr = DBCommon.ConvertListIntToString(ids);
            string whereCondition = $"WHERE [C].[Id] IN ({idsStr})";
            
            var query = "SELECT [C].[Id], " +
                        "       [C].[DeliveryUnitId]," +
                        "       [C].[RelationType]," +
                        "       [C].[FirstName]," +
                        "       [C].[LastName]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench]," +
                        "       [C].[Picture]," +
                        "       [C].[IsActive] " +
                        "FROM [dbo].[Candidate] AS [C] " +
                        $"{whereCondition}";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    res = getCandidates(conn, cmd);
                }
            }

            return (res);
        }

        private List<Candidate> getCandidates(SqlConnection conn, SqlCommand cmd)
        {
            var res = new List<Candidate>();

            var deliveryUnitsRepository = new DeliveryUnitRepository();
            var deliveryUnits = deliveryUnitsRepository.GetDeliveryUnits();

            var candidateEvaluations = getCandidatesEvaluations();
            var candidateRolesHistory = getCandidatesRoleHistory();

            conn.Open();

            var dt = new DataTable();
            var da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            foreach (DataRow dr in dt.Rows)
            {
                var candidateId = dr.Db2Int("Id");

                var evaluations = new List<Evaluation>();

                if (candidateEvaluations.Any(ev => ev.CandidateId == candidateId))
                {
                    evaluations = candidateEvaluations.Where(ev => ev.CandidateId == candidateId).ToList();
                }

                var rolesHistory = new List<CandidateRoleHistory>();

                if (candidateRolesHistory.ContainsKey(candidateId))
                {
                    rolesHistory = candidateRolesHistory[candidateId];
                }

                var deliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == dr.Db2Int("DeliveryUnitId"));

                res.Add(getCandidateFromDataRow(dr, deliveryUnit, evaluations, rolesHistory));
            }

            return (res);
        }

        public Candidate GetCandidateById(int id)
        {
            Candidate res = null;

            var deliveryUnitsRepository = new DeliveryUnitRepository();

            var deliveryUnits = deliveryUnitsRepository.GetDeliveryUnits();

            var evaluations = getCandidatesEvaluationsByCandidateId(id);
            var candidateRolesHistory = getCandidatesRoleHistoryByCandidateId(id);

            var query = "SELECT [C].[Id], " +
                        "       [C].[DeliveryUnitId]," +
                        "       [C].[RelationType]," +
                        "       [C].[FirstName]," +
                        "       [C].[LastName]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench]," +
                        "       [C].[Picture]," +
                        "       [C].[IsActive] " +
                        "FROM [dbo].[Candidate] AS [C] " +
                        "WHERE [C].[Id] = @id";

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
                        DataRow dr = dt.Rows[0];

                        var deliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == dr.Db2Int("DeliveryUnitId"));

                        res = getCandidateFromDataRow(dr, deliveryUnit, evaluations, candidateRolesHistory);
                    }
                }
            }

            return (res);
        }

        private Candidate getCandidateFromDataRow(DataRow dr, DeliveryUnit deliveryUnit, List<Evaluation> evaluations, List<CandidateRoleHistory> candidateRolesHistory)
        {
            Candidate res = null;

            string picturePath;
            string picturesRootFolder = Config.GetPicturesRootFolder();

            var pictureUser = dr.Db2String("Picture");

            if (string.IsNullOrEmpty(pictureUser))
            {
                string defaultPicture = Config.GetDefaultPicture();

                picturePath = picturesRootFolder + defaultPicture;
            }
            else
            {
                picturePath = picturesRootFolder + pictureUser;
            }

            res = new Candidate()
            {
                Id = dr.Db2Int("Id"),
                DeliveryUnitId = dr.Db2Int("DeliveryUnitId"),
                DeliveryUnit = deliveryUnit,
                RelationType = (CandidateRelationType)dr.Db2Int("RelationType"),
                FirstName = dr.Db2String("FirstName"),
                LastName = dr.Db2String("LastName"),
                DocType = (DocumentType?)dr.Db2NullableInt("DocType"),
                DocNumber = dr.Db2String("DocNumber"),
                EmployeeNumber = dr.Db2NullableInt("EmployeeNumber"),
                InBench = dr.Db2Bool("InBench"),
                Picture = picturePath,
                IsActive = dr.Db2Bool("IsActive"),
                Evaluations = evaluations,
                RolesHistory = candidateRolesHistory,
            };

            return (res);
        }
        #endregion

        #region Candicate Evaluations
        private List<Evaluation> getCandidatesEvaluations()
        {
            var evaluationsRepository = new EvaluationRepository();

            var res = evaluationsRepository.GetEvaluations();

            return (res);
        }

        private List<Evaluation> getCandidatesEvaluationsByCandidateId(int candidateId)
        {
            var evaluationsRepository = new EvaluationRepository();

            var res = evaluationsRepository.GetEvaluationsByCandidateId(candidateId);

            return (res);
        }
        #endregion

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
                        int candidateId = dr.Db2Int("CandidateId");

                        if (!res.ContainsKey(candidateId))
                        {
                            res.Add(candidateId, new List<CandidateRoleHistory>());
                        }

                        var candidateRole = candidateRoles.FirstOrDefault(du => du.Id == dr.Db2Int("CandidateRoleId"));

                        res[candidateId].Add(getCandidateRoleHistoryFromDataRow(dr, candidateRole));
                    }
                }
            }

            return (res);
        }

        private List<CandidateRoleHistory> getCandidatesRoleHistoryByCandidateId(int candidateId)
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

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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
                        var candidateRole = candidateRoles.FirstOrDefault(du => du.Id == dr.Db2Int("CandidateRoleId"));

                        res.Add(getCandidateRoleHistoryFromDataRow(dr, candidateRole));
                    }
                }
            }

            return (res);
        }

        private CandidateRoleHistory getCandidateRoleHistoryFromDataRow(DataRow dr, CandidateRole candidateRole)
        {
            CandidateRoleHistory res = null;

            res = new CandidateRoleHistory()
            {
                Id = dr.Db2Int("Id"),
                Role = candidateRole,
                Start = dr.Db2DateTime("StartDate"),
                End = dr.Db2NullableDateTime("EndDate"),
            };

            return (res);
        }
        #endregion
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
                          " [InBench]," +
                          " [Picture]," +
                          " [IsActive] " +
                          ") " +
                          "VALUES (" +
                          "  @deliveryUnitId," +
                          "  @relationType," +
                          "  @firstName," +
                          "  @lastName," +
                          "  @docType," +
                          "  @docNumber," +
                          "  @employeeNumber," +
                          "  @inBench," +
                          "  @picture," +
                          "  @isActive" +
                          ")";

            var stmntId = "SELECT @@IDENTITY";

            SqlTransaction trans;

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    using (var cmdIns = new SqlCommand(stmntIns, conn))
                    {
                        cmdIns.Transaction = trans;

                        setParamsCandidate(cmdIns, ca);

                        cmdIns.ExecuteNonQuery();
                    }

                    using (var cmdId = new SqlCommand(stmntId, conn))
                    {
                        cmdId.Transaction = trans;

                        var id = cmdId.ExecuteScalar();
                        ca.Id = Convert.ToInt32(id);
                        res = ca.Id;
                    }

                    SaveCandidateEvaluations(ca, conn, trans);

                    SaveCandidateRoles(ca, conn, trans);

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
                        "    [InBench] = @inBench," +
                        "    [Picture] = @picture," +
                        "    [IsActive] = @isActive " +
                        "WHERE [Id] = @id";

            SqlTransaction trans;

            using (var conn = new SqlConnection(Config.GetConnectionString()))
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

                        setParamsCandidate(cmd, ca);

                        cmd.ExecuteNonQuery();
                    }

                    SaveCandidateEvaluations(ca, conn, trans);

                    SaveCandidateRoles(ca, conn, trans);

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

        private void setParamsCandidate(SqlCommand cmd, Candidate ca)
        {
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

            cmd.Parameters.Add("@picture", SqlDbType.NVarChar);
            cmd.Parameters["@picture"].IsNullable = true;
            if (!string.IsNullOrEmpty(ca.Picture))
            {
                cmd.Parameters["@picture"].Value = ca.Picture;
            }
            else
            {
                cmd.Parameters["@picture"].Value = DBNull.Value;
            }

            cmd.Parameters.Add("@isActive", SqlDbType.Bit);
            cmd.Parameters["@isActive"].Value = ca.IsActive;
        }
        #endregion

        #region Candidate Evaluations
        public void SaveCandidateEvaluations(Candidate ca, SqlConnection conn, SqlTransaction trans)
        {
            if (ca.Evaluations != null && ca.Evaluations.Count >= 0)
            {
                var evalRepository = new EvaluationRepository();

                foreach (var eval in ca.Evaluations)
                {
                    eval.CandidateId = ca.Id;
                    evalRepository.SaveEvaluation(eval, conn, trans);
                }
            }
        }
        #endregion

        #region Candidate Roles
        public void SaveCandidateRoles(Candidate ca, SqlConnection conn, SqlTransaction trans)
        {
            if (ca.RolesHistory != null && ca.RolesHistory.Count >= 0)
            {
                foreach (var role in ca.RolesHistory)
                {
                    role.Id = saveCandidateRoleHistory(role, ca.Id, conn, trans);
                }
            }
        }
        #endregion

        #region Save
        private int saveCandidateRoleHistory(CandidateRoleHistory crh, int candidateId, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            if (crh.Id < 0)
            {
                res = insertCandidateRoleHistory(crh, candidateId, conn, trans);
            }
            else
            {
                res = updateCandidateRoleHistory(crh, candidateId, conn, trans);
            }

            return (res);
        }

        private int insertCandidateRoleHistory(CandidateRoleHistory crh, int candidateId, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            var stmntIns = "INSERT INTO [dbo].[CandidateCandidateRole] (" +
                           " [CandidateId]," +
                           " [CandidateRoleId]," +
                           " [StartDate]," +
                           " [EndDate] " +
                           ") " +
                           "VALUES (" +
                           "  @candidateId," +
                           "  @candidateRoleId," +
                           "  @startDate," +
                           "  @endDate" +
                           ")";

            var stmntId = "SELECT @@IDENTITY";

            using (var cmdIns = new SqlCommand(stmntIns, conn))
            {
                cmdIns.Transaction = trans;

                setParamsCandidateRoleHistory(cmdIns, crh, candidateId);

                cmdIns.ExecuteNonQuery();
            }

            using (var cmdId = new SqlCommand(stmntId, conn))
            {
                cmdId.Transaction = trans;

                var id = cmdId.ExecuteScalar();

                res = Convert.ToInt32(id);
            }

            return (res);
        }

        private int updateCandidateRoleHistory(CandidateRoleHistory crh, int candidateId, SqlConnection conn, SqlTransaction trans)
        {
            var stmnt = "UPDATE [dbo].[CandidateCandidateRole] " +
                        "SET [CandidateId] = @candidateId," +
                        "    [CandidateRoleId] = @candidateRoleId," +
                        "    [StartDate] = @startDate," +
                        "    [EndDate] = @endDate " +
                        "WHERE [Id] = @id";

            using (var cmd = new SqlCommand(stmnt, conn))
            {
                cmd.Transaction = trans;

                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters["@id"].Value = crh.Id;

                setParamsCandidateRoleHistory(cmd, crh, candidateId);

                cmd.ExecuteNonQuery();
            }

            return (crh.Id);
        }

        private void setParamsCandidateRoleHistory(SqlCommand cmd, CandidateRoleHistory crh, int candidateId)
        {
            cmd.Parameters.Add("@candidateId", SqlDbType.Int);
            cmd.Parameters["@candidateId"].Value = candidateId;

            cmd.Parameters.Add("@candidateRoleId", SqlDbType.Int);
            cmd.Parameters["@candidateRoleId"].Value = crh.Role.Id;

            cmd.Parameters.Add("@startDate", SqlDbType.DateTime);
            cmd.Parameters["@startDate"].Value = crh.Start;

            cmd.Parameters.Add("@endDate", SqlDbType.NVarChar);
            cmd.Parameters["@endDate"].IsNullable = true;
            if (crh.End.HasValue)
            {
                cmd.Parameters["@endDate"].Value = crh.End.Value;
            }
            else
            {
                cmd.Parameters["@endDate"].Value = DBNull.Value;
            }
        }
        #endregion
    }
}
