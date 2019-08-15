using System;
using System.Collections.Generic;
using System.Text;

namespace matching_learning_algorithm.Domain
{
    public class ClusteringPrediction
    {
            [ColumnName("PredictedLabel")]
            public uint SelectedClusterId;

            [ColumnName("Score")]
            public float[] Distance;

            [ColumnName("Features")]
            public float[] Location;

            [ColumnName("candidateId")]
            public string CandidateId;
    }
}
