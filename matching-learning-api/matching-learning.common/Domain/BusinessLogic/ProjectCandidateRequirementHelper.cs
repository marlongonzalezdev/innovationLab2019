using System.Linq;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Domain.BusinessLogic
{
    public static class ProjectCandidateRequirementHelper
    {
        // The sum of Weight in SkillFilter list should be 1. 
        public static void Normalize(this ProjectCandidateRequirement pcr)
        {
            if ((pcr == null) || (pcr.SkillsFilter == null) || (pcr.SkillsFilter.Count == 0)) { return; }

            var totalWeight = pcr.SkillsFilter.Sum(sf => sf.Weight);

            if (totalWeight == 1M) { return; }

            foreach (var sf in pcr.SkillsFilter)
            {
                sf.Weight /= totalWeight;
            }
        }
    }
}
