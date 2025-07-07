import 'assessment_type.dart';
import 'trigger_reason.dart';

class AssessmentTrigger {
  final String userId;
  final AssessmentType assessmentType;
  final TriggerReason triggerReason;
  final String? notes;

  AssessmentTrigger({
    required this.userId,
    required this.assessmentType,
    required this.triggerReason,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'assessment_type': assessmentType.value,
      'trigger_reason': triggerReason.value,
      'notes': notes,
    };
  }
}