using System.Linq;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the candidate evaluations.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class CandidateEvaluationsController : ControllerBase
    {
        private readonly ICandidateRepository _candidateRepository;
        private readonly IEvaluationRepository _evaluationRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="CandidateEvaluationsController"/> class.
        /// </summary>
        /// <param name="candidateRepository">The candidates repo.</param>
        /// <param name="evaluationRepository">The evaluations repo.</param>
        public CandidateEvaluationsController(ICandidateRepository candidateRepository,
                                              IEvaluationRepository evaluationRepository)
        {
            _candidateRepository = candidateRepository;
            _evaluationRepository = evaluationRepository;

        }

        /// <summary>
        /// Gets the candidate evaluations.
        /// </summary>
        /// <param name="candidateId">Candidate Id.</param>
        /// <returns></returns>
        [Route("CandidateEvaluations")]
        public ActionResult<CandidateEvaluations> GetCandidateEvaluations(int candidateId)
        {
            var candidate = _candidateRepository.GetCandidateById(candidateId);
            var evaluations = _evaluationRepository.GetEvaluationsByCandidateId(candidateId);

            return new CandidateEvaluations()
            {
                Candidate = candidate,
                Evaluations = evaluations,
            };
        }

        /// <summary>
        /// Gets the candidate evaluations paginated.
        /// </summary>
        /// <param name="candidateId">Candidate Id.</param>
        /// <param name="pageIdx">Page index (0 based).</param>
        /// <param name="pageSize">Page size.</param>
        /// <returns></returns>
        [Route("CandidateEvaluationsPaginated")]
        public ActionResult<CandidateEvaluations> GetCandidateEvaluationsPaginated(int candidateId, int pageIdx, int pageSize)
        {
            var candidate = _candidateRepository.GetCandidateById(candidateId);
            var evaluations = _evaluationRepository.GetEvaluationsByCandidateId(candidateId).OrderBy(ca => ca.Id).Skip(pageIdx * pageSize).Take(pageSize)
                .ToList();

            return new CandidateEvaluations()
            {
                Candidate = candidate,
                Evaluations = evaluations,
            };
        }
    }
}