using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public class EvaluationRepository : IEvaluationRepository
    {
        public List<Evaluation> GetEvaluations()
        {
            var res = new List<Evaluation>();

            var candidateRepository = new CandidateRepository();
            var skillRepository = new SkillRepository();
            var evaluationTypeRepository = new EvaluationTypeRepository();

            var candidates = candidateRepository.GetCandidates();
            var skills = skillRepository.GetSkills();
            var evaluationTypes = evaluationTypeRepository.GetEvaluationTypes();

            var query = "SELECT [E].[Id], " +
                        "       [E].[CandidateId]," +
                        "       [E].[SkillId]," +
                        "       [E].[EvaluationKey]," +
                        "       [E].[EvaluationTypeId]," +
                        "       [E].[Date]," +
                        "       [E].[Expertise]," +
                        "       [E].[Notes] " +
                        "FROM [dbo].[Evaluation] AS [E]";

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
                        var candidateId = dr.Db2Int("CandidateId");
                        var skillId = dr.Db2Int("SkillId");
                        var evaluationTypeId = dr.Db2Int("EvaluationTypeId");

                        res.Add(new Evaluation()
                        {
                            Id = dr.Db2Int("Id"),
                            CandidateId = candidateId,
                            Candidate = candidates.FirstOrDefault(du => du.Id == candidateId),
                            SkillId = skillId,
                            Skill = skills.FirstOrDefault(du => du.Id == skillId),
                            EvaluationKey = dr.Db2String("EvaluationKey"),
                            EvaluationTypeId = evaluationTypeId,
                            EvaluationType = evaluationTypes.FirstOrDefault(du => du.Id == evaluationTypeId),
                            Date = dr.Db2DateTime("Date"),
                            Expertise = dr.Db2Decimal("Expertise"),
                            Notes = dr.Db2String("Notes"),
                        });
                    }
                }
            }

            return (res);
        }

        public Evaluation GetEvaluationById(int id)
        {
            Evaluation res = null;

            var candidateRepository = new CandidateRepository();
            var skillRepository = new SkillRepository();
            var evaluationTypeRepository = new EvaluationTypeRepository();

          
            var query = "SELECT [E].[Id], " +
                        "       [E].[CandidateId]," +
                        "       [E].[SkillId]," +
                        "       [E].[EvaluationKey]," +
                        "       [E].[EvaluationTypeId]," +
                        "       [E].[Date]," +
                        "       [E].[Expertise]," +
                        "       [E].[Notes] " +
                        "FROM [dbo].[Evaluation] AS [E] " +
                        "WHERE [E].[Id] = @id";

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

                        var candidateId = dr.Db2Int("CandidateId");
                        var skillId = dr.Db2Int("SkillId");
                        var evaluationTypeId = dr.Db2Int("EvaluationTypeId");

                        var candidate = candidateRepository.GetCandidateById(candidateId);
                        var skill = skillRepository.GetSkillById(skillId);
                        var evaluationType = evaluationTypeRepository.GetEvaluationTypeById(evaluationTypeId);

                        res = new Evaluation()
                        {
                            Id = dr.Db2Int("Id"),
                            CandidateId = candidateId,
                            Candidate = candidate,
                            SkillId = skillId,
                            Skill = skill,
                            EvaluationKey = dr.Db2String("EvaluationKey"),
                            EvaluationTypeId = evaluationTypeId,
                            EvaluationType = evaluationType,
                            Date = dr.Db2DateTime("Date"),
                            Expertise = dr.Db2Decimal("Expertise"),
                            Notes = dr.Db2String("Notes"),
                        };
                    }
                }
            }

            return (res);
        }

        #region Save
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

        private int insertEvaluation(Evaluation ev)
        {
            int res;

            var stmntIns = "INSERT INTO [dbo].[Evaluation] (" +
                          " [CandidateId]," +
                          " [SkillId]," +
                          " [EvaluationKey]," +
                          " [EvaluationTypeId]," +
                          " [Date]," +
                          " [Expertise]," +
                          " [Notes] " +
                          ") " +
                          "VALUES (" +
                          "  @candidateId," +
                          "  @skillId," +
                          "  @evaluationKey," +
                          "  @evaluationTypeId," +
                          "  @date," +
                          "  @expertise," +
                          "  @notes" +
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

                        cmdIns.Parameters.Add("@candidateId", SqlDbType.Int);
                        cmdIns.Parameters["@candidateId"].Value = ev.CandidateId;

                        cmdIns.Parameters.Add("@skillId", SqlDbType.Int);
                        cmdIns.Parameters["@skillId"].Value = ev.SkillId;

                        cmdIns.Parameters.Add("@evaluationKey", SqlDbType.NVarChar);
                        cmdIns.Parameters["@evaluationKey"].IsNullable = true;
                        if (!string.IsNullOrEmpty(ev.EvaluationKey))
                        {
                            cmdIns.Parameters["@evaluationKey"].Value = ev.EvaluationKey;
                        }
                        else
                        {
                            cmdIns.Parameters["@evaluationKey"].Value = DBNull.Value;
                        }

                        cmdIns.Parameters.Add("@evaluationTypeId", SqlDbType.Int);
                        cmdIns.Parameters["@evaluationTypeId"].Value = ev.EvaluationTypeId;

                        cmdIns.Parameters.Add("@date", SqlDbType.DateTime);
                        cmdIns.Parameters["@date"].Value = ev.Date;

                        cmdIns.Parameters.Add("@expertise", SqlDbType.Decimal);
                        cmdIns.Parameters["@expertise"].Value = ev.Expertise;
                        
                        cmdIns.Parameters.Add("@notes", SqlDbType.NVarChar);
                        cmdIns.Parameters["@notes"].IsNullable = true;
                        if (!string.IsNullOrEmpty(ev.EvaluationKey))
                        {
                            cmdIns.Parameters["@notes"].Value = ev.Notes;
                        }
                        else
                        {
                            cmdIns.Parameters["@notes"].Value = DBNull.Value;
                        }
                        
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

        private int updateEvaluation(Evaluation ev)
        {
            var stmnt = "UPDATE [dbo].[Evaluation] " +
                        "SET [CandidateId] = @candidateId," +
                        "    [SkillId] = @skillId," +
                        "    [EvaluationKey] = @evaluationKey," +
                        "    [EvaluationTypeId] = @evaluationTypeId," +
                        "    [Date] = @date," +
                        "    [Expertise] = @expertise," +
                        "    [Notes] = @notes " +
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
                        cmd.Parameters["@id"].Value = ev.Id;

                        cmd.Parameters.Add("@candidateId", SqlDbType.Int);
                        cmd.Parameters["@candidateId"].Value = ev.CandidateId;

                        cmd.Parameters.Add("@skillId", SqlDbType.Int);
                        cmd.Parameters["@skillId"].Value = ev.SkillId;

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

                        cmd.Parameters.Add("@expertise", SqlDbType.Decimal);
                        cmd.Parameters["@expertise"].Value = ev.Expertise;

                        cmd.Parameters.Add("@notes", SqlDbType.NVarChar);
                        cmd.Parameters["@notes"].IsNullable = true;
                        if (!string.IsNullOrEmpty(ev.EvaluationKey))
                        {
                            cmd.Parameters["@notes"].Value = ev.Notes;
                        }
                        else
                        {
                            cmd.Parameters["@notes"].Value = DBNull.Value;
                        }

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

            return (ev.Id);
        }
        #endregion
    }
}
