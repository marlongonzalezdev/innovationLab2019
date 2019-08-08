﻿using System.Collections.Generic;
using matching_learning.api.Domain.DTOs;

namespace matching_learning.api.Repositories.Common
{
    public interface ISkillRepository
    {
        List<Skill> GetSkills();
    }
}
