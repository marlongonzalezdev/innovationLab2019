using System.Collections.Generic;
using matching_learning.ml.Domain;

namespace matching_learning.api.Repositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface ISkillRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        List<Skill> GetSkills();
    }
}
