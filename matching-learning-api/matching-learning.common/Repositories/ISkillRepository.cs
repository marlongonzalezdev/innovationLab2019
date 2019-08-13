using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface ISkillRepository
    {
        #region Retrieve
        List<Skill> GetSkills();

        Skill GetSkillById(int id);
        Skill GetSkillByCode(string code);

        BusinessArea GetBusinessAreaById(int id);
        BusinessArea GetBusinessAreaByCode(string code);

        SoftSkill GetSoftSkillById(int id);
        SoftSkill GetSoftSkillByCode(string code);

        Technology GetTechnologyById(int id);
        Technology GetTechnologyByCode(string code);

        TechnologyVersion GetTechnologyVersionById(int id);
        TechnologyVersion GetTechnologyVersionByCode(string code);

        TechnologyRole GetTechnologyRoleById(int id);
        TechnologyRole GetTechnologyRoleByCode(string code);

        List<TechnologyVersion> GetTechnologyVersionsByTechnologyId(int id);
        List<TechnologyVersion> GetTechnologyVersionsByTechnologyCode(string code);

        List<SkillEstimatedExpertise> GetSkillEstimatedExpertises();
        List<SkillEstimatedExpertise> GetSkillEstimatedExpertisesBySkillIds(List<int> ids);

        List<SkillRelation> GetSkillRelationsBySkillId(int id);
        List<SkillRelation> GetSkillRelationsBySkillCode(string code);
        #endregion

        #region Save
        void SaveBusinessArea(BusinessArea ba);

        void SaveSoftSkill(SoftSkill ss);

        void SaveTechnology(Technology tech);

        void SaveTechnologyRole(TechnologyRole tr);
        #endregion
    }
}
