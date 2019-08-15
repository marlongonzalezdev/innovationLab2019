namespace matching_learning.common.Domain.DTOs
{
    public class ProjectSkillRequirement
    {
        public int RequiredSkillId { get; set; }

        public decimal Weight { get; set; }

        public decimal? MinAccepted { get; set; }
    }
}
