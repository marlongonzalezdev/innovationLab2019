using System;
using System.Threading.Tasks;
using matching_learning.common.Repositories;
using matching_learning_algorithm.Domain;
using Microsoft.ML;
using Microsoft.Extensions.Logging;
using matching_learning.common.Domain.DTOs;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using Microsoft.ML.Data;
using System.Dynamic;
using Microsoft.ML.Trainers;

namespace matching_learning_algorithm
{
    public class ProjectAnalyzer : IProjectAnalyzer
    {
        private const int NumberOfClusters = 3;

        private readonly ISkillRepository _skillRepository;

        private MLContext MLContext { get; set; }

        private ILogger Logger { get; set; }

        private string InputPath { get; set; }

        private List<TextLoader.Column> TexLoaderFields { get; set; }

        private List<string> CsvHeaders { get; set; }
        public ProjectAnalyzer(ILogger logger, ISkillRepository skillRepository)
        {
            MLContext = new MLContext(seed: 1);
            Logger = logger;
            _skillRepository = skillRepository ?? new SkillRepository();
            CsvHeaders = new List<string>();
            TexLoaderFields = new List<TextLoader.Column>();
            InputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
        }


        public Task<RecommendationResponse> GetRecommendationsAsync(ProjectCandidateRequirement candidateRequirement, bool createDataSet)
        {
            if (createDataSet) GenerateDataset();

            var predictionData = PredictValue(candidateRequirement);

            return Task.FromResult(new RecommendationResponse
            {
                Matches = predictionData
            });
        }
        private void GenerateDataset()
        {
            var estimatedExpertises = _skillRepository.GetSkillEstimatedExpertise();
            CsvHeaders.Add("candidateId");
            CsvHeaders.AddRange(estimatedExpertises.Select(exp => exp.Skill.Name).Distinct().ToList());
            using (var file = File.CreateText(InputPath))
            {
                file.WriteLine(string.Join(',', CsvHeaders));
                var resultByCandidate = estimatedExpertises.GroupBy(exp => exp.Candidate.Id, exp => new { Name = exp.Skill.Name, Expertise = exp.Expertise });
                foreach (var candidate in resultByCandidate)
                {
                    var row = new List<string>();
                    row.Add(candidate.Key.ToString());
                    foreach (var header in CsvHeaders)
                    {
                        row.Add(
                            (candidate.ToList().FirstOrDefault(c => c.Name.Equals(header))?.Expertise != null) ?
                                candidate.ToList().FirstOrDefault(c => c.Name.Equals(header))?.Expertise.ToString()
                                : "0"
                            );
                    }
                    file.WriteLine(string.Join(',', row));
                }
            }
        }

        public void TrainModelIfNotExists()
        {
            try
            {
                GenerateDataset();
                string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
                if (File.Exists(modelPath))
                {
                    Logger.LogInformation($"Trained model found at {InputPath}. Skipping training.");
                    return;
                }
                
                var result = GenerateNames();
                var textLoader = MLContext.Data.CreateTextLoader(result.Item1, hasHeader: true, separatorChar: ',');
                var data = textLoader.Load(InputPath);
                DataOperationsCatalog.TrainTestData trainTestData = MLContext.Data.TrainTestSplit(data, testFraction: 0.2);
                var trainingDataView = trainTestData.TrainSet;
                var testingDataView = trainTestData.TestSet;

                var options = new KMeansTrainer.Options
                {
                    NumberOfClusters = 3,
                    OptimizationTolerance = 1e-6f,
                    NumberOfThreads = 1,
                    MaximumNumberOfIterations = 20,
                    FeatureColumnName = "Features"
                };

                var dataProcessPipeline = MLContext
                    .Transforms
                    .Concatenate("Features", result.Item2)
                    .Append(MLContext.Clustering.Trainers.KMeans(options));
                var trainedModel = dataProcessPipeline.Fit(trainingDataView);

                IDataView predictions = trainedModel.Transform(testingDataView);
                var metrics = MLContext.Clustering.Evaluate(predictions, scoreColumnName: "Score", featureColumnName: "Features");

                // Save/persist the trained model to a .ZIP file
                MLContext.Model.Save(trainedModel, data.Schema, modelPath);

                Logger.LogInformation($"The model was saved to {modelPath}");

            }
            catch (Exception ex)
            {
                Logger.LogError(ex, "Model training operation failed.");
                throw;
            }

        }

        private Dictionary<int, float> PredictValue(ProjectCandidateRequirement candidateRequirement)
        {
            string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
            try
            {
                var result = GenerateNames();
                var textLoader = MLContext.Data.CreateTextLoader(result.Item1, hasHeader: true, separatorChar: ',');
                var data = textLoader.Load(InputPath);
                var responseValues = new Dictionary<int, float>();

                ITransformer trainedModel = MLContext.Model.Load(modelPath, out var modelSchema);

                var transformedDataView = trainedModel.Transform(data);
                var predictionEngine = MLContext.Model.CreatePredictionEngine<DataModel, ClusteringPrediction>(trainedModel);
                var prediction = predictionEngine.Predict(ProcessRequest(candidateRequirement));

                ClusteringPrediction[] userData = MLContext.Data
                    .CreateEnumerable<ClusteringPrediction>(transformedDataView, false)
                    .ToArray();

                userData = userData
                    .Where(u => u.SelectedClusterId == prediction.SelectedClusterId)
                    .OrderBy(x => x.Distance[prediction.SelectedClusterId - 1])
                    .ToArray();
                foreach(var u in userData)
                {
                    responseValues.Add(int.Parse(u.CandidateId), u.Distance[u.SelectedClusterId - 1]);
                }
                                
                return responseValues;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private DataModel ProcessRequest(ProjectCandidateRequirement candidateRequirement)
        {
            var skills = _skillRepository.GetSkills();
            var dataModel = new DataModel();
            if (CsvHeaders.Count == 0)
            {
                var estimatedExpertises = _skillRepository.GetSkillEstimatedExpertise();
                CsvHeaders.Add("candidateId");
                CsvHeaders.AddRange(estimatedExpertises.Select(exp => exp.Skill.Name).Distinct().ToList());
            }
            foreach (var skill in candidateRequirement.SkillsFilter)
            {
                var skillInfo = skills.FirstOrDefault(s => s.Id == skill.RequiredSkillId);
                if (skillInfo != null)
                {
                    var index = CsvHeaders.IndexOf(skillInfo.Name);
                    if (index > -1)
                    {
                        index += 1;
                        var fieldInfo = dataModel.GetType().GetField("attr" + index);
                        fieldInfo.SetValue(dataModel, Convert.ChangeType(skill.Weight, fieldInfo.FieldType));
                    }
                }
            }
            return dataModel;
        }

        private (TextLoader.Column[], string[]) GenerateNames()
        {
            var columns = new List<TextLoader.Column>();
            columns.Add(new TextLoader.Column("candidateId", DataKind.String, 0));
            var names = new List<string>();
            for (var i = 1; i <= 150; i++)
            {
                columns.Add(new TextLoader.Column("attr" + i, DataKind.Single, i));
                names.Add("attr" + i);
            }
            return (columns.ToArray(), names.ToArray());
        }
    }
}
