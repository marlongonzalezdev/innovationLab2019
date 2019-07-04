using System;
using System.Collections.Generic;
using GenFu;
using matching_learning.ml.Domain;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace matching_learning.api.Models
{
    /// <summary>
    /// A model to represent the recommendations for a given project.
    /// </summary>
    public class ProjectRecommendationsModel
    {
        private static readonly Random _random = new Random(Environment.TickCount);

        static ProjectRecommendationsModel() => candidates = new List<Candidate>
        {
            new Candidate
            {
                UserId = "mgonzalez",
                Name = "Marlon",
                LastName = "González",
                Score = _random.NextDouble()
            },
            new Candidate
            {
                UserId = "yvaldes",
                Name = "Yanara",
                LastName = "Valdes",
                Score = _random.NextDouble()
            },
            new Candidate
            {
                UserId = "dalvarez",
                Name = "Delia",
                LastName = "Álvarez",
                Score = _random.NextDouble()
            },
            new Candidate
            {
                UserId = "wclaro",
                Name = "Willian",
                LastName = "Claro",
                Score = _random.NextDouble()
            },
            new Candidate
            {
                UserId = "ktamayo",
                Name = "Karel",
                LastName = "Tamayo",
                Score = _random.NextDouble()
            }
        };

        private static readonly IList<Candidate> candidates;

        /// <summary>
        /// Gets or sets the matches.
        /// </summary>
        /// <value>
        /// The matches.
        /// </value>
        public IList<CandidateModel> Matches { get; set; }

        /// <summary>
        /// Returns a recommendation model from the given domain recommendation response.
        /// </summary>
        /// <param name="obj">The object.</param>
        /// <param name="linkGenerator">The link generator.</param>
        /// <param name="httpContextAccessor">The HTTP context accessor.</param>
        /// <returns></returns>
        public static ProjectRecommendationsModel FromRecommendationResponse(RecommendationResponse obj, LinkGenerator linkGenerator, IHttpContextAccessor httpContextAccessor)
        {
            var userModels = new List<CandidateModel>();
            foreach (var candidate in obj.Matches)
            {
                CandidateModel userModel = A.New<CandidateModel>().FromCandidate(candidate);
                userModel.PhotoUrl = linkGenerator.GetUriByAction(httpContextAccessor.HttpContext, "Get", "Photo", new { id = candidate.UserId });
                userModels.Add(userModel);
            }

            var result = new ProjectRecommendationsModel
            {
                Matches = userModels
            };

            return result;
        }
    }
}