using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Utils;

namespace matching_learning.common.Repositories
{
    public class EvaluationRepository : IEvaluationRepository
    {
        #region Retrieve
        #region Evaluation Header
        public List<Evaluation> GetEvaluations()
        {
            var res = new List<Evaluation>();

            var evaluationTypeRepository = new EvaluationTypeRepository();
            var evaluationTypes = evaluationTypeRepository.GetEvaluationTypes();
            var evaluationDetails = getEvaluationDetails();

            var query = "SELECT [E].[Id], " +
                        "       [E].[CandidateId]," +
                        "       [E].[EvaluationKey]," +
                        "       [E].[EvaluationTypeId]," +
                        "       [E].[Date]," +
                        "       [E].[Notes] " +
                        "FROM [dbo].[Evaluation] AS [E]";

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
                        var evaluationId = dr.Db2Int("Id");
                        var evaluationTypeId = dr.Db2Int("EvaluationTypeId");

                        var evaluationType = evaluationTypes.FirstOrDefault(du => du.Id == evaluationTypeId);
                        var details = evaluationDetails.Where(ed => ed.EvaluationId == evaluationId).ToList();

                        res.Add(getEvaluationFromDataRow(dr, evaluationType, details));
                    }
                }
            }

            res.Sort();

            return (res);
        }

        public Evaluation GetEvaluationById(int id)
        {
            Evaluation res = null;

            var evaluationTypeRepository = new EvaluationTypeRepository();
            var evaluationDetails = getEvaluationDetailsByEvaluationId(id);

            var query = "SELECT [E].[Id], " +
                        "       [E].[CandidateId]," +
                        "       [E].[EvaluationKey]," +
                        "       [E].[EvaluationTypeId]," +
                        "       [E].[Date]," +
                        "       [E].[Notes] " +
                        "FROM [dbo].[Evaluation] AS [E] " +
                        "WHERE [E].[Id] = @id";

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

                        var evaluationTypeId = dr.Db2Int("EvaluationTypeId");

                        var evaluationType = evaluationTypeRepository.GetEvaluationTypeById(evaluationTypeId);

                        res = getEvaluationFromDataRow(dr, evaluationType, evaluationDetails);
                    }
                }
            }

            return (res);
        }

        public List<Evaluation> GetEvaluationsByCandidateId(int candidateId)
        {
            var res = new List<Evaluation>();

            var evaluationTypeRepository = new EvaluationTypeRepository();
            var evaluationTypes = evaluationTypeRepository.GetEvaluationTypes();
            var evaluationDetails = getEvaluationDetailsByCandidateId(candidateId);

            var query = "SELECT [E].[Id], " +
                        "       [E].[CandidateId]," +
                        "       [E].[EvaluationKey]," +
                        "       [E].[EvaluationTypeId]," +
                        "       [E].[Date]," +
                        "       [E].[Notes] " +
                        "FROM [dbo].[Evaluation] AS [E] " +
                        "WHERE [E].[CandidateId] = @candidateId";

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
                        var evaluationId = dr.Db2Int("Id");
                        var evaluationTypeId = dr.Db2Int("EvaluationTypeId");

                        var evaluationType = evaluationTypes.FirstOrDefault(du => du.Id == evaluationTypeId);
                        var details = evaluationDetails.Where(ed => ed.EvaluationId == evaluationId).ToList();

                        res.Add(getEvaluationFromDataRow(dr, evaluationType, details));
                    }
                }
            }

            res.Sort();

            return (res);
        }

        private Evaluation getEvaluationFromDataRow(DataRow dr, EvaluationType evaluationType, List<EvaluationDetail> details)
        {
            var res = new Evaluation()
            {
                Id = dr.Db2Int("Id"),
                CandidateId = dr.Db2Int("CandidateId"),
                EvaluationKey = dr.Db2String("EvaluationKey"),
                EvaluationTypeId = dr.Db2Int("EvaluationTypeId"),
                EvaluationType = evaluationType,
                Date = dr.Db2DateTime("Date"),
                Notes = dr.Db2String("Notes"),
                Details = details,
            };

            return (res);
        }
        #endregion

        #region Details
        private List<EvaluationDetail> getEvaluationDetails()
        {
            var res = new List<EvaluationDetail>();

            var skillRepository = new SkillRepository();
            var skills = skillRepository.GetSkills();

            var query = "SELECT [ED].[Id], " +
                        "       [ED].[EvaluationId]," +
                        "       [ED].[SkillId]," +
                        "       [ED].[Expertise] " +
                        "FROM [dbo].[EvaluationDetail] AS [ED]";

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
                        var skillId = dr.Db2Int("SkillId");

                        var skill = skills.FirstOrDefault(du => du.Id == skillId);

                        res.Add(getEvaluationDetailFromDataRow(dr, skill));
                    }
                }
            }

            res.Sort();

            return (res);
        }

        private List<EvaluationDetail> getEvaluationDetailsByEvaluationId(int evaluationId)
        {
            var res = new List<EvaluationDetail>();

            var skillRepository = new SkillRepository();

            var query = "SELECT [ED].[Id], " +
                        "       [ED].[EvaluationId]," +
                        "       [ED].[SkillId]," +
                        "       [ED].[Expertise] " +
                        "FROM [dbo].[EvaluationDetail] AS [ED] " +
                        "WHERE [ED].[EvaluationId] = @evaluationId";

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@evaluationId", SqlDbType.Int);
                    cmd.Parameters["@evaluationId"].Value = evaluationId;

                    conn.Open();

                    var dt = new DataTable();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        var skillId = dr.Db2Int("SkillId");

                        var skill = skillRepository.GetSkillById(skillId);

                        res.Add(getEvaluationDetailFromDataRow(dr, skill));
                    }
                }
            }

            res.Sort();

            return (res);
        }

        private List<EvaluationDetail> getEvaluationDetailsByCandidateId(int candidateId)
        {
            var res = new List<EvaluationDetail>();

            var skillRepository = new SkillRepository();

            var skills = skillRepository.GetSkills();

            var query = "SELECT [ED].[Id], " +
                        "       [ED].[EvaluationId]," +
                        "       [ED].[SkillId]," +
                        "       [ED].[Expertise] " +
                        "FROM [dbo].[EvaluationDetail] AS [ED] " +
                        "INNER JOIN [dbo].[Evaluation] AS [E] ON [E].[Id] = [ED].[EvaluationId] " +
                        "WHERE [E].[CandidateId] = @candidateId";

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
                        var skillId = dr.Db2Int("SkillId");

                        var skill = skills.FirstOrDefault(du => du.Id == skillId);

                        res.Add(getEvaluationDetailFromDataRow(dr, skill));
                    }
                }
            }

            res.Sort();

            return (res);
        }

        private EvaluationDetail getEvaluationDetailFromDataRow(DataRow dr, Skill skill)
        {
            EvaluationDetail res = null;

            res = new EvaluationDetail()
            {
                Id = dr.Db2Int("Id"),
                EvaluationId = dr.Db2Int("EvaluationId"),
                SkillId = dr.Db2Int("SkillId"),
                Skill = skill,
                Expertise = dr.Db2Decimal("Expertise"),
            };

            return (res);
        }
        #endregion
        #endregion

        #region Save
        #region Evaluation Header
        public int SaveEvaluation(Evaluation ev)
        {
            int res;

            if (ev.Id < 0)
            {
                res = insertEvaluation(ev);
            }
            else
            {
                res = updateEvaluation(ev);
            }

            return (res);
        }

        public int SaveEvaluation(Evaluation ev, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            if (ev.Id < 0)
            {
                res = insertEvaluation(ev, conn, trans);
            }
            else
            {
                res = updateEvaluation(ev, conn, trans);
            }

            return (res);
        }

        private int insertEvaluation(Evaluation ev)
        {
            int res;

            SqlTransaction trans;

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    res = insertEvaluation(ev, conn, trans);

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

        private int insertEvaluation(Evaluation ev, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            var stmntIns = "INSERT INTO [dbo].[Evaluation] (" +
                           " [CandidateId]," +
                           " [EvaluationKey]," +
                           " [EvaluationTypeId]," +
                           " [Date]," +
                           " [Notes] " +
                           ") " +
                           "VALUES (" +
                           "  @candidateId," +
                           "  @evaluationKey," +
                           "  @evaluationTypeId," +
                           "  @date," +
                           "  @notes" +
                           ")";

            var stmntId = "SELECT @@IDENTITY";

            using (var cmdIns = new SqlCommand(stmntIns, conn))
            {
                cmdIns.Transaction = trans;

                setParamsEvaluation(cmdIns, ev);

                cmdIns.ExecuteNonQuery();
            }

            using (var cmdId = new SqlCommand(stmntId, conn))
            {
                cmdId.Transaction = trans;

                var id = cmdId.ExecuteScalar();

                res = Convert.ToInt32(id);
            }

            if (ev.Details != null && ev.Details.Count > 0)
            {
                foreach (var detail in ev.Details)
                {
                    detail.EvaluationId = res;
                    saveEvaluationDetail(detail, conn, trans);
                }
            }

            return (res);
        }

        private int updateEvaluation(Evaluation ev)
        {
            SqlTransaction trans;

            using (var conn = new SqlConnection(Config.GetConnectionString()))
            {
                conn.Open();
                trans = conn.BeginTransaction();

                try
                {
                    updateEvaluation(ev, conn, trans);

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return (ev.Id);
        }

        private int updateEvaluation(Evaluation ev, SqlConnection conn, SqlTransaction trans)
        {
            var stmnt = "UPDATE [dbo].[Evaluation] " +
                        "SET [CandidateId] = @candidateId," +
                        "    [EvaluationKey] = @evaluationKey," +
                        "    [EvaluationTypeId] = @evaluationTypeId," +
                        "    [Date] = @date," +
                        "    [Notes] = @notes " +
                        "WHERE [Id] = @id";

            using (var cmd = new SqlCommand(stmnt, conn))
            {
                cmd.Transaction = trans;

                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters["@id"].Value = ev.Id;

                setParamsEvaluation(cmd, ev);

                cmd.ExecuteNonQuery();
            }

            if (ev.Details != null && ev.Details.Count > 0)
            {
                foreach (var detail in ev.Details)
                {
                    detail.EvaluationId = ev.Id;
                    saveEvaluationDetail(detail, conn, trans);
                }
            }

            return (ev.Id);
        }

        private void setParamsEvaluation(SqlCommand cmd, Evaluation ev)
        {
            cmd.Parameters.Add("@candidateId", SqlDbType.Int);
            cmd.Parameters["@candidateId"].Value = ev.CandidateId;

            cmd.Parameters.Add("@evaluationKey", SqlDbType.NVarChar);
            cmd.Parameters["@evaluationKey"].IsNullable = true;
            if (!string.IsNullOrEmpty(ev.EvaluationKey))
            {
                cmd.Parameters["@evaluationKey"].Value = ev.EvaluationKey;
            }
            else
            {
                cmd.Parameters["@evaluationKey"].Value = DBNull.Value;
            }

            cmd.Parameters.Add("@evaluationTypeId", SqlDbType.Int);
            cmd.Parameters["@evaluationTypeId"].Value = ev.EvaluationTypeId;

            cmd.Parameters.Add("@date", SqlDbType.DateTime);
            cmd.Parameters["@date"].Value = ev.Date;
            
            cmd.Parameters.Add("@notes", SqlDbType.NVarChar);
            cmd.Parameters["@notes"].IsNullable = true;
            if (!string.IsNullOrEmpty(ev.Notes))
            {
                cmd.Parameters["@notes"].Value = ev.Notes;
            }
            else
            {
                cmd.Parameters["@notes"].Value = DBNull.Value;
            }
        }
        #endregion

        #region Evaluation Detail
        private int saveEvaluationDetail(EvaluationDetail ed, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            if (ed.Id < 0)
            {
                res = insertEvaluationDetail(ed, conn, trans);
            }
            else
            {
                res = updateEvaluationDetail(ed, conn, trans);
            }

            return (res);
        }
        
        private int insertEvaluationDetail(EvaluationDetail ed, SqlConnection conn, SqlTransaction trans)
        {
            int res;

            var stmntIns = "INSERT INTO [dbo].[EvaluationDetail] (" +
                           " [EvaluationId]," +
                           " [SkillId]," +
                           " [Expertise]" +
                           ") " +
                           "VALUES (" +
                           "  @evaluationId," +
                           "  @skillId," +
                           "  @expertise" +
                           ")";

            var stmntId = "SELECT @@IDENTITY";

            using (var cmdIns = new SqlCommand(stmntIns, conn))
            {
                cmdIns.Transaction = trans;

                setParamsEvaluationDetail(cmdIns, ed);

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
        
        private int updateEvaluationDetail(EvaluationDetail ed, SqlConnection conn, SqlTransaction trans)
        {
            var stmnt = "UPDATE [dbo].[EvaluationDetail] " +
                        "SET [EvaluationId] = @evaluationId," +
                        "    [SkillId] = @skillId," +
                        "    [Expertise] = @expertise " +
                        "WHERE [Id] = @id";

            using (var cmd = new SqlCommand(stmnt, conn))
            {
                cmd.Transaction = trans;

                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters["@id"].Value = ed.Id;

                setParamsEvaluationDetail(cmd, ed);

                cmd.ExecuteNonQuery();
            }

            return (ed.Id);
        }

        private void setParamsEvaluationDetail(SqlCommand cmd, EvaluationDetail ed)
        {
            cmd.Parameters.Add("@evaluationId", SqlDbType.Int);
            cmd.Parameters["@evaluationId"].Value = ed.EvaluationId;

            cmd.Parameters.Add("@skillId", SqlDbType.Int);
            cmd.Parameters["@skillId"].Value = ed.SkillId;
            
            cmd.Parameters.Add("@expertise", SqlDbType.Decimal);
            cmd.Parameters["@expertise"].Value = ed.Expertise;
        }
        #endregion
        #endregion
    }
}
