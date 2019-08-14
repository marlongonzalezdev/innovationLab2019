using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using matching_learning.ml.Domain;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
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
        private const int NumberOfClusters = 5;

        // private readonly ISkillRepository _skillRepository;

        private MLContext MLContext { get; set; }

        private ILogger Logger { get; set; }

        public DefaultProjectAnalyzer(ILogger logger)
        {
            MLContext = new MLContext();
            Logger = logger;
            // _skillRepository = new SkillRepository();
        }

        public Task<RecommendationResponse> GetRecommendationsAsync(RecommendationRequest recommendationRequest)
        {
            var predictionData = PredictValue(recommendationRequest);

            var candidates = predictionData.userData
                .Where(p => p.SelectedClusterId.Equals(predictionData.prediction.SelectedClusterId))
                .OrderBy(x => x.Distance[x.SelectedClusterId])
                .Select(Candidate.FromPrediction)
                .ToList();

            return Task.FromResult(new RecommendationResponse
            {
                Matches = candidates
            });
        }

        private (ClusteringPrediction[] userData, ClusteringPrediction prediction) PredictValue(RecommendationRequest recommendationRequest)
        {
            string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
            var inputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
            try
            {
                var data = MLContext.Data.LoadFromTextFile<SeedData>(
                   path: inputPath,
                   hasHeader: true,
                   separatorChar: ',');
                
                // Load data preparation pipeline and trained model out dataPrepPipelineSchema);
                ITransformer trainedModel = MLContext.Model.Load(modelPath, out var modelSchema);

                var transformedDataView = trainedModel.Transform(data);
                var predictionEngine = MLContext.Model.CreatePredictionEngine<SeedData, ClusteringPrediction>(trainedModel);
                var prediction = predictionEngine.Predict(ProcessRequest(recommendationRequest));

                ClusteringPrediction[] userData = MLContext.Data
                    .CreateEnumerable<ClusteringPrediction>(transformedDataView, false)
                    .ToArray();

                //Plot/paint the clusters in a chart and open it with the by-default image-tool in Windows
                //var plotLocation = Path.Combine(Directory.GetParent(modelPath).FullName, "userskillclusters.svg");
                //SaveSegmentationPlotChart(userData, plotLocation);

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
                   hasHeader: true,
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
                .Append(MLContext.Clustering.Trainers.KMeans(
                    "Features", 
                    numberOfClusters: NumberOfClusters));
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

        
        private void SaveSegmentationPlotChart(IEnumerable<ClusteringPrediction> predictions, string plotLocation)
        {
            var plot = new PlotModel { Title = "User Skill Clusters", IsLegendVisible = true };
            var clusters = predictions
                .Select(p => p.SelectedClusterId)
                .Distinct()
                .OrderBy(x => x);

            foreach (var cluster in clusters)
            {
                var scatter = new ScatterSeries
                {
                    MarkerType = MarkerType.Circle,
                    MarkerStrokeThickness = 2,
                    Title = $"Cluster: {cluster}",
                    RenderInLegend = true
                };
                var series = predictions
                    .Where(p => p.SelectedClusterId == cluster)
                    .Select(p => new ScatterPoint(p.Location[0], p.Location[1])).ToArray();
                scatter.Points.AddRange(series);
                plot.Series.Add(scatter);
            }

            plot.DefaultColors = OxyPalettes.HueDistinct(plot.Series.Count).Colors;

            var exporter = new SvgExporter { Width = 600, Height = 400 };
            using (var fs = new FileStream(plotLocation, FileMode.Create))
            {
                exporter.Export(plot, fs);
            }

            Logger.LogInformation($"Plot location: {plotLocation}");
        }
    }
}