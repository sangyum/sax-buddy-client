class ReferencePerformance {
  final String id;
  final String exerciseId;
  final String title;
  final String description;
  final String audioUrl;
  final String? videoUrl;
  final String? notes;
  final DateTime createdAt;

  ReferencePerformance({
    required this.id,
    required this.exerciseId,
    required this.title,
    required this.description,
    required this.audioUrl,
    this.videoUrl,
    this.notes,
    required this.createdAt,
  });

  factory ReferencePerformance.fromJson(Map<String, dynamic> json) {
    return ReferencePerformance(
      id: json['id'],
      exerciseId: json['exercise_id'],
      title: json['title'],
      description: json['description'],
      audioUrl: json['audio_url'],
      videoUrl: json['video_url'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'title': title,
      'description': description,
      'audio_url': audioUrl,
      'video_url': videoUrl,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}