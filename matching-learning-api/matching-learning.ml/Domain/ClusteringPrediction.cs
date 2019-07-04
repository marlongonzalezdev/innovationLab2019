using Microsoft.ML.Data;

namespace matching_learning.ml.Domain
{
    public class ClusteringPrediction
    {
        [ColumnName("PredictedLabel")]
        public uint SelectedClusterId;
        [ColumnName("Score")]
        public float[] Distance;
        [ColumnName("Skills")]
        public float[] Location;
        [ColumnName("UserId")]
        public string UserId;
    }
}
