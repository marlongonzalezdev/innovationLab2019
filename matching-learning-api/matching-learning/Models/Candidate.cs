namespace matching_learning.Models
{
    /// <summary>
    /// A model to represent a Candidate
    /// </summary>
    public class CandidateModel
    {
        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>
        /// The name of the user.
        /// </value>
        public string UserName { get; set; }

        /// <summary>
        /// Gets or sets the photo URL.
        /// </summary>
        /// <value>
        /// The photo URL.
        /// </value>
        public string PhotoUrl { get; set; }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        /// <value>
        /// The name.
        /// </value>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the last name.
        /// </summary>
        /// <value>
        /// The last name.
        /// </value>
        public string LastName { get; set; }

        /// <summary>
        /// Gets or sets the matching score.
        /// </summary>
        /// <value>
        /// The matching score.
        /// </value>
        public double MatchingScore { get; set; }
    }
}