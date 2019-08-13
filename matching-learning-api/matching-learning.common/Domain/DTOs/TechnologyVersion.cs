using System;

namespace matching_learning.common.Domain.DTOs
{
    public class TechnologyVersion : Skill
    {
        public Technology ParentTechnology { get; set; }

        public string Version { get; set; }

        public DateTime StartDate { get; set; }
    }
}
