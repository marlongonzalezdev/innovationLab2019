using matching_learning.common.Domain.DTOs;
using System.ComponentModel.DataAnnotations;

namespace matching_learning.api.Models
{
    /// <summary>
    /// A model class to represent a skill.
    /// </summary>
    public class SkillModel
    {
        /// <summary>
        /// Gets or sets the tag.
        /// </summary>
        /// <value>
        /// The tag.
        /// </value>
        [Required]
        public string Tag { get; set; }

        /// <summary>
        /// Gets or sets the weight.
        /// </summary>
        /// <value>
        /// The weight.
        /// </value>
        [Range(0d, 1.0d)]
        public double Weight { get; set; }

        /// <summary>
        /// ToSkill.
        /// </summary>
        /// <returns></returns>
        public Skill ToSkill()
        {
            return new Skill
            {
                Code = Tag,
                DefaultExpertise = decimal.Parse(Weight.ToString())
            };
        }
    }
}