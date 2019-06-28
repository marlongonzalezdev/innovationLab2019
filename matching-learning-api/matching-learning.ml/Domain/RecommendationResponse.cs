using System.Collections.Generic;

namespace matching_learning.ml.Domain
{
    /// <summary>
    /// A class to hold the analysis response.
    /// </summary>
    public class RecommendationResponse
    {
        public IEnumerable<Candidate> Matches { get; set; }
    }
}
