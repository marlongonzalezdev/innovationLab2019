using System.Collections.Generic;
using matching_learning.api.Domain.Enums;

namespace matching_learning.api.Domain.DTOs
{
    public class ProjectCandidateRequirement
    {
        public List<ProjectSkillRequirement> SkillsFilter { get; set; }

        public CandidateRole RoleFilter { get; set; }

        public DeliveryUnit DeliveryUnitFilter { get; set; }

        public bool? BenchFilter { get; set; }

        public CandidateRelationType? RelationTypeFilter { get; set; }
    }
}
