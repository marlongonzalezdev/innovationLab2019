using System.Collections.Generic;

namespace matching_learning.common.Domain.DTOs
{
    public class CandidateEvaluations
    {
        public Candidate Candidate { get; set; }

        public List<Evaluation> Evaluations { get; set; }
    }
}
