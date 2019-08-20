using matching_learning.common.Domain.DTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace matching_learning_algorithm.Domain
{
    public class RecommendationResponse
    {
        public IEnumerable<string> Matches { get; set; }
    }
}
