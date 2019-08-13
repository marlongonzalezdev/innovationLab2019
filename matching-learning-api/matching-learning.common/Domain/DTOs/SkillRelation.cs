using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.DTOs
{
    public class SkillRelation
    {
        public int Id { get; set; }

        public Skill Skill { get; set; }

        public Skill AssociatedSkill { get; set; }

        public SkillRelationType RelationType { get; set; }

        public decimal ConversionFactor { get; set; }
    }
}
