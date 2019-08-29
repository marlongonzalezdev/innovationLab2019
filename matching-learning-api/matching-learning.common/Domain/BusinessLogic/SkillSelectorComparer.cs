using System;
using System.Collections.Generic;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.Enums;

namespace matching_learning.common.Domain.BusinessLogic
{
    public class SkillSelectorComparer : IComparer<Skill>
    {
        private int getSkillCategorySortIndex(SkillCategory sc)
        {
            switch (sc)
            {
                case SkillCategory.BusinessArea:
                    return 2;

                case SkillCategory.SoftSkill:
                    return 3;

                case SkillCategory.Technology:
                case SkillCategory.TechnologyRole:
                case SkillCategory.TechnologyVersion:
                    return 1;

                default:
                    throw new ArgumentOutOfRangeException($"Error: skill category {sc} is not supported.");

            }
        }

        public int Compare(Skill x, Skill y)
        {
            if (x == null || y == null)
            {
                return 0;
            }

            var xCatSortIndex = getSkillCategorySortIndex(x.Category);
            var yCatSortIndex = getSkillCategorySortIndex(y.Category);
            
            if (xCatSortIndex == yCatSortIndex)
            {
                return x.Name.CompareTo(y.Name);
            }

            return xCatSortIndex.CompareTo(yCatSortIndex);
        }
    }
}
