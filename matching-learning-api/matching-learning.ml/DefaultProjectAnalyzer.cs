using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using matching_learning.ml.Domain;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Transforms;

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

        public DefaultProjectAnalyzer()
        {
            MLContext = new MLContext();
        }

        public Task<RecommendationResponse> GetRecommendationsAsync(RecommendationRequest recommendationRequest)
        {
            RecommendationModelTraining();
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

        private void RecommendationModelTraining()
        {
            var inputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
            var modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");

            try
            {
                //training data, loading data from csv file data file in memory

                var trainDataView = MLContext.Data.LoadFromTextFile("inputPath", 
                    columns: new[]
                    {
                        new TextLoader.Column("Features", DataKind.Single, new[] {new TextLoader.Range(0, 1440) }),
                        new TextLoader.Column(nameof(Candidate.UserId), DataKind.String, 0)
                    },
                    hasHeader: true,
                    separatorChar: ',');

                //Configure data transformations in pipeline
                var dataProcessPipeline = MLContext.Transforms.ProjectToPrincipalComponents(outputColumnName: "Score", inputColumnName: "Features", rank: 2)
                    .Append(MLContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "UserId", inputColumnName: nameof(Candidate.UserId), OneHotEncodingEstimator.OutputKind.Indicator));

                //Create the training pipeline
                var trainer = MLContext.Clustering.Trainers.KMeans(featureColumnName: "Features", numberOfClusters: 3);
                var trainingPipeline = dataProcessPipeline.Append(trainer);

                //Train the model fitting to the pivotDataView
                Console.WriteLine("=============== Training the model ===============");
                ITransformer trainedModel = trainingPipeline.Fit(trainDataView);

                //STEP 5: Evaluate the model and show accuracy stats
                Console.WriteLine("===== Evaluating Model's accuracy with Test data =====");
                var predictions = trainedModel.Transform(trainDataView);
                var metrics = MLContext.Clustering.Evaluate(predictions, scoreColumnName: "Score", featureColumnName: "Features");

                // Save/persist the trained model to a .ZIP file
                MLContext.Model.Save(trainedModel, trainDataView.Schema, modelPath);

                Console.WriteLine("The model is saved to {0}", modelPath);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}