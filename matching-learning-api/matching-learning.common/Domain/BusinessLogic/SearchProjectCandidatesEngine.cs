using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;

namespace matching_learning.common.Domain.BusinessLogic
{
    public class SearchProjectCandidatesEngine
    {
        public static List<ProjectCandidate> GetProjectCandidates(ProjectCandidateRequirement pcr, ISkillRepository skillRepository)
        {
            pcr.Normalize();

            var estimated = skillRepository.GetSkillEstimatedExpertisesForProject(pcr);

            var filteredCandidates = estimated.Select(e => e.Candidate).Distinct().ToList();

            var res = filteredCandidates.Select(fc => new ProjectCandidate()
            {
                Candidate = fc,
                Ranking = getRanking(pcr.SkillsFilter, getCandidateSkillEstimatedExpertise(fc, estimated)),
                SkillRankings = getSkillRankings(pcr.SkillsFilter, getCandidateSkillEstimatedExpertise(fc, estimated)),
            }).Where(pc => pc.Ranking > 0).OrderByDescending(pc => pc.Ranking).Take(pcr.Max).ToList();

            return (res);
        }

        private static decimal getRanking(List<ProjectSkillRequirement> skillsFilter, List<SkillEstimatedExpertise> candidateExpertise)
        {
            decimal res = 0;

            foreach (var sf in skillsFilter)
            {
                var ce = candidateExpertise.FirstOrDefault(cexp => cexp.Skill.Id == sf.RequiredSkillId);

                if (sf.MinAccepted.HasValue && (ce == null || ce.Expertise < sf.MinAccepted.Value))
                {
                    return (-1);
                }

                if (ce != null)
                {
                    res += sf.Weight * ce.Expertise;
                }
            }

            return (res);
        }

        private static List<ProjectCandidateSkill> getSkillRankings(List<ProjectSkillRequirement> skillsFilter, List<SkillEstimatedExpertise> candidateExpertise)
        {
            var res = new List<ProjectCandidateSkill>();

            foreach (var sf in skillsFilter)
            {
                var ce = candidateExpertise.FirstOrDefault(cexp => cexp.Skill.Id == sf.RequiredSkillId);

                if (ce != null)
                {
                    res.Add(new ProjectCandidateSkill()
                    {
                        Skill = ce.Skill,
                        Ranking = ce.Expertise,
                    });
                }
            }

            return (res);
        }

        private static List<SkillEstimatedExpertise> getCandidateSkillEstimatedExpertise(Candidate candidate, List<SkillEstimatedExpertise> candidatesExpertise)
        {
            return (candidatesExpertise.Where(ce => ce.Candidate.Id == candidate.Id).ToList());
        }
    }
}
