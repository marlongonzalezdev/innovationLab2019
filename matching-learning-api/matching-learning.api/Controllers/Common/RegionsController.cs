using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Repositories.Common;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the regions.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class RegionsController : ControllerBase
    {
        private readonly IRegionRepository _regionRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="RegionsController"/> class.
        /// </summary>
        /// <param name="regionRepository">The regions repo.</param>
        public RegionsController(IRegionRepository regionRepository)
        {
            _regionRepository = regionRepository;
        }

        /// <summary>
        /// Gets the photo with the specified identifier.
        /// </summary>
        /// <returns></returns>
        [HttpGet("regions")]
        public ActionResult<List<Region>> Get()
        {
            return _regionRepository.GetRegions();
        }
    }
}
