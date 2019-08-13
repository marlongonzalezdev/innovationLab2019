using System.ComponentModel;

namespace matching_learning.common.Domain.Enums
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
