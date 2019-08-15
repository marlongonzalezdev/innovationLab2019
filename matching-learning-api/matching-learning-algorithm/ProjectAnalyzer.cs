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

namespace matching_learning_algorithm
{
    public class ProjectAnalyzer : IProjectAnalyzer
    {
        private const int NumberOfClusters = 5;

        private readonly ISkillRepository _skillRepository;

        private MLContext MLContext { get; set; }

        private ILogger Logger { get; set; }

        private string InputPath { get; set; }

        private List<string> CsvHeaders { get; set; }
        public ProjectAnalyzer(ILogger logger, ISkillRepository skillRepository)
        {
            MLContext = new MLContext();
            Logger = logger;
            _skillRepository = skillRepository ?? new SkillRepository();
            CsvHeaders = new List<string>();
        }
        public Task<RecommendationResponse> GetRecommendationsAsync(ProjectCandidateRequirement candidateRequirement)
        {
            throw new NotImplementedException();
        }

        public Task<RecommendationResponse> GetRecommendationsAsync(ProjectCandidateRequirement candidateRequirement)
        {
            var predictionData = PredictValue(candidateRequirement);

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
        private void GenerateDataset(ProjectCandidateRequirement candidateRequirement)
        {
            InputPath = Path.Combine(Environment.CurrentDirectory, "Data", "user-languages.csv");
            var estimatedExpertises = _skillRepository.GetSkillEstimatedExpertisesBySkillIds(
                candidateRequirement
                .SkillsFilter
                .Select(requirement => requirement.RequiredSkillId)
                .ToList()
                );
            if (candidateRequirement.DeliveryUnitIdFilter != null)
            {
                estimatedExpertises = estimatedExpertises.Where(exp => exp.Candidate.DeliveryUnitId == candidateRequirement.DeliveryUnitIdFilter).ToList();
            }
            if (candidateRequirement.InBenchFilter != null)
            {
                estimatedExpertises = estimatedExpertises.Where(exp => exp.Candidate.InBench == candidateRequirement.InBenchFilter).ToList();
            }
            CsvHeaders.Add("candidateId");
            CsvHeaders.AddRange(estimatedExpertises.Select(exp => exp.Skill.Name).ToList());
            using (var file = File.CreateText(InputPath))
            {
                file.WriteLine(string.Join(',', CsvHeaders));
                var resultByCandidate = estimatedExpertises.GroupBy(exp => exp.Candidate.Id, exp => new { Name = exp.Skill.Name, Expertise = exp.Expertise });
                foreach (var candidate in resultByCandidate)
                {
                    var row = new List<string>();
                    row.Add(candidate.ToString());
                    foreach (var header in CsvHeaders)
                    {
                        row.Add(
                            (candidate.ToList().FirstOrDefault(c => c.Name.Equals(header))?.Expertise != null) ?
                                candidate.ToList().FirstOrDefault(c => c.Name.Equals(header))?.Expertise.ToString()
                                : "0"
                            );
                    }

                }
            }
        }

        public void TrainModelIfNotExists()
        {
            try
            {
                string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
                if (File.Exists(modelPath))
                {
                    Logger.LogInformation($"Trained model found at {inputPath}. Skipping training.");
                    return;
                }
                var texLoaderFields = CsvHeaders.Where(header => !header.Equals("candidateId")).Select(
                    (text, index) => new TextLoader.Column(text, DataKind.Single, index)
                    ).ToList();
                var textLoader = context.Data.CreateTextLoader(textLoaderFields, hasHeader: true, separatorChar: ',');
                IDataView data = textLoader.Load(InputPath);
                var dataProcessPipeline = MLContext.Transforms.Concatenate("Features", CsvHeaders.Where(header => !header.Equals("candidateId")).ToArray())
                .Append(MLContext.Clustering.Trainers.KMeans(
                    "Features",
                    numberOfClusters: NumberOfClusters));
                var trainedModel = dataProcessPipeline.Fit(trainingData);

                // Save/persist the trained model to a .ZIP file
                MLContext.Model.Save(trainedModel, trainingData.Schema, modelPath);

                Logger.LogInformation($"The model was saved to {modelPath}");

            }
            catch (Exception ex)
            {
                Logger.LogError(ex, "Model training operation failed.");
                throw;
            }

        }
        private (ClusteringPrediction[] userData, ClusteringPrediction prediction) PredictValue(ProjectCandidateRequirement candidateRequirement)
        {
            string modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "trainedModel.zip");
            try
            {
                var data = MLContext.Data.LoadFromTextFile<ExpandoObject>(
                   path: InputPath,
                   hasHeader: true,
                   separatorChar: ',');

                // Load data preparation pipeline and trained model out dataPrepPipelineSchema);
                ITransformer trainedModel = MLContext.Model.Load(modelPath, out var modelSchema);

                var transformedDataView = trainedModel.Transform(data);
                var predictionEngine = MLContext.Model.CreatePredictionEngine<ExpandoObject, ClusteringPrediction>(trainedModel);
                var prediction = predictionEngine.Predict(ProcessRequest(recommendationRequest));

                ClusteringPrediction[] userData = MLContext.Data
                    .CreateEnumerable<ClusteringPrediction>(transformedDataView, false)
                    .ToArray();
                if (candidateRequirement.Max != null)
                {
                    userData = userData.Take(candidateRequirement.Max);
                }

                return (userData, prediction);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
