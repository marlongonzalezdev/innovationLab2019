namespace matching_learning.common.Domain.DTOs
{
    public class ProjectCandidateSkill
    {
        public Skill Skill { get; set; }

        public decimal Ranking { get; set; }

        public override string ToString()
        {
            return $"{this.Skill.Name} = {this.Ranking * 100:#.0}%";
        }
    }
}
