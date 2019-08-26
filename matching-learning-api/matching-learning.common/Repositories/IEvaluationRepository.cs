using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface IEvaluationRepository
    {
        List<Evaluation> GetEvaluations();

        Evaluation GetEvaluationById(int id);

        List<Evaluation> GetEvaluationsByCandidateId(int candidateId);

        int SaveEvaluation(Evaluation ev);
    }
}
