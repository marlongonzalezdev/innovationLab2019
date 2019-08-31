using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface IProjectRepository
    {
        List<Project> GetProjects();

        Project GetProjectById(int id);
    }
}
