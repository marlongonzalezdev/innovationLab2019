using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;

namespace matching_learning.api.Repositories.Common
{
    public interface ICandidateRepository
    {
        List<Candidate> GetCandidates();

        Candidate GetCandidateById(int id);
    }
}
