class PerformanceMetrics {
  final String id;
  final String sessionId;
  final double timestamp;
  final double intonationScore;
  final double rhythmScore;
  final double articulationScore;
  final double dynamicsScore;
  final Map<String, dynamic> rawMetrics;
  final DateTime createdAt;

  PerformanceMetrics({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.intonationScore,
    required this.rhythmScore,
    required this.articulationScore,
    required this.dynamicsScore,
    this.rawMetrics = const {},
    required this.createdAt,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      id: json['id'],
      sessionId: json['session_id'],
      timestamp: json['timestamp'].toDouble(),
      intonationScore: json['intonation_score'].toDouble(),
      rhythmScore: json['rhythm_score'].toDouble(),
      articulationScore: json['articulation_score'].toDouble(),
      dynamicsScore: json['dynamics_score'].toDouble(),
      rawMetrics: Map<String, dynamic>.from(json['raw_metrics'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'timestamp': timestamp,
      'intonation_score': intonationScore,
      'rhythm_score': rhythmScore,
      'articulation_score': articulationScore,
      'dynamics_score': dynamicsScore,
      'raw_metrics': rawMetrics,
      'created_at': createdAt.toIso8601String(),
    };
  }
}