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

        #region Retrieve
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
        #endregion

        #region Save
        /// <summary>
        /// Save the business area object in the database (insert/update).
        /// </summary>
        /// <param name="ba"></param>
        [HttpPost("SaveBusinessArea")]
        [ProducesResponseType(typeof(BusinessArea), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveBusinessArea([FromBody] BusinessArea ba)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _skillRepository.SaveBusinessArea(ba);

            var res = _skillRepository.GetBusinessAreaByCode(ba.Code);

            return Ok(res);
        }

        /// <summary>
        /// Save the soft skill object in the database (insert/update).
        /// </summary>
        /// <param name="ss"></param>
        [HttpPost("SaveSoftSkill")]
        [ProducesResponseType(typeof(SoftSkill), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveSoftSkill([FromBody] SoftSkill ss)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _skillRepository.SaveSoftSkill(ss);

            var res = _skillRepository.GetSoftSkillByCode(ss.Code);

            return Ok(res);
        }

        /// <summary>
        /// Save the technology object in the database (insert/update).
        /// </summary>
        /// <param name="tech"></param>
        [HttpPost("SaveTechnology")]
        [ProducesResponseType(typeof(Technology), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveTechnology([FromBody] Technology tech)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _skillRepository.SaveTechnology(tech);

            var res = _skillRepository.GetTechnologyByCode(tech.Code);

            return Ok(res);
        }

        /// <summary>
        /// Save the technology role object in the database (insert/update).
        /// </summary>
        /// <param name="tr"></param>
        [HttpPost("SaveTechnologyRole")]
        [ProducesResponseType(typeof(TechnologyRole), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveTechnologyRole([FromBody] TechnologyRole tr)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _skillRepository.SaveTechnologyRole(tr);

            var res = _skillRepository.GetTechnologyRoleByCode(tr.Code);

            return Ok(res);
        }
        #endregion
    }
}
