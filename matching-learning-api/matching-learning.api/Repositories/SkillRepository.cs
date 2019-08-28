using matching_learning.common.Domain.DTOs;
using System.Collections.Generic;

namespace matching_learning.api.Repositories
{
    /// <summary>
    /// Skills repository implementation
    /// </summary>
    public class SkillRepository: ISkillRepository
    {
        /// <summary>
        /// Get skill list 
        /// </summary>
        /// <returns></returns>
        public List<Skill> GetSkills()
        {
            return new List<Skill>();
        }
    }
}
