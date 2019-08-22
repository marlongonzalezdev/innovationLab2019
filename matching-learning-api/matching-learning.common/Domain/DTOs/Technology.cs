using System.Collections.Generic;

namespace matching_learning.common.Domain.DTOs
{
    public class Technology : Skill
    {
        public bool IsVersioned { get; set; }

        public List<TechnologyVersion> Versions { get; set; }
    }
}
