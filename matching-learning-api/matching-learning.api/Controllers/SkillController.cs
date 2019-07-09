using System.Collections.Generic;
using matching_learning.api.Repositories;
using matching_learning.ml.Domain;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers
{
    /// <summary>
    /// The controller for the skills.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class SkillController : ControllerBase
    {
        private readonly ISkillRepository _skillRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="SkillController"/> class.
        /// </summary>
        /// <param name="skillRepository">The skills repo.</param>
        public SkillController(ISkillRepository skillRepository)
        {
            _skillRepository = skillRepository;
        }

        /// <summary>
        /// Gets the photo with the specified identifier.
        /// </summary>
        /// <returns></returns>
        [HttpGet("skills")]
        public ActionResult<List<Skill>> Get()
        {
            return _skillRepository.GetSkills();
        }
    }
}