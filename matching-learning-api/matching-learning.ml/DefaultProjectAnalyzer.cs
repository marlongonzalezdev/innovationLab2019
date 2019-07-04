using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using matching_learning.ml.Domain;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Transforms;
using OxyPlot;
using OxyPlot.Series;

namespace matching_learning.ml
{
    /// <summary>
    /// A dummy implementation of the IProjectAnalyzer whilst the actual one is implemented
    /// </summary>
    /// <seealso cref="matching_learning.ml.IProjectAnalyzer" />
    public class DefaultProjectAnalyzer : IProjectAnalyzer
    {
        private readonly Random _random = new Random(Environment.TickCount);
        private MLContext MLContext { get; set; }
        private ILogger Logger { get; set; }

        public DefaultProjectAnalyzer(ILogger logger)
        {
            MLContext = new MLContext();
            Logger = logger;
        }

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
            RecommendationModelTraining(recommendationRequest);
            return Task.FromResult(new RecommendationResponse
            {
                Matches = candidates
            });
        }

        public void RecommendationModelTraining(RecommendationRequest recommendationRequest)
        {
            string inputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
            string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");

            try
            {
                //training data, loading data from csv file data file in memory

                var trainingData = MLContext.Data.LoadFromTextFile<SeedData>(
                    path: inputPath,
                    hasHeader: false,
                    separatorChar: ',');
                var dataProcessPipeline = MLContext.Transforms.Concatenate("Skills",
                        "assembly",
                        "csharp",
                        "c",
                        "cpp",
                        "css",
                        "html",
                        "go",
                        "java",
                        "javascript",
                        "php",
                        "powershell",
                        "python",
                        "ruby",
                        "typescript",
                        "algorithm",
                        "android",
                        "angular",
                        "angularjs",
                        "aws",
                        "bitcoin",
                        "bootstrap",
                        "bootstrap4",
                        "clean_architecture",
                        "cloud",
                        "collaboration",
                        "cryptocurrency",
                        "cryptography",
                        "data_science",
                        "database",
                        "deep_learning",
                        "design_patterns",
                        "desktop",
                        "dev_ops",
                        "django",
                        "docker",
                        "dotnetcore",
                        "elasticsearch",
                        "frontend",
                        "git",
                        "graphql",
                        "html5",
                        "http2",
                        "ionic",
                        "ios",
                        "jquery",
                        "json",
                        "linux",
                        "mongodb",
                        "mysql",
                        "nodejs",
                        "postgresql",
                        "reactjs",
                        "redis")
                .Append(MLContext.Clustering.Trainers.KMeans("Skills", numberOfClusters: 3));
                var trainedModel = dataProcessPipeline.Fit(trainingData);
                var predictor = MLContext.Model.CreatePredictionEngine<SeedData, ClusteringPrediction>(trainedModel);
                var prediction = predictor.Predict(ProcessRequest(recommendationRequest));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private SeedData ProcessRequest(RecommendationRequest recommendationRequest)
        {
            var seedData = new SeedData();
            foreach (var skill in recommendationRequest.ProjectSkills)
            {
                var propertyInfo = seedData.GetType().GetProperty(skill.Tag.ToLower());
                propertyInfo.SetValue(seedData, Convert.ChangeType(skill.Weight, propertyInfo.PropertyType), null);
            }
            return seedData;
        }

    }
}