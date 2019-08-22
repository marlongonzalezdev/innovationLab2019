using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.DTOs.Views;
using matching_learning.common.Repositories;
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
        #region SkillView
        /// <summary>
        /// Gets the skill views.
        /// </summary>
        /// <returns></returns>
        [Route("SkillViews")]
        public ActionResult<List<SkillView>> GetSkillViews()
        {
            return _skillRepository.GetSkillViews();
        }

        /// <summary>
        /// Gets the skill views paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("SkillViewsPaginated")]
        public ActionResult<List<SkillView>> GetSkillViewsPaginated(int pageIdx, int pageSize)
        {
            return _skillRepository.GetSkillViews().OrderBy(s => s.Id).Skip(pageIdx * pageSize).Take(pageSize).ToList();
        }

        /// <summary>
        /// Gets the skill view with the specified skill identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("SkillView")]
        public ActionResult<SkillView> GetSkillViewById(int id)
        {
            return _skillRepository.GetSkillViewById(id);
        }
#endregion

        #region Skill
        /// <summary>
        /// Gets the skills.
        /// </summary>
        /// <returns></returns>
        [Route("Skills")]
        public ActionResult<List<Skill>> GetSkills()
        {
            return _skillRepository.GetSkills();
        }

        /// <summary>
        /// Gets the skills paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("SkillsPaginated")]
        public ActionResult<List<Skill>> GetSkillsPaginated(int pageIdx, int pageSize)
        {
            return _skillRepository.GetSkills().OrderBy(s => s.Id).Skip(pageIdx * pageSize).Take(pageSize).ToList();
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
        #endregion

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

        /// <summary>
        /// Gets the skill estimated expertise.
        /// </summary>
        /// <returns></returns>
        [Route("SkillEstimatedExpertises")]
        public ActionResult<List<SkillEstimatedExpertise>> GetSkillEstimatedExpertises()
        {
            return _skillRepository.GetSkillEstimatedExpertises();
        }

        /// <summary>
        /// Gets the skill estimated expertise by skill ids.
        /// </summary>
        /// <param name="ids">The identifier.</param>
        /// <returns></returns>
        [HttpPost("SkillEstimatedExpertisesBySkillIds")]
        [Consumes("application/json")]
        public ActionResult<List<SkillEstimatedExpertise>> GetSkillEstimatedExpertisesBySkillIds([FromBody] List<int> ids)
        {
            return _skillRepository.GetSkillEstimatedExpertisesBySkillIds(ids);
        }

        /// <summary>
        /// Gets the skill relations for a skill.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("SkillRelationsBySkillId")]
        public ActionResult<List<SkillRelation>> GetSkillRelationsBySkillId(int id)
        {
            return _skillRepository.GetSkillRelationsBySkillId(id);
        }
        #endregion

        #region Save
        /// <summary>
        /// Save the skill view in the database (insert/update).
        /// </summary>
        /// <param name="sv"></param>
        [HttpPost("SaveSkillView")]
        [ProducesResponseType(typeof(SkillView), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveSkillView([FromBody] SkillView sv)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var id = _skillRepository.SaveSkillView(sv);

            var res = _skillRepository.GetSkillViewById(id);

            return Ok(res);
        }

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

            var id = _skillRepository.SaveBusinessArea(ba);

            var res = _skillRepository.GetBusinessAreaById(id);

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

            var id = _skillRepository.SaveSoftSkill(ss);

            var res = _skillRepository.GetSoftSkillById(id);

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

            var id = _skillRepository.SaveTechnology(tech);

            var res = _skillRepository.GetTechnologyById(id);

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

            var id = _skillRepository.SaveTechnologyRole(tr);

            var res = _skillRepository.GetTechnologyRoleById(id);

            return Ok(res);
        }
        #endregion
    }
}
