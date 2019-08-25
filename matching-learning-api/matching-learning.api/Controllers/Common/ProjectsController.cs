using System.Collections.Generic;
using matching_learning.common.Domain.BusinessLogic;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// Controller for best project candidates searching.
    /// </summary>
    [Route("[controller]")]
    [ApiController]
    public class ProjectsController : ControllerBase
    {
        private readonly ISkillRepository _skillRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="SkillsController"/> class.
        /// </summary>
        /// <param name="skillRepository">The skills repo.</param>
        public ProjectsController(ISkillRepository skillRepository)
        {
            _skillRepository = skillRepository;
         }

        #region Retrieve
        /// <summary>
        /// Get best candidates for a project.
        /// </summary>
        /// <param name="pcr"></param>
        [HttpPost("GetProjectCandidates")]
        [ProducesResponseType(typeof(List<ProjectCandidate>), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult GetProjectCandidates([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            return Ok(SearchProjectCandidatesEngine.GetProjectCandidates(pcr, _skillRepository));
        }
        #endregion
    }
}
