namespace matching_learning.common.Domain.DTOs
{
    public class ProjectCandidateSkill
    {
        public Skill Skill { get; set; }

        public decimal Expertise { get; set; }

        public override string ToString()
        {
            return $"{this.Skill.Name} = {this.Expertise * 100:#0.0}%";
        }
    }
}
