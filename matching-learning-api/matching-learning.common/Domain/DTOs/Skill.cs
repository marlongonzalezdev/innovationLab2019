using System;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.DTOs
{
    public class Skill : IComparable<Skill>
    {
        public int Id { get; set; }

        public int RelatedId { get; set; }

        public SkillCategory Category { get; set; }

        public string CategoryDescription
        {
            get
            {
                FieldInfo fi = this.Category.GetType().GetField(this.Category.ToString());

                DescriptionAttribute[] attributes = fi.GetCustomAttributes(typeof(DescriptionAttribute), false) as DescriptionAttribute[];

                if (attributes != null && attributes.Any())
                {
                    return attributes.First().Description;
                }

                return this.Category.ToString();
            }
        }

        public string Code { get; set; }

        public string Name { get; set; }

        public decimal DefaultExpertise { get; set; }

        public int CompareTo(Skill other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
