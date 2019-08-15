using System.ComponentModel;

namespace matching_learning.common.Domain.Enums
{
    public enum SkillCategory
    {
        [Description("Technology")]
        Technology = 1,

        [Description("Technology Version")]
        TechnologyVersion,

        [Description("Technology Role")]
        TechnologyRole,

        [Description("Soft Skill")]
        SoftSkill,

        [Description("Business Area")]
        BusinessArea,
    }
}
