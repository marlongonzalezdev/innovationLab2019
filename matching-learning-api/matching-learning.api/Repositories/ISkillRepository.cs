using matching_learning.common.Domain.DTOs;
using System.Collections.Generic;

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
