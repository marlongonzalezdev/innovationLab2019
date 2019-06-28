using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using matching_learning.ml.Domain;

namespace matching_learning.ml
{
    /// <summary>
    /// A dummy implementation of the IProjectAnalyzer whilst the actual one is implemented
    /// </summary>
    /// <seealso cref="matching_learning.ml.IProjectAnalyzer" />
    public class DefaultProjectAnalyzer : IProjectAnalyzer
    {
        private readonly Random _random = new Random(Environment.TickCount);

        public Task<RecommendationResponse> GetRecommendationsAsync(RecommendationRequest recommendationRequest)
        {
            var candidates = new List<Candidate>
                {
                    new Candidate
                    {
                        UserId = "mgonzalez",
                        Name = "Marlon",
                        LastName = "González",
                        Score = _random.NextDouble()
                    },
                    new Candidate
                    {
                        UserId = "yvaldes",
                        Name = "Yanara",
                        LastName = "Valdes",
                        Score = _random.NextDouble()
                    },
                    new Candidate
                    {
                        UserId = "dalvarez",
                        Name = "Delia",
                        LastName = "Álvarez",
                        Score = _random.NextDouble()
                    },
                    new Candidate
                    {
                        UserId = "wclaro",
                        Name = "Willian",
                        LastName = "Claro",
                        Score = _random.NextDouble()
                    },
                    new Candidate
                    {
                        UserId = "ktamayo",
                        Name = "Karel",
                        LastName = "Tamayo",
                        Score = _random.NextDouble()
                    }
                }
                .OrderByDescending(x => x.Score);

            return Task.FromResult(new RecommendationResponse
            {
                Matches = candidates
            });
        }
    }
}