class PerformanceMetricsCreate {
  final double timestamp;
  final double intonationScore;
  final double rhythmScore;
  final double articulationScore;
  final double dynamicsScore;
  final Map<String, dynamic> rawMetrics;

  PerformanceMetricsCreate({
    required this.timestamp,
    required this.intonationScore,
    required this.rhythmScore,
    required this.articulationScore,
    required this.dynamicsScore,
    this.rawMetrics = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'intonation_score': intonationScore,
      'rhythm_score': rhythmScore,
      'articulation_score': articulationScore,
      'dynamics_score': dynamicsScore,
      'raw_metrics': rawMetrics,
    };
  }
}