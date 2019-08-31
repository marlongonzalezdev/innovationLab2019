using System;

namespace matching_learning.common.Domain.DTOs
{
    public class DeliveryUnit : IComparable<DeliveryUnit>
    {
        public int Id { get; set; }

        public string Code { get; set; }

        public string Name { get; set; }

        public int RegionId { get; set; }

        public Region Region { get; set; }

        public int CompareTo(DeliveryUnit other)
        {
            return (this.Name.CompareTo(other.Name));
        }
    }
}
