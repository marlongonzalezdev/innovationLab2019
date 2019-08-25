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

            List<int> reqSkills = pcr.SkillsFilter.Select(sf => sf.RequiredSkillId).Distinct().ToList();

            var estimated = skillRepository.GetSkillEstimatedExpertisesBySkillIds(reqSkills);

            if (pcr.InBenchFilter.HasValue && pcr.InBenchFilter.Value)
            {
                estimated = estimated.Where(e => e.Candidate.InBench == pcr.InBenchFilter.Value).ToList();
            }

            if (pcr.DeliveryUnitIdFilter.HasValue)
            {
                estimated = estimated.Where(e => e.Candidate.DeliveryUnitId == pcr.DeliveryUnitIdFilter.Value).ToList();
            }

            if (pcr.RoleIdFilter.HasValue)
            {
                estimated = estimated.Where(e => e.Candidate.ActiveRole != null && e.Candidate.ActiveRole.Id == pcr.RoleIdFilter.Value).ToList();
            }

            if (pcr.RelationTypeFilter != null)
            {
                estimated = estimated.Where(e => e.Candidate.RelationType == pcr.RelationTypeFilter.Value).ToList();
            }

            var filteredCandidates = estimated.Select(e => e.Candidate).Distinct().ToList();

            var res = filteredCandidates.Select(fc => new ProjectCandidate()
            {
                Candidate = fc,
                Ranking = getRanking(pcr.SkillsFilter, getCandidateSkillEstimatedExpertise(fc, estimated)),
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

        private static List<SkillEstimatedExpertise> getCandidateSkillEstimatedExpertise(Candidate candidate, List<SkillEstimatedExpertise> candidatesExpertise)
        {
            return (candidatesExpertise.Where(ce => ce.Candidate.Id == candidate.Id).ToList());
        }
    }
}
