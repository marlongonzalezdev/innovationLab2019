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
        private readonly IProjectRepository _projectRepository;
        private readonly IProjectAnalyzer _analyzer;

        /// <summary>
        /// Initializes a new instance of the <see cref="SkillsController"/> class.
        /// </summary>
        /// <param name="projectRepository">The projects repo.</param>
        /// <param name="skillRepository">The skills repo.</param>
        /// <param name="candidateRepository">The candidates repo.</param>
        /// <param name="analyzer">The ML analyzer.</param>
        public ProjectsController(IProjectRepository projectRepository, ISkillRepository skillRepository, ICandidateRepository candidateRepository, IProjectAnalyzer analyzer)
        {
            _projectRepository = projectRepository;
            _skillRepository = skillRepository;
            _candidateRepository = candidateRepository;
            _analyzer = analyzer;
        }

        #region Retrieve
        #region Projects
        /// <summary>
        /// Gets the projects.
        /// </summary>
        /// <returns></returns>
        [Route("Projects")]
        public ActionResult<List<Project>> GetProjects()
        {
            return _projectRepository.GetProjects();
        }

        /// <summary>
        /// Gets the projects paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("ProjectsPaginated")]
        public ActionResult<List<Project>> GetRegionsPaginated(int pageIdx, int pageSize)
        {
            return _projectRepository.GetProjectsPaginated(pageIdx, pageSize);
        }

        /// <summary>
        /// Gets the project with the identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("Project")]
        public ActionResult<Project> GetProjectById(int id)
        {
            return _projectRepository.GetProjectById(id);
        }
        #endregion

        #region Search best candidate for position
        /// <summary>
        /// Get best candidates for a project - based on Weighted Average.
        /// </summary>
        /// <param name="pcr"></param>
        [HttpPost("GetProjectCandidatesWA")]
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
        [HttpPost("GetProjectCandidates")]
        [ProducesResponseType(typeof(List<ProjectCandidate>), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetProjectCandidatesMachineLearning([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var skillIds = pcr.SkillsFilter.Select(sf => sf.RequiredSkillId).Distinct().ToList();
            var analysisResult = await _analyzer.GetRecommendationsAsync(pcr, false);

            var candidateIds = analysisResult.Matches.Keys.ToList();
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

            var result = query.Select(candidate => new ProjectCandidate
            {
                Candidate = candidate,
                Ranking = 1m - ((decimal)analysisResult.Matches[candidate.Id]) / 100.0M,
                SkillExpertises = candidateExpertises
                    .Where(exp => exp.Candidate.Id == candidate.Id)
                    .Select(exp => new ProjectCandidateSkill()
                    {
                        Skill = exp.Skill,
                        Expertise = exp.Expertise,
                    }).ToList(),
            })
                .OrderByDescending(r => r.Ranking)
                .ToList();

            return Ok(result);
        }
        #endregion
        #endregion
    }
}
