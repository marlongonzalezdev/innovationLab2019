using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.DTOs.Views
{
    public class SkillView : IComparable<SkillView>
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

        public bool IsVersioned { get; set; } // Only for Technology

        public List<SkillVersionView> Versions { get; set; }  // Only for Technology

        public List<SkillRoleView> Roles { get; set; }  // Only for Technology

        public int CompareTo(SkillView other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
