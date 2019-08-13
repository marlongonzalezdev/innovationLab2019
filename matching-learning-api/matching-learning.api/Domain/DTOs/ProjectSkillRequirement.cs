namespace matching_learning.api.Domain.DTOs
{
    public class ProjectSkillRequirement
    {
        public Skill RequiredSkill { get; set; }

        public decimal Weight { get; set; }

        public decimal? MinAccepted { get; set; }
    }
}
