using System.ComponentModel;

namespace matching_learning.common.Domain.Enums
{
    public enum DocumentType
    {
        [Description("National Identity")]
        NationalIdentity = 1,

        [Description("Passport")]
        Passport,
    }
}
