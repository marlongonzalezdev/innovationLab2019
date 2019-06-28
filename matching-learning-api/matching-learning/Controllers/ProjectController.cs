using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using matching_learning.ml;
using matching_learning.Models;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProjectController : ControllerBase
    {
        private readonly Random _random = new Random(Environment.TickCount);
        private readonly IProjectAnalyzer _analyzer;

        /// <summary>
        /// Initializes a new instance of the <see cref="ProjectController"/> class.
        /// </summary>
        /// <param name="analyzer">The analyzer.</param>
        public ProjectController(IProjectAnalyzer analyzer)
        {
            this._analyzer = analyzer;
        }

        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            return new string[] { "value1", "value2" };
        }

        [HttpGet("{id}")]
        public ActionResult<string> Get(int id)
        {
            return "value";
        }

        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        /// <summary>
        /// Retrieves the candidates that match the given project skill requirements.
        /// </summary>
        /// <param name="model"></param>
        [HttpPost("candidates")]
        [ProducesResponseType(typeof(ProjectRecommendationsModel), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public async Task<IActionResult> Candidates([FromBody] ProjectCandidatesModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var recommendationRequest = model.ToRecommendationRequest();
            var analysisResult = _analyzer.GetRecommendations(recommendationRequest);

            return Ok(analysisResult);
        }

        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
