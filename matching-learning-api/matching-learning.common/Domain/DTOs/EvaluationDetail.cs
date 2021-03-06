﻿using System;

namespace matching_learning.common.Domain.DTOs
{
    public class EvaluationDetail : IComparable<EvaluationDetail>
    {
        public int Id { get; set; }

        public int EvaluationId { get; set; }

        public int SkillId { get; set; }

        public Skill Skill { get; set; }
        
        public decimal Expertise { get; set; }
        
        public int CompareTo(EvaluationDetail other)
        {
            return (this.Skill.CompareTo(other.Skill));
        }
    }
}
