using System;

namespace matching_learning.common.Domain.DTOs
{
    public class Region : IComparable<Region>
    {
        public int Id { get; set; }

        public string Code { get; set; }

        public string Name { get; set; }

        public int CompareTo(Region other)
        {
            return (this.Name.CompareTo(other.Name));
        }
    }
}
