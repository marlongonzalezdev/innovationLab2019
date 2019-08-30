using System.Collections.Generic;
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
        /// Get best candidates for a project - based on Weighted Average.
        /// </summary>
        /// <param name="pcr"></param>
        [HttpPost("GetProjectCandidates")]
        [ProducesResponseType(typeof(List<ProjectCandidate>), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult GetProjectCandidatesWeightedAverage([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            return Ok(SearchProjectCandidatesEngine.GetProjectCandidatesWeightedAverage(pcr, _skillRepository));
        }

        /// <summary>
        /// Get best candidates for a project - based on Machine Learning.
        /// </summary>
        /// <param name="pcr"></param>
        [HttpPost("GetProjectCandidatesNew")]
        [ProducesResponseType(typeof(List<ProjectCandidate>), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetProjectCandidatesMachineLearning([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var skillIds = pcr.SkillsFilter.Select(sf => sf.RequiredSkillId).Distinct().ToList();
            var analysisResult = await _analyzer.GetRecommendationsAsync(pcr, false);
            var candidateIds = analysisResult.Matches.Select(c => int.Parse(c)).ToList();
            var candidates = _candidateRepository.GetCandidateByIds(candidateIds);
            var candidateExpertises = _skillRepository.GetSkillEstimatedExpertiseByCandidateAndSkillIds(candidateIds, skillIds);

            var query = candidates.AsQueryable();

            if ((pcr.InBenchFilter.HasValue) && (pcr.InBenchFilter.Value))
            {
                query = query.Where(c => c.InBench);
            }

            if (pcr.DeliveryUnitIdFilter.HasValue)
            {
                query = query.Where(c => c.DeliveryUnit.Id.Equals(pcr.DeliveryUnitIdFilter.Value));
            }

            if (pcr.RoleIdFilter.HasValue)
            {
                query = query.Where(c => c.ActiveRole.Id.Equals(pcr.RoleIdFilter.Value));
            }

            if (pcr.RelationTypeFilter.HasValue)
            {
                query = query.Where(c => c.RelationType.Equals(pcr.RelationTypeFilter.Value));
            }

            if (pcr.Max != 0)
            {
                query = query.Take(pcr.Max);
            }

            candidates = query.ToList();

            var result = candidates.Select(candidate => new ProjectCandidate
            {
                Candidate = candidate,
                Ranking = 0,
                SkillExpertises = candidateExpertises
                    .Where(exp => exp.Candidate.Id == candidate.Id)
                    .Select(exp => new ProjectCandidateSkill()
                    {
                        Skill = exp.Skill,
                        Expertise = exp.Expertise,
                    }).ToList(),
            }).ToList();

            return Ok(result);
        }
        #endregion
    }
}
