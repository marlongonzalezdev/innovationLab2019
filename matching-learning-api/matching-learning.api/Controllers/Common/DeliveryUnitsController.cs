using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Repositories.Common;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the delivery units.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class DeliveryUnitsController : ControllerBase
    {
        private readonly IDeliveryUnitRepository _deliveryUnitRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="DeliveryUnitsController"/> class.
        /// </summary>
        /// <param name="deliveryUnitRepository">The deliveryUnit repo.</param>
        public DeliveryUnitsController(IDeliveryUnitRepository deliveryUnitRepository)
        {
            _deliveryUnitRepository = deliveryUnitRepository;
        }

        /// <summary>
        /// Gets the photo with the specified identifier.
        /// </summary>
        /// <returns></returns>
        [HttpGet("deliveryunits")]
        public ActionResult<List<DeliveryUnit>> Get()
        {
            return _deliveryUnitRepository.GetDeliveryUnits();
        }
    }
}
