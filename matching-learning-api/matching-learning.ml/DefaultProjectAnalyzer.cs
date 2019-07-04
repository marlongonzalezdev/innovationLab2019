using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using matching_learning.ml.Domain;
using Microsoft.Extensions.Logging;
using Microsoft.ML;

namespace matching_learning.ml
{
    /// <summary>
    /// A dummy implementation of the IProjectAnalyzer whilst the actual one is implemented
    /// </summary>
    /// <seealso cref="matching_learning.ml.IProjectAnalyzer" />
    public class DefaultProjectAnalyzer : IProjectAnalyzer
    {
        private MLContext MLContext { get; set; }

        private ILogger Logger { get; set; }

        public DefaultProjectAnalyzer(ILogger logger)
        {
            MLContext = new MLContext();
            Logger = logger;
        }

        public Task<RecommendationResponse> GetRecommendationsAsync(RecommendationRequest recommendationRequest)
        {
            var predictionData = PredictValue(recommendationRequest);

            var candidates = predictionData.userData
                .Where(p => p.SelectedClusterId.Equals(predictionData.prediction.SelectedClusterId))
                .OrderByDescending(x => x.Distance[x.SelectedClusterId])
                .Select(Candidate.FromPrediction)
                .ToList();

            return Task.FromResult(new RecommendationResponse
            {
                Matches = candidates
            });
        }

        public (ClusteringPrediction[] userData, ClusteringPrediction prediction) PredictValue(RecommendationRequest recommendationRequest)
        {
            string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
            var inputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
            try
            {
                var data = MLContext.Data.LoadFromTextFile<SeedData>(
                   path: inputPath,
                   hasHeader: false,
                   separatorChar: ',');
                //training data, loading data from csv file data file in memory
                DataViewSchema modelSchema;

                // Load data preparation pipeline and trained model out dataPrepPipelineSchema);
                ITransformer trainedModel = MLContext.Model.Load(modelPath, out modelSchema);

                var transformedDataView = trainedModel.Transform(data);
                var predictionEngine = MLContext.Model.CreatePredictionEngine<SeedData, ClusteringPrediction>(trainedModel);
                var prediction = predictionEngine.Predict(ProcessRequest(recommendationRequest));

                ClusteringPrediction[] userData = MLContext.Data
                    .CreateEnumerable<ClusteringPrediction>(transformedDataView, false)
                    .ToArray();

                return (userData, prediction);
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

        public void TrainModelIfNotExists()
        {
            try
            {
                string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
                var inputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
                if (File.Exists(modelPath))
                {
                    Logger.LogInformation($"Trained model found at {inputPath}. Skipping training.");
                    return;
                }

             
                var trainingData = MLContext.Data.LoadFromTextFile<SeedData>(
                   path: inputPath,
                   hasHeader: false,
                   separatorChar: ',');
                var dataProcessPipeline = MLContext.Transforms.Concatenate("Features",
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
                .Append(MLContext.Clustering.Trainers.KMeans("Features", numberOfClusters: 15));
                var trainedModel = dataProcessPipeline.Fit(trainingData);

                // Save/persist the trained model to a .ZIP file
                MLContext.Model.Save(trainedModel, trainingData.Schema, modelPath);

                Logger.LogInformation($"The model was saved to {modelPath}");
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Model training operation failed.");
                throw;
            }
        }
    }
}