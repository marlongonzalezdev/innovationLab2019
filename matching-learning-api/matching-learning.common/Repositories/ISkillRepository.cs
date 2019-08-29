using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.DTOs.Views;

namespace matching_learning.common.Repositories
{
    public interface ISkillRepository
    {
        #region Retrieve
        #region SkillView
        List<SkillView> GetSkillViews();

        SkillView GetSkillViewById(int id);
        SkillView GetSkillViewByCode(string code);
        #endregion

        #region Skill
        List<Skill> GetSkills();

        Skill GetSkillById(int id);
        Skill GetSkillByCode(string code);
        #endregion

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

        List<SkillEstimatedExpertise> GetSkillEstimatedExpertises();
        List<SkillEstimatedExpertise> GetSkillEstimatedExpertisesForProject(ProjectCandidateRequirement pcr);
        List<SkillEstimatedExpertise> GetSkillEstimatedExpertisesBySkillIds(List<int> ids);

        List<SkillRelation> GetSkillRelationsBySkillId(int id);
        List<SkillRelation> GetSkillRelationsBySkillCode(string code);
        #endregion

        #region Save
        int SaveSkillView(SkillView sv);

        int SaveBusinessArea(BusinessArea ba);

        int SaveSoftSkill(SoftSkill ss);

        int SaveTechnology(Technology tech);
        #endregion
    }
}
