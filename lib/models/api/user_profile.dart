import 'skill_level_enum.dart';
import 'practice_frequency.dart';

class UserProfile {
  final String id;
  final String userId;
  final SkillLevelEnum currentSkillLevel;
  final List<String> learningGoals;
  final PracticeFrequency practiceFrequency;
  final int formalAssessmentIntervalDays;
  final int? preferredPracticeDurationMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    required this.currentSkillLevel,
    required this.learningGoals,
    required this.practiceFrequency,
    this.formalAssessmentIntervalDays = 30,
    this.preferredPracticeDurationMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      currentSkillLevel: SkillLevelEnum.fromString(json['current_skill_level']),
      learningGoals: List<String>.from(json['learning_goals']),
      practiceFrequency: PracticeFrequency.fromString(json['practice_frequency']),
      formalAssessmentIntervalDays: json['formal_assessment_interval_days'] ?? 30,
      preferredPracticeDurationMinutes: json['preferred_practice_duration_minutes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'current_skill_level': currentSkillLevel.value,
      'learning_goals': learningGoals,
      'practice_frequency': practiceFrequency.value,
      'formal_assessment_interval_days': formalAssessmentIntervalDays,
      'preferred_practice_duration_minutes': preferredPracticeDurationMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}