using System.Threading.Tasks;
using matching_learning.ml.Domain;

namespace matching_learning.ml
{
    /// <summary>
    /// A contract for the ML Project Analyzer component.
    /// </summary>
    public interface IProjectAnalyzer
    {
        Task<RecommendationResponse> GetRecommendationsAsync(RecommendationRequest recommendationRequest);
    }
}
