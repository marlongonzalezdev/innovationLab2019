using System.Collections.Generic;
using System.Linq;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Repositories.Common;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    [Route("[controller]")]
    [ApiController]
    public class ProjectController : ControllerBase
    {
        private readonly ISkillRepository _skillRepository;
        private readonly ICandidateRepository _candidateRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="SkillsController"/> class.
        /// </summary>
        /// <param name="skillRepository">The skills repo.</param>
        /// <param name="candidateRepository">The candidates repo.</param>
        public ProjectController(ISkillRepository skillRepository, ICandidateRepository candidateRepository)
        {
            _skillRepository = skillRepository;
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
        public IActionResult GetProjectCandidates([FromBody] ProjectCandidateRequirement pcr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            List<int> reqSkills = pcr.SkillsFilter.Select(sf => sf.RequiredSkill.Id).Distinct().ToList();

            var estimated = _skillRepository.GetSkillEstimatedExpertisesBySkillIds(reqSkills);

            if (pcr.InBenchFilter.HasValue)
            {
                estimated = estimated.Where(e => e.Candidate.InBench == pcr.InBenchFilter.Value).ToList();
            }

            if (pcr.DeliveryUnitFilter != null)
            {
                estimated = estimated.Where(e => e.Candidate.DeliveryUnitId == pcr.DeliveryUnitFilter.Id).ToList();
            }

            if (pcr.RoleFilter != null)
            {
                estimated = estimated.Where(e => e.Candidate.ActiveRole != null && e.Candidate.ActiveRole.Id == pcr.RoleFilter.Id).ToList();
            }

            if (pcr.RelationTypeFilter != null)
            {
                estimated = estimated.Where(e => e.Candidate.RelationType == pcr.RelationTypeFilter.Value).ToList();
            }

            var filteredCandidates = estimated.Select(e => e.Candidate).Distinct().ToList();

            var res = filteredCandidates.Select(fc => new ProjectCandidate()
            {
                Candidate = fc,
                Ranking = getRanking(pcr.SkillsFilter, getCandidateSkillEstimatedExpertise(fc, estimated)),
            }).Where(pc => pc.Ranking >= 0).OrderByDescending(pc => pc.Ranking).Take(pcr.Max).ToList();

            return Ok(res);
        }

        private decimal getRanking(List<ProjectSkillRequirement> skillsFilter, List<SkillEstimatedExpertise> candidateExpertise)
        {
            decimal res = 0;

            foreach (var sf in skillsFilter)
            {
                var ce = candidateExpertise.FirstOrDefault(cexp => cexp.Skill.Id == sf.RequiredSkill.Id);

                if (sf.MinAccepted.HasValue && (ce == null || ce.Expertise < sf.MinAccepted.Value))
                {
                    return (-1);
                }

                if (ce != null)
                {
                    res += sf.Weight * ce.Expertise;
                }
            }

            return (res);
        }

        private List<SkillEstimatedExpertise> getCandidateSkillEstimatedExpertise(Candidate candidate, List<SkillEstimatedExpertise> candidatesExpertise)
        {
            return (candidatesExpertise.Where(ce => ce.Candidate.Id == candidate.Id).ToList());
        }
        #endregion
    }
}
