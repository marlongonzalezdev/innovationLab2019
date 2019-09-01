using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
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
        public List<Candidate> GetCandidates()
        {
            var res = new List<Candidate>();

            var query = "SELECT [C].[Id], " +
                          "       [C].[DeliveryUnitId]," +
                          "       [C].[RelationType]," +
                          "       [C].[FirstName]," +
                          "       [C].[LastName]," +
                          "       [C].[CandidateRoleId]," +
                          "       [C].[DocType]," +
                          "       [C].[DocNumber]," +
                          "       [C].[EmployeeNumber]," +
                          "       [C].[InBench]," +
                          "       [C].[Picture]," +
                          "       [C].[IsActive]," +
                          "       [C].[Grade]," +
                          "       [C].[CurrentProjectId]," +
                          "       [C].[CurrentProjectJoin] " +
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
                        "       [C].[CandidateRoleId]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench]," +
                        "       [C].[Picture]," +
                        "       [C].[IsActive]," +
                        "       [C].[Grade]," +
                        "       [C].[CurrentProjectId]," +
                        "       [C].[CurrentProjectJoin] " +
                        "FROM [dbo].[Candidate] AS [C] " +
                        "ORDER BY [C].[FirstName]," +
                        "         [C].[LastName]" +
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
                        "       [C].[CandidateRoleId]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench]," +
                        "       [C].[Picture]," +
                        "       [C].[IsActive]," +
                        "       [C].[Grade]," +
                        "       [C].[CurrentProjectId]," +
                        "       [C].[CurrentProjectJoin] " +
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

            var candidateRoleRepository = new CandidateRoleRepository();
            var candidateRoles = candidateRoleRepository.GetCandidateRoles();

            var projectRepository = new ProjectRepository();
            var projects = projectRepository.GetProjects();

            var candidateEvaluations = getCandidatesEvaluations();

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

                var deliveryUnit = deliveryUnits.FirstOrDefault(du => du.Id == dr.Db2Int("DeliveryUnitId"));
                var candidateRole = candidateRoles.FirstOrDefault(du => du.Id == dr.Db2Int("CandidateRoleId"));

                Project project = null;
                var projectId = dr.Db2NullableInt("CurrentProjectId");
                if (projectId.HasValue)
                {
                    project = projects.FirstOrDefault(du => du.Id == projectId.Value);
                }

                res.Add(getCandidateFromDataRow(dr, deliveryUnit, candidateRole, project, evaluations));
            }

            res.Sort();

            return (res);
        }

        public Candidate GetCandidateById(int id)
        {
            Candidate res = null;

            var deliveryUnitsRepository = new DeliveryUnitRepository();
            var deliveryUnits = deliveryUnitsRepository.GetDeliveryUnits();

            var evaluations = getCandidatesEvaluationsByCandidateId(id);

            var query = "SELECT [C].[Id], " +
                        "       [C].[DeliveryUnitId]," +
                        "       [C].[RelationType]," +
                        "       [C].[FirstName]," +
                        "       [C].[LastName]," +
                        "       [C].[CandidateRoleId]," +
                        "       [C].[DocType]," +
                        "       [C].[DocNumber]," +
                        "       [C].[EmployeeNumber]," +
                        "       [C].[InBench]," +
                        "       [C].[Picture]," +
                        "       [C].[IsActive]," +
                        "       [C].[Grade]," +
                        "       [C].[CurrentProjectId]," +
                        "       [C].[CurrentProjectJoin] " +
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

                        var candidateRoleRepository = new CandidateRoleRepository();
                        var candidateRole = candidateRoleRepository.GetCandidateRoleById(dr.Db2Int("CandidateRoleId"));

                        Project project = null;

                        var projectId = dr.Db2NullableInt("CurrentProjectId");

                        if (projectId.HasValue)
                        {
                            var projectRepository = new ProjectRepository();
                            project = projectRepository.GetProjectById(projectId.Value);
                        }

                        res = getCandidateFromDataRow(dr, deliveryUnit, candidateRole, project, evaluations);
                    }
                }
            }

            return (res);
        }

        private Candidate getCandidateFromDataRow(DataRow dr, DeliveryUnit deliveryUnit, CandidateRole candidateRole, Project currentProject, List<Evaluation> evaluations)
        {
            Candidate res = null;

            string pictureFullUrl = getPictureFromDB(dr.Db2String("Picture"));

            res = new Candidate()
            {
                Id = dr.Db2Int("Id"),
                DeliveryUnitId = dr.Db2Int("DeliveryUnitId"),
                DeliveryUnit = deliveryUnit,
                RelationType = (CandidateRelationType)dr.Db2Int("RelationType"),
                FirstName = dr.Db2String("FirstName"),
                LastName = dr.Db2String("LastName"),
                CandidateRoleId = dr.Db2Int("CandidateRoleId"),
                CandidateRole = candidateRole,
                DocType = (DocumentType?)dr.Db2NullableInt("DocType"),
                DocNumber = dr.Db2String("DocNumber"),
                EmployeeNumber = dr.Db2NullableInt("EmployeeNumber"),
                InBench = dr.Db2Bool("InBench"),
                Picture = pictureFullUrl,
                IsActive = dr.Db2Bool("IsActive"),
                Grade = (CandidateGrade?)dr.Db2NullableInt("Grade"),
                CurrentProjectId = dr.Db2NullableInt("CurrentProjectId"),
                CurrentProjectJoin = dr.Db2NullableDateTime("CurrentProjectJoin"),

                CurrentProject = currentProject,
                Evaluations = evaluations,
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
                          "  [DeliveryUnitId]," +
                          "  [RelationType]," +
                          "  [FirstName]," +
                          "  [LastName]," +
                          "  [CandidateRoleId]," +
                          "  [DocType]," +
                          "  [DocNumber]," +
                          "  [EmployeeNumber]," +
                          "  [InBench]," +
                          "  [Picture]," +
                          "  [IsActive]," +
                          "  [Grade]," +
                          "  [CurrentProjectId]," +
                          "  [CurrentProjectJoin] " +
                          ") " +
                          "VALUES (" +
                          "  @deliveryUnitId," +
                          "  @relationType," +
                          "  @firstName," +
                          "  @lastName," +
                          "  @candidateRoleId," +
                          "  @docType," +
                          "  @docNumber," +
                          "  @employeeNumber," +
                          "  @inBench," +
                          "  @picture," +
                          "  @isActive," +
                          "  @grade," +
                          "  @currentProjectId," +
                          "  @currentProjectJoin" +
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
                        "    [CandidateRoleId] = @candidateRoleId," +
                        "    [DocType] = @docType," +
                        "    [DocNumber] = @docNumber," +
                        "    [EmployeeNumber] = @employeeNumber," +
                        "    [InBench] = @inBench," +
                        "    [Picture] = @picture," +
                        "    [IsActive] = @isActive," +
                        "    [Grade] = @grade," +
                        "    [CurrentProjectId] = @currentProjectId," +
                        "    [CurrentProjectJoin] = @currentProjectJoin " +
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

            string pictureOriginal = getPictureToDB(ca.Picture);

            cmd.Parameters.Add("@deliveryUnitId", SqlDbType.Int);
            cmd.Parameters["@deliveryUnitId"].Value = ca.DeliveryUnitId;

            cmd.Parameters.Add("@relationType", SqlDbType.Int);
            cmd.Parameters["@relationType"].Value = ca.RelationType;

            cmd.Parameters.Add("@firstName", SqlDbType.NVarChar);
            cmd.Parameters["@firstName"].Value = ca.FirstName;

            cmd.Parameters.Add("@lastName", SqlDbType.NVarChar);
            cmd.Parameters["@lastName"].Value = ca.LastName;

            cmd.Parameters.Add("@candidateRoleId", SqlDbType.Int);
            cmd.Parameters["@candidateRoleId"].Value = ca.CandidateRoleId;

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
            if (!string.IsNullOrEmpty(pictureOriginal))
            {
                cmd.Parameters["@picture"].Value = pictureOriginal;
            }
            else
            {
                cmd.Parameters["@picture"].Value = DBNull.Value;
            }

            cmd.Parameters.Add("@isActive", SqlDbType.Bit);
            cmd.Parameters["@isActive"].Value = ca.IsActive;

            cmd.Parameters.Add("@grade", SqlDbType.Int);
            cmd.Parameters["@grade"].IsNullable = true;
            if (ca.Grade.HasValue)
            {
                cmd.Parameters["@grade"].Value = ca.Grade.Value;
            }
            else
            {
                cmd.Parameters["@grade"].Value = DBNull.Value;
            }

            cmd.Parameters.Add("@currentProjectId", SqlDbType.Int);
            cmd.Parameters["@currentProjectId"].IsNullable = true;
            if (ca.CurrentProjectId.HasValue)
            {
                cmd.Parameters["@currentProjectId"].Value = ca.CurrentProjectId.Value;
            }
            else
            {
                cmd.Parameters["@currentProjectId"].Value = DBNull.Value;
            }

            cmd.Parameters.Add("@currentProjectJoin", SqlDbType.DateTime);
            cmd.Parameters["@currentProjectJoin"].IsNullable = true;
            if (ca.CurrentProjectJoin.HasValue)
            {
                cmd.Parameters["@currentProjectJoin"].Value = ca.CurrentProjectJoin.Value;
            }
            else
            {
                cmd.Parameters["@currentProjectJoin"].Value = DBNull.Value;
            }
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

        #region Picture transformations
        private string getPictureFromDB(string picture)
        {
            string res;

            string picturesRootFolder = Config.GetPicturesRootFolder();

            if (string.IsNullOrEmpty(picture))
            {
                string defaultPicture = Config.GetDefaultPicture();

                res = picturesRootFolder + defaultPicture;
            }
            else
            {
                res = picturesRootFolder + picture;
            }

            return (res);
        }

        private string getPictureToDB(string picture)
        {
            string res;

            string picturesRootFolder = Config.GetPicturesRootFolder();
            string defaultPicturePath = picturesRootFolder + Config.GetDefaultPicture();

            if (!string.IsNullOrEmpty(picture)
            ) // Picture default or rootPath prefix transformations has to be reverted.
            {
                res = null;
            }
            else if (string.Compare(picture, defaultPicturePath, StringComparison.InvariantCultureIgnoreCase) == 0)
            {
                res = null;
            }
            else if (picture.StartsWith(picturesRootFolder))
            {
                res = picture.Substring(picturesRootFolder.Length);
            }
            else
            {
                res = picture;
            }

            return (res);
        }
        #endregion
    }
}
