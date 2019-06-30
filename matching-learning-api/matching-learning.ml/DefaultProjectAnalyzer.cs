﻿using System;
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
        private IDataView Predictions { get; set; }
        private ITransformer TrainedModel { get; set; }

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
            PredictModel(recommendationRequest);
            return Task.FromResult(new RecommendationResponse
            {
                Matches = candidates
            });
        }

        private void RecommendationModelTraining()
        {
            string inputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
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
                var dataProcessPipeline = MLContext.Transforms.ProjectToPrincipalComponents(outputColumnName: "Score", inputColumnName: "Skills", rank: 2)
                    .Append(MLContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "UserId", inputColumnName: nameof(Candidate.UserId), OneHotEncodingEstimator.OutputKind.Indicator));

                //Create the training pipeline
                var trainer = MLContext.Clustering.Trainers.KMeans(featureColumnName: "Skills", numberOfClusters: 3);
                var trainingPipeline = dataProcessPipeline.Append(trainer);

                //Train the model fitting to the pivotDataView
                Console.WriteLine("=============== Training the model ===============");
                TrainedModel = trainingPipeline.Fit(trainDataView);

                //STEP 5: Evaluate the model and show accuracy stats
                Console.WriteLine("===== Evaluating Model's accuracy with Test data =====");
                Predictions = TrainedModel.Transform(trainDataView);
                var metrics = MLContext.Clustering.Evaluate(Predictions, scoreColumnName: "Score", featureColumnName: "Skills");

                // Save/persist the trained model to a .ZIP file
                MLContext.Model.Save(TrainedModel, trainDataView.Schema, modelPath);

                Console.WriteLine("The model is saved to {0}", modelPath);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
        private List<Candidate> PredictModel(RecommendationRequest recommendationRequest)
        {
            var predictor = MLContext.Model.CreatePredictionEngine<ExpandoObject, ClusteringPrediction>(TrainedModel);
            var prediction = predictor.Predict((ExpandoObject)recommendationRequest);
            Console.WriteLine($"Cluster: {prediction.SelectedClusterId}");
            Console.WriteLine($"Distances: {string.Join(" ", prediction.Distance)}");
            //string csvLocation = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages-output.csv");
            //string plotLocation = Path.Combine(Environment.CurrentDirectory, "Data");
            //var clusters = MLContext.Data.CreateEnumerable<ClusteringPrediction>(Predictions, false)
            //               .ToArray();
            ////Generate data files with customer data grouped by clusters
            //SaveCustomerSegmentationCSV(clusters, csvLocation);

            ////Plot/paint the clusters in a chart and open it with the by-default image-tool in Windows
            //SaveCustomerSegmentationPlotChart(clusters, plotLocation);
            // OpenChartInDefaultWindow(_plotLocation);
            return null;
        }

        private static void SaveCustomerSegmentationCSV(IEnumerable<ClusteringPrediction> predictions, string csvlocation)
        {
            Console.WriteLine("CSV Customer Segmentation");
            using (var w = new System.IO.StreamWriter(csvlocation))
            {
                w.WriteLine($"LastName,SelectedClusterId");
                w.Flush();
                predictions.ToList().ForEach(prediction => {
                    w.WriteLine($"{prediction.UserId},{prediction.SelectedClusterId}");
                    w.Flush();
                });
            }

            Console.WriteLine($"CSV location: {csvlocation}");
        }

        private static void SaveCustomerSegmentationPlotChart(IEnumerable<ClusteringPrediction> predictions, string plotLocation)
        {
            Console.WriteLine("Plot Customer Segmentation");

            var plot = new PlotModel { Title = "Customer Segmentation", IsLegendVisible = true };

            var clusters = predictions.Select(p => p.SelectedClusterId).Distinct().OrderBy(x => x);

            foreach (var cluster in clusters)
            {
                var scatter = new ScatterSeries { MarkerType = MarkerType.Circle, MarkerStrokeThickness = 2, Title = $"Cluster: {cluster}", RenderInLegend = true };
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

            Console.WriteLine($"Plot location: {plotLocation}");
        }

        private static void OpenChartInDefaultWindow(string plotLocation)
        {
            Console.WriteLine("Showing chart...");
            var p = new Process();
            p.StartInfo = new ProcessStartInfo(plotLocation)
            {
                UseShellExecute = true
            };
            p.Start();
        }
    }
}