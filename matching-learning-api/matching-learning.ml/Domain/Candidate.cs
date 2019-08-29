namespace matching_learning.ml.Domain
{
    /// <summary>
    /// The candidate in the domain.
    /// </summary>
    public class Candidate
    {
        /// <summary>
        /// Gets or sets the user identifier.
        /// </summary>
        /// <value>
        /// The user identifier.
        /// </value>
        public string UserId { get; set; }

        public string Skills { get; set; }

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
        /// Gets or sets the score.
        /// </summary>
        /// <value>
        /// The score.
        /// </value>
        public double Score { get; set; }

        internal static Candidate FromPrediction(ClusteringPrediction cp)
        {
            return new Candidate
            {
                UserId = cp.UserId,
                Score = cp.Distance[cp.SelectedClusterId]
            };
        }
    }
}
