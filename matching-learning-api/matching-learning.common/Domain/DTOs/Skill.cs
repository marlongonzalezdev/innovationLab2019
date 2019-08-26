using System;
using matching_learning.common.Domain.BusinessLogic;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.DTOs
{
    public class Skill : IComparable<Skill>
    {
        public int Id { get; set; }

        public int RelatedId { get; set; }

        public SkillCategory Category { get; set; }

        public string CategoryDescription { get { return EnumHelper.GetEnumDescription(this.Category); } }

        public string Code { get; set; }

        public string Name { get; set; }

        public decimal DefaultExpertise { get; set; }

        public int CompareTo(Skill other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
