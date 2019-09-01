using System;

namespace matching_learning.common.Domain.DTOs
{
    public class Project : IComparable<Project>
    {
        public int Id { get; set; }

        public string Code { get; set; }

        public string Name { get; set; }

        public int CompareTo(Project other)
        {
            return (this.Name.CompareTo(other.Name));
        }
    }
}
