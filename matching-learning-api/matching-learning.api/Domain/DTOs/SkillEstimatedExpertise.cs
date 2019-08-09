namespace matching_learning.api.Domain.DTOs
{
    public class SkillEstimatedExpertise
    {
        public int Id { get; set; }
        public Candidate Candidate { get; set; }
        public Skill Skill { get; set; }
        public decimal Expertise { get; set; }
    }
}
