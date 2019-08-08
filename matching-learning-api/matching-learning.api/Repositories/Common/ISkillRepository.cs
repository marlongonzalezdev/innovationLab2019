using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;

namespace matching_learning.api.Repositories.Common
{
    public interface ISkillRepository
    {
        List<Skill> GetSkills();

        Skill GetSkillById(int id);

        BusinessArea GetBusinessAreaById(int id);

        SoftSkill GetSoftSkillById(int id);

        Technology GetTechnologyById(int id);

        TechnologyVersion GetTechnologyVersionById(int id);

        TechnologyRole GetTechnologyRoleById(int id);

        List<TechnologyVersion> GetTechnologyVersionsByTechnologyId(int id);
    }
}
