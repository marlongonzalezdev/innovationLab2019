using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using matching_learning.ml.Domain;

namespace matching_learning.Models
{
    /// <summary>
    /// A model class to represent a Request to get Candidate recommendations for a given Project.
    /// </summary>
    public class ProjectCandidatesModel
    {
        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        /// <value>
        /// The name.
        /// </value>
        [Required]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the skills.
        /// </summary>
        /// <value>
        /// The skills.
        /// </value>
        [Required]
        public IList<SkillModel> Skills { get; set; }

        /// <summary>
        /// Converts to recommendation request.
        /// </summary>
        /// <returns></returns>
        public RecommendationRequest ToRecommendationRequest()
        {
            return new RecommendationRequest
            {
                ProjectName = Name,
                ProjectSkills = Skills.Select(s => s.ToSkill()).ToList()
            };
        }
    }
}
