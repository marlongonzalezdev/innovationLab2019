using matching_learning.common.Domain.DTOs;
using matching_learning_algorithm.Domain;
using System.Threading.Tasks;

namespace matching_learning_algorithm
{
    public interface IProjectAnalyzer
    {
        Task<RecommendationResponse> GetRecommendationsAsync(ProjectCandidateRequirement candidateRequirement);
    }
}
