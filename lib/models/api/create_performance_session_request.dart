class CreatePerformanceSessionRequest {
  final String exerciseId;
  final String? recordingUrl;

  CreatePerformanceSessionRequest({
    required this.exerciseId,
    this.recordingUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'recording_url': recordingUrl,
    };
  }
}