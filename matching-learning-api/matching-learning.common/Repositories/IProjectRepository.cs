using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface IProjectRepository
    {
        List<Project> GetProjects();

        List<Project> GetProjectsPaginated(int pageIdx, int pageSize);

        Project GetProjectById(int id);
    }
}
