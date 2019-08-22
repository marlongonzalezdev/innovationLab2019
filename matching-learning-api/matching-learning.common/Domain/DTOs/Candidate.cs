using System;
using System.Collections.Generic;
using System.Linq;
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
            return (Name.CompareTo(other.Name));
        }
    }
}
