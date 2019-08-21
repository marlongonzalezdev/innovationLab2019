using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface IEvaluationTypeRepository
    {
        List<EvaluationType> GetEvaluationTypes();

        EvaluationType GetEvaluationTypeById(int id);
    }
}
