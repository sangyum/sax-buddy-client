import 'skill_level_enum.dart';
import 'practice_frequency.dart';

class UserProfileUpdate {
  final SkillLevelEnum? currentSkillLevel;
  final List<String>? learningGoals;
  final PracticeFrequency? practiceFrequency;
  final int? formalAssessmentIntervalDays;
  final int? preferredPracticeDurationMinutes;

  UserProfileUpdate({
    this.currentSkillLevel,
    this.learningGoals,
    this.practiceFrequency,
    this.formalAssessmentIntervalDays,
    this.preferredPracticeDurationMinutes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (currentSkillLevel != null) json['current_skill_level'] = currentSkillLevel!.value;
    if (learningGoals != null) json['learning_goals'] = learningGoals;
    if (practiceFrequency != null) json['practice_frequency'] = practiceFrequency!.value;
    if (formalAssessmentIntervalDays != null) json['formal_assessment_interval_days'] = formalAssessmentIntervalDays;
    if (preferredPracticeDurationMinutes != null) json['preferred_practice_duration_minutes'] = preferredPracticeDurationMinutes;
    return json;
  }
}