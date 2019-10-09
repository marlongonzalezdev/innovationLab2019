using System.Threading.Tasks;
using matching_learning.api.Models;
using matching_learning.common.Domain.DTOs;
using matching_learning_algorithm;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace matching_learning.api.Controllers.Old
{
    /// <summary>
    /// A controller for the projects
    /// </summary>
    /// <seealso cref="Microsoft.AspNetCore.Mvc.ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class ProjectController : ControllerBase
    {
        private readonly IProjectAnalyzer _analyzer;
        private readonly LinkGenerator _linkGenerator;
        private readonly IHttpContextAccessor _httpContextAccessor;

        /// <summary>
        /// Initializes a new instance of the <see cref="ProjectController" /> class.
        /// </summary>
        /// <param name="analyzer">The analyzer.</param>
        /// <param name="linkGenerator">The link generator.</param>
        /// <param name="httpContextAccessor">The HTTP context accessor.</param>
        public ProjectController(IProjectAnalyzer analyzer, 
            LinkGenerator linkGenerator, 
            IHttpContextAccessor httpContextAccessor)
        {
            _analyzer = analyzer;
            _linkGenerator = linkGenerator;
            _httpContextAccessor = httpContextAccessor;
        }

        /// <summary>
        /// Retrieves the candidates that match the given project skill requirements.
        /// </summary>
        /// <param name="model"></param>
        [HttpPost("candidates")]
        [ProducesResponseType(typeof(ProjectRecommendationsModel), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public async Task<IActionResult> Candidates([FromBody] ProjectCandidateRequirement model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var analysisResult = await _analyzer.GetRecommendationsAsync(model, false);
            ProjectRecommendationsModel result = ProjectRecommendationsModel.FromRecommendationResponse(analysisResult, _linkGenerator, _httpContextAccessor);

            return Ok(result);
        }
    }
}
