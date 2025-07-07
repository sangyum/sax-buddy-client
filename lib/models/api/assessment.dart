class Assessment {
  final String id;
  final String userId;
  final String sessionId;
  final Map<String, double> scores;
  final String? overallFeedback;
  final DateTime createdAt;

  Assessment({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.scores,
    this.overallFeedback,
    required this.createdAt,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      userId: json['user_id'],
      sessionId: json['session_id'],
      scores: Map<String, double>.from(json['scores']),
      overallFeedback: json['overall_feedback'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'session_id': sessionId,
      'scores': scores,
      'overall_feedback': overallFeedback,
      'created_at': createdAt.toIso8601String(),
    };
  }
}