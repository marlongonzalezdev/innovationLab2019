using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers
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
        /// Gets the regions.
        /// </summary>
        /// <returns></returns>
        [Route("Regions")]
        public ActionResult<List<Region>> GetRegions()
        {
            return _regionRepository.GetRegions();
        }

        /// <summary>
        /// Gets the regions paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("RegionsPaginated")]
        public ActionResult<List<Region>> GetRegionsPaginated(int pageIdx, int pageSize)
        {
            return _regionRepository.GetRegions().OrderBy(r => r.Id).Skip(pageIdx * pageSize).Take(pageSize).ToList();
        }
    }
}
