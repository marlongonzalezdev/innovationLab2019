using System;

namespace matching_learning.common.Domain.DTOs
{
    public class Evaluation : IComparable<Evaluation>
    {
        public int Id { get; set; }

        public int CandidateId { get; set; }

        public Candidate Candidate { get; set; }

        public int SkillId { get; set; }

        public Skill Skill { get; set; }

        public string EvaluationKey { get; set; }

        public int EvaluationTypeId { get; set; }

        public EvaluationType EvaluationType { get; set; }

        public DateTime Date { get; set; }

        public decimal Expertise { get; set; }

        public string Notes { get; set; }

        public int CompareTo(Evaluation other)
        {
            return (Date.CompareTo(other.Date));
        }
    }
}
