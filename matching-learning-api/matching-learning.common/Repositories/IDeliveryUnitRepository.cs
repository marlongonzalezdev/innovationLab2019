using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;

namespace matching_learning.common.Repositories
{
    public interface IDeliveryUnitRepository
    {
         List<DeliveryUnit> GetDeliveryUnits();
    }
}
