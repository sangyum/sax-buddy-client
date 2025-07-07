import 'feedback_type.dart';

class Feedback {
  final String id;
  final String sessionId;
  final FeedbackType feedbackType;
  final String content;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.sessionId,
    required this.feedbackType,
    required this.content,
    this.metadata = const {},
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      sessionId: json['session_id'],
      feedbackType: FeedbackType.fromString(json['feedback_type']),
      content: json['content'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'feedback_type': feedbackType.value,
      'content': content,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
}