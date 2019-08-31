using System;
using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.BusinessLogic;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.DTOs
{
    public class Candidate : IComparable<Candidate>
    {
        public int Id { get; set; }

        public int DeliveryUnitId { get; set; }

        public DeliveryUnit DeliveryUnit { get; set; }

        public CandidateRelationType RelationType { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Name
        {
            get
            {
                return (this.FirstName + ", " + this.LastName);
            }
        }

        public DocumentType? DocType { get; set; }

        public string DocNumber { get; set; }

        public int? EmployeeNumber { get; set; }

        public bool InBench { get; set; }

        public string Picture { get; set; }

        public bool IsActive { get; set; }

        public CandidateGrade? Grade { get; set; }

        public string GradeDescription
        {
            get
            {
                if (!this.Grade.HasValue) { return (""); }

                return EnumHelper.GetEnumDescription(this.Grade.Value);
            }
        }

        public string GradeShortDescription
        {
            get
            {
                if (!this.Grade.HasValue) { return (""); }

                return EnumHelper.GetEnumShortDescription(this.Grade.Value);
            }
        }

        public int? CurrentProjectId { get; set; }

        public Project CurrentProject { get; set; }

        public DateTime? CurrentProjectJoin { get; set; }

        public string CurrentProjectDescription
        {
            get
            {
                if (this.RelationType != CandidateRelationType.Employee) { return (""); }

                if (this.InBench) { return ("Bench"); }

                if (this.CurrentProject == null) { return ("Unknown"); }

                return (this.CurrentProject.Name);
            }
        }

        public string CurrentProjectDuration
        {
            get
            {
                if (!this.CurrentProjectJoin.HasValue) { return (""); }

                var start = this.CurrentProjectJoin.Value;
                var today = DateTime.Today;

                TimeSpan difference = today - start;

                if (difference.Days < 90) { return ($"{difference.Days} days"); }

                if (difference.Days < (24 * 366))
                {
                    int months = (int)(difference.TotalDays / (365.25D / 12.0D));
                    return ($"{months} month{(months > 1 ? "s" : "")}");
                }

                int years = (int)(difference.TotalDays / 365.25D);
                return ($"{years} year{(years > 1 ? "s" : "")}");
            }
        }

        public List<Evaluation> Evaluations { get; set; }

        public List<CandidateRoleHistory> RolesHistory { get; set; }

        public CandidateRole ActiveRole
        {
            get
            {
                var crh = this.RolesHistory.FirstOrDefault(rh => !rh.End.HasValue);

                if (crh == null) { return (null); }

                return (crh.Role);
            }
        }

        public int CompareTo(Candidate other)
        {
            return (this.Name.CompareTo(other.Name));
        }
    }
}
