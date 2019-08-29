using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface ICandidateRepository
    {
        List<Candidate> GetCandidates();

        List<Candidate> GetCandidatesPaginated(int pageIdx, int pageSize);

        Candidate GetCandidateById(int id);

        #region Save
        int SaveCandidate(Candidate ca);
        #endregion
    }
}
