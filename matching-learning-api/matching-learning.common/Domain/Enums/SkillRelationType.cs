using System.ComponentModel;

namespace matching_learning.common.Domain.Enums
{
    public enum SkillRelationType
    {
        [Description("Parent/Child")]
        ParentChild = 1,

        [Description("Version")]
        Version,

        [Description("Similar")]
        Similar,
    }
}
