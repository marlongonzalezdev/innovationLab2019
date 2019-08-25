using System.Collections.Generic;
using System.Text;

namespace matching_learning.common.Domain.DTOs
{
    public class ProjectCandidate
    {
        public Candidate Candidate { get; set; }

        public decimal Ranking { get; set; }

        public List<ProjectCandidateSkill> SkillRankings { get; set; }

        public string SkillRankingsSummary
        {
            get
            {
                if (this.SkillRankings == null || this.SkillRankings.Count == 0) return ("");

                var skillValues = new StringBuilder();
                var isFirst = true;

                foreach (var sk in this.SkillRankings)
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
