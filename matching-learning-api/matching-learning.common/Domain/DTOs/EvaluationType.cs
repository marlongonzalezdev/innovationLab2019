using System;

namespace matching_learning.common.Domain.DTOs
{
    public class EvaluationType : IComparable<EvaluationType>
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public decimal Priority { get; set; }

        public int CompareTo(EvaluationType other)
        {
            return (Name.CompareTo(other.Name));
        }
    }
}
