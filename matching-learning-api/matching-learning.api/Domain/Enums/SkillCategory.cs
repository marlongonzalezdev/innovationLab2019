using System.ComponentModel;

namespace matching_learning.api.Domain.Enums
{
    public enum SkillCategory
    {
        [Description("Technology")]
        Technology = 1,

        [Description("TechnologyVersion")]
        TechnologyVersion,

        [Description("TechnologyRole")]
        TechnologyRole,

        [Description("Soft Skill")]
        SoftSkill,

        [Description("Business Area")]
        BusinessArea,
    }
}
