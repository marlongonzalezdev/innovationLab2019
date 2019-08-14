using System;
using System.Threading.Tasks;
using matching_learning.common.Repositories;
using matching_learning_algorithm.Domain;
using Microsoft.ML;
using Microsoft.Extensions.Logging;
using matching_learning.common.Domain.DTOs;
using System.Linq;

namespace matching_learning_algorithm
{
    public class ProjectAnalyzer : IProjectAnalyzer
    {
        private const int NumberOfClusters = 5;

        private readonly ISkillRepository _skillRepository;

        private MLContext MLContext { get; set; }

        private ILogger Logger { get; set; }
        public ProjectAnalyzer(ILogger logger, ISkillRepository skillRepository)
        {
            MLContext = new MLContext();
            Logger = logger;
            _skillRepository = skillRepository?? new SkillRepository();
        }
        public Task<RecommendationResponse> GetRecommendationsAsync(ProjectCandidateRequirement candidateRequirement)
        {
            throw new NotImplementedException();
        }
        private void GenerateDataset(ProjectCandidateRequirement candidateRequirement)
        {
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
            // todo: create local file for ml.net library
        }
    }
}
