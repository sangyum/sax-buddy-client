class PerformanceSessionCreate {
  final String userId;
  final String exerciseId;

  PerformanceSessionCreate({
    required this.userId,
    required this.exerciseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'exercise_id': exerciseId,
    };
  }
}