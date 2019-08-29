using System;
using System.Collections.Generic;
using matching_learning.common.Domain.BusinessLogic;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.DTOs.Views
{
    public class SkillView : IComparable<SkillView>
    {
        public int Id { get; set; }

        public int RelatedId { get; set; }

        public SkillCategory Category { get; set; }

        public string CategoryDescription { get { return EnumHelper.GetEnumDescription(this.Category); } }

        public string Code { get; set; }

        public string Name { get; set; }

        public decimal DefaultExpertise { get; set; }

        public bool IsVersioned { get; set; } // Only for Technology

        public List<SkillVersionView> Versions { get; set; }  // Only for Technology

        public List<SkillRoleView> Roles { get; set; }  // Only for Technology

        public int CompareTo(SkillView other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
