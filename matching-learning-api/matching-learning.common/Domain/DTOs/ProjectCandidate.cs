using System.Collections.Generic;
using System.Text;

namespace matching_learning.common.Domain.DTOs
{
    public class ProjectCandidate
    {
        public Candidate Candidate { get; set; }

        public decimal Ranking { get; set; }

        public List<ProjectCandidateSkill> SkillExpertises { get; set; }

        public string SkillExpertisesSummary
        {
            get
            {
                if (this.SkillExpertises == null || this.SkillExpertises.Count == 0) return ("");

                var skillValues = new StringBuilder();
                var isFirst = true;

                foreach (var sk in this.SkillExpertises)
                {
                    if (isFirst)
                    {
                        skillValues.Append($"{sk}");
                        isFirst = false;
                    }
                    else
                    {
                        skillValues.Append($", {sk}");
                    }
                }

                return (skillValues.ToString());
            }
        }
    }
}
