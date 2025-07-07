import 'exercise_type.dart';
import 'difficulty_level.dart';

class Exercise {
  final String id;
  final String title;
  final String description;
  final ExerciseType exerciseType;
  final DifficultyLevel difficultyLevel;
  final int estimatedDurationMinutes;
  final List<String> instructions;
  final String? referenceAudioUrl;
  final String? sheetMusicUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.exerciseType,
    required this.difficultyLevel,
    required this.estimatedDurationMinutes,
    this.instructions = const [],
    this.referenceAudioUrl,
    this.sheetMusicUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      exerciseType: ExerciseType.fromString(json['exercise_type']),
      difficultyLevel: DifficultyLevel.fromString(json['difficulty_level']),
      estimatedDurationMinutes: json['estimated_duration_minutes'],
      instructions: List<String>.from(json['instructions'] ?? []),
      referenceAudioUrl: json['reference_audio_url'],
      sheetMusicUrl: json['sheet_music_url'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exercise_type': exerciseType.value,
      'difficulty_level': difficultyLevel.value,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'instructions': instructions,
      'reference_audio_url': referenceAudioUrl,
      'sheet_music_url': sheetMusicUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}