using System.Collections.Generic;

namespace matching_learning.Models
{
    /// <summary>
    /// A model to represent the recommendations for a given project.
    /// </summary>
    public class ProjectRecommendationsModel
    {
        /// <summary>
        /// Gets or sets the matches.
        /// </summary>
        /// <value>
        /// The matches.
        /// </value>
        public IList<CandidateModel> Matches { get; set; }
    }
}