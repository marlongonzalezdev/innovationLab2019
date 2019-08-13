using System.Collections.Generic;
using matching_learning.api.Domain.Enums;

namespace matching_learning.api.Domain.DTOs
{
    public class ProjectCandidateRequirement
    {
        public int Max { get; set; }

        public List<ProjectSkillRequirement> SkillsFilter { get; set; }

        public int? RoleIdFilter { get; set; }

        public int? DeliveryUnitIdFilter { get; set; }

        public bool? InBenchFilter { get; set; }

        public CandidateRelationType? RelationTypeFilter { get; set; }
    }
}
