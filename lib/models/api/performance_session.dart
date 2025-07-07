class PerformanceSession {
  final String id;
  final String userId;
  final String? exerciseId;
  final DateTime startTime;
  final DateTime? endTime;
  final Map<String, double>? metrics;
  final String? recordingUrl;
  final String? feedback;

  PerformanceSession({
    required this.id,
    required this.userId,
    this.exerciseId,
    required this.startTime,
    this.endTime,
    this.metrics,
    this.recordingUrl,
    this.feedback,
  });

  factory PerformanceSession.fromJson(Map<String, dynamic> json) {
    return PerformanceSession(
      id: json['id'],
      userId: json['user_id'],
      exerciseId: json['exercise_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      metrics: json['metrics'] != null ? Map<String, double>.from(json['metrics']) : null,
      recordingUrl: json['recording_url'],
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'metrics': metrics,
      'recording_url': recordingUrl,
      'feedback': feedback,
    };
  }
}