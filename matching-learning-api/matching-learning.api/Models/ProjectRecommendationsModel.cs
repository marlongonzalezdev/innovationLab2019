using System.Collections.Generic;
using matching_learning_algorithm.Domain;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace matching_learning.api.Models
{
    /// <summary>
    /// A model to represent the recommendations for a given project.
    /// </summary>
    public class ProjectRecommendationsModel
    {
        /// <summary>
        /// The total number of elements.
        /// </summary>
        public int TotalItems { get; set; }

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
            //foreach (var candidate in obj.Matches)
            //{
            //    CandidateModel userModel = A.New<CandidateModel>().FromCandidate(candidate);
            //    userModel.PhotoUrl = linkGenerator.GetUriByAction(httpContextAccessor.HttpContext, "Get", "Photo", new { id = candidate. });
            //    userModels.Add(userModel);
            //}

            var result = new ProjectRecommendationsModel
            {
                Matches = userModels,
                TotalItems = userModels.Count
            };

            return result;
        }
    }
}