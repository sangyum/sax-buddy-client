class LessonPlan {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> lessonIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.lessonIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonPlan.fromJson(Map<String, dynamic> json) {
    return LessonPlan(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      lessonIds: List<String>.from(json['lesson_ids']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'lesson_ids': lessonIds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}