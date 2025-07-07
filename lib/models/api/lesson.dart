class Lesson {
  final String id;
  final String title;
  final String description;
  final List<String> exerciseIds;
  final int order;
  final String? category;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.exerciseIds,
    required this.order,
    this.category,
    required this.createdAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      exerciseIds: List<String>.from(json['exercise_ids']),
      order: json['order'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exercise_ids': exerciseIds,
      'order': order,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}