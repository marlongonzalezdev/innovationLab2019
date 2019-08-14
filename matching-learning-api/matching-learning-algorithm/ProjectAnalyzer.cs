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
        public ProjectAnalyzer(ILogger logger, ISkillRepository skillRepository)
        {
            MLContext = new MLContext();
            Logger = logger;
            _skillRepository = skillRepository ?? new SkillRepository();
        }
        public Task<RecommendationResponse> GetRecommendationsAsync(ProjectCandidateRequirement candidateRequirement)
        {
            throw new NotImplementedException();
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
            var csvHeaders = new List<string>();
            csvHeaders.Add("candidateId");
            csvHeaders.AddRange(estimatedExpertises.Select(exp => exp.Skill.Name).ToList());
            using (var file = File.CreateText(InputPath))
            {
                file.WriteLine(string.Join(',', csvHeaders));
                var resultByCandidate = estimatedExpertises.GroupBy(exp => exp.Candidate.Id, exp => new { Name = exp.Skill.Name, Expertise = exp.Expertise });
                foreach (var candidate in resultByCandidate)
                {
                    var row = new List<string>();
                    row.Add(candidate.ToString());
                    foreach (var header in csvHeaders)
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
           }
}
