using System.Collections.Generic;

namespace matching_learning.common.Domain.DTOs
{
    public class Technology : Skill
    {
        public bool IsVersioned { get; set; }

        public List<TechnologyVersion> Versions { get; set; }

        public List<TechnologyRole> Roles { get; set; }
    }
}
