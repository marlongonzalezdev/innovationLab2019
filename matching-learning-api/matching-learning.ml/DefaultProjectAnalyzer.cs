using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using matching_learning.ml.Domain;
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

        public DefaultProjectAnalyzer()
        {
            MLContext = new MLContext();
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
            var modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");

            try
            {
                //training data, loading data from csv file data file in memory

                var trainDataView = MLContext.Data.LoadFromTextFile(inputPath,
                    columns: new[]
                    {
                        new TextLoader.Column("Skills", DataKind.Single, new[] {new TextLoader.Range(0, 1440) }),
                        new TextLoader.Column(nameof(Candidate.UserId), DataKind.String, 0)
                    },
                    hasHeader: true,
                    separatorChar: ',');

                //Configure data transformations in pipeline
                var dataProcessPipeline = MLContext.Transforms.ProjectToPrincipalComponents(outputColumnName: "Score", inputColumnName: "Skills", rank: 2)
                    .Append(MLContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "UserId", inputColumnName: nameof(Candidate.UserId), OneHotEncodingEstimator.OutputKind.Indicator));

                //Create the training pipeline
                var trainer = MLContext.Clustering.Trainers.KMeans(featureColumnName: "Skills", numberOfClusters: 3);
                var trainingPipeline = dataProcessPipeline.Append(trainer);

                //Train the model fitting to the pivotDataView
                var trainedModel = trainingPipeline.Fit(trainDataView);


                //STEP 5: Evaluate the model and show accuracy stats
                var predictions = trainedModel.Transform(trainDataView);
                var metrics = MLContext.Clustering.Evaluate(predictions, scoreColumnName: "Score", featureColumnName: "Skills");

                // Save/persist the trained model to a .ZIP file
                MLContext.Model.Save(trainedModel, trainDataView.Schema, modelPath);
                // predict cluster for request
                var predictor = MLContext.Model.CreatePredictionEngine<SeedData, ClusteringPrediction>(trainedModel);
                var prediction = predictor.Predict(ProcessRequest(recommendationRequest));
                // trying to read prediction members (selected cluster id)
                ITransformer selectedCluster = trainedModel.ElementAt((int)prediction.SelectedClusterId);

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
                var seedType = seedData.GetType().GetProperty(skill.Tag, System.Reflection.BindingFlags.Public);
                seedType.SetValue(seedData, skill.Weight);
            }
            return seedData;
        }

    }
}