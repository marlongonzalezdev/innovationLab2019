using System.Collections.Generic;

namespace matching_learning_algorithm.Domain
{
    public class RecommendationResponse
    {
        public IEnumerable<string> Matches { get; set; }
    }
}
