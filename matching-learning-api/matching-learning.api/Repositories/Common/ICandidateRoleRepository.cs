using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;

namespace matching_learning.api.Repositories.Common
{
    public interface ICandidateRoleRepository
    {
        List<CandidateRole> GetCandidateRoles();

        CandidateRole GetCandidateRoleById(int id);
    }
}
