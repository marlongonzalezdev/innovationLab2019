using System.ComponentModel;

namespace matching_learning.common.Domain.Enums
{
    public enum CandidateGrade
    {
        [Description("Intern")] 
        IN = 1,

        [Description("Junior technician")]
        JT,
        
        [Description("Technician")]
        TL,
        
        [Description("Senior Technician")]
        ST,

        [Description("Engineer")]
        EN,

        [Description("Senior Engineer")]
        SE,

        [Description("Consultant")]
        CL,

        [Description("Senior Consultant")]
        SC,

        [Description("Manager")]
        ML,

        [Description("Senior Manager")]
        SM,

        [Description("Business Manager")]
        BM,

        [Description("Business Director")]
        BD,
        
        [Description("Director")]
        DR,
    }
}
