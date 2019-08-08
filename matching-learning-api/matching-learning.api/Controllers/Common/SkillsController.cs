using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Repositories.Common;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the skills.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class SkillsController : ControllerBase
    {
        private readonly ISkillRepository _skillRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="SkillsController"/> class.
        /// </summary>
        /// <param name="skillRepository">The skills repo.</param>
        public SkillsController(ISkillRepository skillRepository)
        {
            _skillRepository = skillRepository;
        }

        /// <summary>
        /// Gets the skills.
        /// </summary>
        /// <returns></returns>
        [Route("Skills")]
        public ActionResult<List<Skill>> Get()
        {
            return _skillRepository.GetSkills();
        }

        /// <summary>
        /// Gets the skill with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("Skill")]
        public ActionResult<Skill> GetSkillById(int id)
        {
            return _skillRepository.GetSkillById(id);
        }

        /// <summary>
        /// Gets the business area with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("BusinessArea")]
        public ActionResult<BusinessArea> GetBusinessAreaById(int id)
        {
            return _skillRepository.GetBusinessAreaById(id);
        }

        /// <summary>
        /// Gets the soft skill with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("SoftSkill")]
        public ActionResult<SoftSkill> GetSoftSkillById(int id)
        {
            return _skillRepository.GetSoftSkillById(id);
        }

        /// <summary>
        /// Gets the technology with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("Technology")]
        public ActionResult<Technology> GetTechnologyById(int id)
        {
            return _skillRepository.GetTechnologyById(id);
        }

        /// <summary>
        /// Gets the technology version with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("TechnologyVersion")]
        public ActionResult<TechnologyVersion> GetTechnologyVersionById(int id)
        {
            return _skillRepository.GetTechnologyVersionById(id);
        }

        /// <summary>
        /// Gets the technology role with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("TechnologyRole")]
        public ActionResult<TechnologyRole> GetTechnologyRoleById(int id)
        {
            return _skillRepository.GetTechnologyRoleById(id);
        }

        /// <summary>
        /// Gets the technology versions with the specified parent technology skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("TechnologyVersionsByTechnology")]
        public ActionResult<List<TechnologyVersion>> GetTechnologyVersionsByTechnologyId(int id)
        {
            return _skillRepository.GetTechnologyVersionsByTechnologyId(id);
        }
    }
}
