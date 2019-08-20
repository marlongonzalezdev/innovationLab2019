using System.ComponentModel.DataAnnotations;
using matching_learning.ml.Domain;

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
                Tag = Tag,
                Weight = Weight
            };
        }
    }
}