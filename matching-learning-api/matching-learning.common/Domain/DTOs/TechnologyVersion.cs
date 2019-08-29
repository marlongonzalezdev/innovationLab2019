using System;

namespace matching_learning.common.Domain.DTOs
{
    public class TechnologyVersion : Skill
    {
        public int ParentTechnologyId { get; set; }

        public string Version { get; set; }

        public DateTime StartDate { get; set; }
    }
}
