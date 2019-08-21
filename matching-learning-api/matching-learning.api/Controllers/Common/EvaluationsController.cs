using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the evaluations.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class EvaluationsController : ControllerBase
    {
        private readonly IEvaluationRepository _evaluationRepository;
        private readonly IEvaluationTypeRepository _evaluationTypeRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="EvaluationsController"/> class.
        /// </summary>
        /// <param name="evaluationRepository">The evaluations repo.</param>
        /// <param name="evaluationTypeRepository">The evaluation roles repo.</param>
        public EvaluationsController(IEvaluationRepository evaluationRepository,
            IEvaluationTypeRepository evaluationTypeRepository)
        {
            _evaluationRepository = evaluationRepository;
            _evaluationTypeRepository = evaluationTypeRepository;
        }

        /// <summary>
        /// Gets the evaluations.
        /// </summary>
        /// <returns></returns>
        [Route("Evaluations")]
        public ActionResult<List<Evaluation>> GetEvaluations()
        {
            return _evaluationRepository.GetEvaluations();
        }

        /// <summary>
        /// Gets the evaluations paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("EvaluationsPaginated")]
        public ActionResult<List<Evaluation>> GetEvaluationsPaginated(int pageIdx, int pageSize)
        {
            return _evaluationRepository.GetEvaluations().OrderBy(ca => ca.Id).Skip(pageIdx * pageSize).Take(pageSize)
                .ToList();
        }

        /// <summary>
        /// Gets the evaluation with the identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("Evaluation")]
        public ActionResult<Evaluation> GetEvaluationById(int id)
        {
            return _evaluationRepository.GetEvaluationById(id);
        }

        /// <summary>
        /// Gets the evaluation roles.
        /// </summary>
        /// <returns></returns>
        [Route("EvaluationTypes")]
        public ActionResult<List<EvaluationType>> GetEvaluationTypes()
        {
            return _evaluationTypeRepository.GetEvaluationTypes();
        }

        /// <summary>
        /// Gets the evaluation roles paginated.
        /// </summary>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("EvaluationTypesPaginated")]
        public ActionResult<List<EvaluationType>> GetEvaluationTypesPaginated(int pageIdx, int pageSize)
        {
            return _evaluationTypeRepository.GetEvaluationTypes().OrderBy(cr => cr.Id).Skip(pageIdx * pageSize)
                .Take(pageSize).ToList();
        }

        /// <summary>
        /// Gets the evaluation role with the identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("EvaluationType")]
        public ActionResult<EvaluationType> GetEvaluationTypeById(int id)
        {
            return _evaluationTypeRepository.GetEvaluationTypeById(id);
        }

        #region Save

        /// <summary>
        /// Save the evaluation object in the database (insert/update).
        /// </summary>
        /// <param name="ca"></param>
        [HttpPost("SaveEvaluation")]
        [ProducesResponseType(typeof(Evaluation), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveEvaluation([FromBody] Evaluation ca)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var id = _evaluationRepository.SaveEvaluation(ca);

            var res = _evaluationRepository.GetEvaluationById(id);

            return Ok(res);
        }

        #endregion
    }
}