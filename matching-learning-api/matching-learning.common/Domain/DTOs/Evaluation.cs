using System;
using System.Collections.Generic;

namespace matching_learning.common.Domain.DTOs
{
    public class Evaluation : IComparable<Evaluation>
    {
        public int Id { get; set; }

        public int CandidateId { get; set; }

        public string EvaluationKey { get; set; }

        public int EvaluationTypeId { get; set; }

        public EvaluationType EvaluationType { get; set; }

        public DateTime Date { get; set; }
        
        public string Notes { get; set; }

        public List<EvaluationDetail> Details { get; set; }

        public int CompareTo(Evaluation other)
        {
            return (-1 * Date.CompareTo(other.Date));
        }
    }
}
