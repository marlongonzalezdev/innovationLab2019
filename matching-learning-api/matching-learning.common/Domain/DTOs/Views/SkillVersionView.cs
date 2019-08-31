using System;

namespace matching_learning.common.Domain.DTOs.Views
{
    public class SkillVersionView : IComparable<SkillVersionView>
    {
        public int Id { get; set; }

        public int RelatedId { get; set; }

        public int ParentTechnologyId { get; set; }

        public decimal DefaultExpertise { get; set; }

        public string Version { get; set; }

        public DateTime StartDate { get; set; }
        
        public int CompareTo(SkillVersionView other)
        {
            return (this.Version.CompareTo(other.Version));
        }
    }
}
