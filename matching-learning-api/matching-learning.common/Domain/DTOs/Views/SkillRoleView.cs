using System;

namespace matching_learning.common.Domain.DTOs.Views
{
    public class SkillRoleView : IComparable<SkillRoleView>
    {
        public int Id { get; set; }

        public int RelatedId { get; set; }
        
        public string Code { get; set; }

        public string Name { get; set; }
        
        public decimal DefaultExpertise { get; set; }

        public int ParentTechnologyId { get; set; }
        
        public int CompareTo(SkillRoleView other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
