using System;

namespace matching_learning.api.Domain.DTOs
{
    public class CandidateRoleHistory
    {
        public int Id { get; set; }

        public CandidateRole Role { get; set; }

        public DateTime Start { get; set; }

        public DateTime? End { get; set; }
    }
}
