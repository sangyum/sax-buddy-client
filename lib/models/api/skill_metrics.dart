import 'skill_level_enum.dart';

class SkillMetrics {
  final String id;
  final String userId;
  final SkillLevelEnum skillLevel;
  final double intonationScore;
  final double rhythmScore;
  final double articulationScore;
  final double dynamicsScore;
  final double overallScore;
  final int totalSessions;
  final DateTime calculatedAt;

  SkillMetrics({
    required this.id,
    required this.userId,
    required this.skillLevel,
    required this.intonationScore,
    required this.rhythmScore,
    required this.articulationScore,
    required this.dynamicsScore,
    required this.overallScore,
    required this.totalSessions,
    required this.calculatedAt,
  });

  factory SkillMetrics.fromJson(Map<String, dynamic> json) {
    return SkillMetrics(
      id: json['id'],
      userId: json['user_id'],
      skillLevel: SkillLevelEnum.fromString(json['skill_level']),
      intonationScore: json['intonation_score'].toDouble(),
      rhythmScore: json['rhythm_score'].toDouble(),
      articulationScore: json['articulation_score'].toDouble(),
      dynamicsScore: json['dynamics_score'].toDouble(),
      overallScore: json['overall_score'].toDouble(),
      totalSessions: json['total_sessions'],
      calculatedAt: DateTime.parse(json['calculated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'skill_level': skillLevel.value,
      'intonation_score': intonationScore,
      'rhythm_score': rhythmScore,
      'articulation_score': articulationScore,
      'dynamics_score': dynamicsScore,
      'overall_score': overallScore,
      'total_sessions': totalSessions,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}