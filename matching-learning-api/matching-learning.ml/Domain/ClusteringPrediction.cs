using Microsoft.ML.Data;

namespace matching_learning.ml.Domain
{
    public class ClusteringPrediction
    {
        [ColumnName("PredictedLabel")]
        public uint SelectedClusterId;

        [ColumnName("Score")]
        public float[] Distance;

        [ColumnName("Features")]
        public float[] Location;

        [ColumnName("user_id")]
        public string UserId;
    }
}
