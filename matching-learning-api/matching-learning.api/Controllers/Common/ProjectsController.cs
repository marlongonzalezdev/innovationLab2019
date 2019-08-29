﻿using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using matching_learning.common.Domain.BusinessLogic;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
using matching_learning_algorithm;
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
        private readonly ICandidateRepository _candidateRepository;
        private readonly IProjectAnalyzer _analyzer;

        /// <summary>
        /// Initializes a new instance of the <see cref="SkillsController"/> class.
        /// </summary>
        /// <param name="skillRepository">The skills repo.</param>
        /// /// <param name="analizer">The skills repo.</param>
        /// /// <param name="candidateRepository">The skills repo.</param>
        public ProjectsController(ISkillRepository skillRepository, IProjectAnalyzer analizer, ICandidateRepository candidateRepository)
        {
            _skillRepository = skillRepository;
            _analyzer = analizer;
            _candidateRepository = candidateRepository;
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
        public IActionResult GetProjectCandidatesOld([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
           return Ok(SearchProjectCandidatesEngine.GetProjectCandidates(pcr, _skillRepository));
                
        }

        /// <summary>
        /// Get best candidates for a project.
        /// </summary>
        /// <param name="pcr"></param>
        [HttpPost("GetProjectCandidatesNew")]
        [ProducesResponseType(typeof(List<ProjectCandidate>), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetProjectCandidates([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            var analysisResult = await _analyzer.GetRecommendationsAsync(pcr, false);
            var candidates = _candidateRepository.GetCandidateByIds(analysisResult.Matches.Select(c => int.Parse(c)).ToList());
            var result = candidates.Select(candidate => new ProjectCandidate { Candidate = candidate, Ranking = 0, SkillRankings = null });

            return Ok(result);
            
        }
        #endregion
    }
}
