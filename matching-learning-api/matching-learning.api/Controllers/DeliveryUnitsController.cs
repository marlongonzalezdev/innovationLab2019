﻿using System;
using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers
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
        /// Gets the delivery units.
        /// </summary>
        /// <returns></returns>
        [Route("DeliveryUnits")]
        public ActionResult<List<DeliveryUnit>> GetDeliveryUnits()
        {
            return _deliveryUnitRepository.GetDeliveryUnits();
        }

        /// <summary>
        /// Gets the delivery units paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("DeliveryUnitsPaginated")]
        public ActionResult<List<DeliveryUnit>> GetDeliveryUnitsPaginated(int pageIdx, int pageSize)
        {
            return _deliveryUnitRepository.GetDeliveryUnits().OrderBy(du => du.Id).Skip(pageIdx * pageSize).Take(pageSize).ToList();
        }
        
        /// <summary>
        /// Get the user default delivery unit.
        /// </summary>
        /// <returns></returns>
        [Route("DefaultDeliveryUnit")]
        public ActionResult<DeliveryUnit> GetDefaultDeliveryUnit()
        {
            return _deliveryUnitRepository.GetDeliveryUnits().Where(du => string.Compare(du.Code, "MVD", StringComparison.InvariantCultureIgnoreCase) == 0).FirstOrDefault();
        }
    }
}
