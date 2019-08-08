using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;
using matching_learning.api.Repositories.Common;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the candidates.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class CandidatesController : ControllerBase
    {
        private readonly ICandidateRepository _candidateRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="CandidatesController"/> class.
        /// </summary>
        /// <param name="candidateRepository">The candidates repo.</param>
        public CandidatesController(ICandidateRepository candidateRepository)
        {
            _candidateRepository = candidateRepository;
        }

        /// <summary>
        /// Gets the candidates.
        /// </summary>
        /// <returns></returns>
        [Route("Candidates")]
        public ActionResult<List<Candidate>> Get()
        {
            return _candidateRepository.GetCandidates();
        }

        /// <summary>
        /// Gets the candidate with the identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("Candidate")]
        public ActionResult<Candidate> GetCandidateById(int id)
        {
            return _candidateRepository.GetCandidateById(id);
        }
    }
}
