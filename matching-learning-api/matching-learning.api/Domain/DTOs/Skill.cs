using System;
using matching_learning.api.Domain.Enums;

namespace matching_learning.api.Domain.DTOs
{
    public class Skill : IComparable<Skill>
    {
        public int Id { get; set; }
        public int RelatedId { get; set; }
        public SkillCategory Category { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }

        public int CompareTo(Skill other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
