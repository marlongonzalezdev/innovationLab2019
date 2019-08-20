﻿using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Repositories;
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
        private readonly ICandidateRoleRepository _candidateRoleRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="CandidatesController"/> class.
        /// </summary>
        /// <param name="candidateRepository">The candidates repo.</param>
        /// <param name="candidateRoleRepository">The candidate roles repo.</param>
        public CandidatesController(ICandidateRepository candidateRepository,
                                    ICandidateRoleRepository candidateRoleRepository)
        {
            _candidateRepository = candidateRepository;
            _candidateRoleRepository = candidateRoleRepository;
        }

        /// <summary>
        /// Gets the candidates.
        /// </summary>
        /// <returns></returns>
        [Route("Candidates")]
        public ActionResult<List<Candidate>> GetCandidates()
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

        /// <summary>
        /// Gets the candidates.
        /// </summary>
        /// <returns></returns>
        [Route("CandidateRoles")]
        public ActionResult<List<CandidateRole>> GetCandidateRoles()
        {
            return _candidateRoleRepository.GetCandidateRoles();
        }

        /// <summary>
        /// Gets the candidate with the identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [Route("CandidateRole")]
        public ActionResult<CandidateRole> GetCandidateRoleById(int id)
        {
            return _candidateRoleRepository.GetCandidateRoleById(id);
        }

        #region Save
        /// <summary>
        /// Save the candidate object in the database (insert/update).
        /// </summary>
        /// <param name="ca"></param>
        [HttpPost("SaveCandidate")]
        [ProducesResponseType(typeof(Candidate), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult SaveCandidate([FromBody] Candidate ca)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var id = _candidateRepository.SaveCandidate(ca);

            var res = _candidateRepository.GetCandidateById(id);

            return Ok(res);
        }
        #endregion
    }
}
