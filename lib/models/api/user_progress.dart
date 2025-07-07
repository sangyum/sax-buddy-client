class UserProgress {
  final String id;
  final String userId;
  final double intonationScore;
  final double rhythmScore;
  final double articulationScore;
  final double dynamicsScore;
  final double overallScore;
  final int sessionsCount;
  final int totalPracticeMinutes;
  final DateTime? lastFormalAssessmentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.intonationScore,
    required this.rhythmScore,
    required this.articulationScore,
    required this.dynamicsScore,
    required this.overallScore,
    required this.sessionsCount,
    required this.totalPracticeMinutes,
    this.lastFormalAssessmentDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'],
      userId: json['user_id'],
      intonationScore: json['intonation_score'].toDouble(),
      rhythmScore: json['rhythm_score'].toDouble(),
      articulationScore: json['articulation_score'].toDouble(),
      dynamicsScore: json['dynamics_score'].toDouble(),
      overallScore: json['overall_score'].toDouble(),
      sessionsCount: json['sessions_count'],
      totalPracticeMinutes: json['total_practice_minutes'],
      lastFormalAssessmentDate: json['last_formal_assessment_date'] != null
          ? DateTime.parse(json['last_formal_assessment_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'intonation_score': intonationScore,
      'rhythm_score': rhythmScore,
      'articulation_score': articulationScore,
      'dynamics_score': dynamicsScore,
      'overall_score': overallScore,
      'sessions_count': sessionsCount,
      'total_practice_minutes': totalPracticeMinutes,
      'last_formal_assessment_date': lastFormalAssessmentDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}