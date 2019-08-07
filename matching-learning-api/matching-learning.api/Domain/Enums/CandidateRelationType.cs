using System.ComponentModel;

namespace matching_learning.api.Domain.Enums
{
    public enum CandidateRelationType
    {
        [Description("Employee")]
        Employee = 1,

        [Description("Candidate")]
        Candidate,

        [Description("External")]
        External,
    }
}
