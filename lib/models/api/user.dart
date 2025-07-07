class User {
  final String id;
  final String email;
  final String name;
  final bool isActive;
  final bool initialAssessmentCompleted;
  final DateTime? initialAssessmentCompletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.isActive = true,
    this.initialAssessmentCompleted = false,
    this.initialAssessmentCompletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isActive: json['is_active'] ?? true,
      initialAssessmentCompleted: json['initial_assessment_completed'] ?? false,
      initialAssessmentCompletedAt: json['initial_assessment_completed_at'] != null
          ? DateTime.parse(json['initial_assessment_completed_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'is_active': isActive,
      'initial_assessment_completed': initialAssessmentCompleted,
      'initial_assessment_completed_at': initialAssessmentCompletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}