import 'assessment_type.dart';
import 'trigger_reason.dart';

class FormalAssessment {
  final String id;
  final String userId;
  final AssessmentType assessmentType;
  final TriggerReason triggerReason;
  final double overallScore;
  final double intonationScore;
  final double rhythmScore;
  final double articulationScore;
  final double dynamicsScore;
  final Map<String, dynamic> detailedResults;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  FormalAssessment({
    required this.id,
    required this.userId,
    required this.assessmentType,
    required this.triggerReason,
    required this.overallScore,
    required this.intonationScore,
    required this.rhythmScore,
    required this.articulationScore,
    required this.dynamicsScore,
    this.detailedResults = const {},
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FormalAssessment.fromJson(Map<String, dynamic> json) {
    return FormalAssessment(
      id: json['id'],
      userId: json['user_id'],
      assessmentType: AssessmentType.fromString(json['assessment_type']),
      triggerReason: TriggerReason.fromString(json['trigger_reason']),
      overallScore: json['overall_score'].toDouble(),
      intonationScore: json['intonation_score'].toDouble(),
      rhythmScore: json['rhythm_score'].toDouble(),
      articulationScore: json['articulation_score'].toDouble(),
      dynamicsScore: json['dynamics_score'].toDouble(),
      detailedResults: Map<String, dynamic>.from(json['detailed_results'] ?? {}),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'assessment_type': assessmentType.value,
      'trigger_reason': triggerReason.value,
      'overall_score': overallScore,
      'intonation_score': intonationScore,
      'rhythm_score': rhythmScore,
      'articulation_score': articulationScore,
      'dynamics_score': dynamicsScore,
      'detailed_results': detailedResults,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}