using System;
using System.Collections.Generic;
using System.Dynamic;
using matching_learning.ml.Domain;

namespace matching_learning.ml.Domain
{
    public class RecommendationRequest
    {
        /// <summary>
        /// Gets or sets the name of the project.
        /// </summary>
        /// <value>
        /// The name of the project.
        /// </value>
        public string ProjectName { get; set; }

        /// <summary>
        /// Gets or sets the project skills.
        /// </summary>
        /// <value>
        /// The project skills.
        /// </value>
        public IList<Skill> ProjectSkills { get; set; }

        public static explicit operator ExpandoObject(RecommendationRequest v)
        {
            throw new NotImplementedException();
        }
    }
}
