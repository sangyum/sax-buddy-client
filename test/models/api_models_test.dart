import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/models/api_models.dart';

void main() {
  group('Enum Tests', () {
    test('should handle ExerciseType enum', () {
      expect(ExerciseType.scales, isNotNull);
      expect(ExerciseType.arpeggios, isNotNull);
      expect(ExerciseType.technical, isNotNull);
      expect(ExerciseType.etudes, isNotNull);
      expect(ExerciseType.songs, isNotNull);
      expect(ExerciseType.longTone, isNotNull);
    });

    test('should handle DifficultyLevel enum', () {
      expect(DifficultyLevel.beginner, isNotNull);
      expect(DifficultyLevel.intermediate, isNotNull);
      expect(DifficultyLevel.advanced, isNotNull);
    });

    test('should handle SkillLevel enum', () {
      expect(SkillLevelEnum.beginner, isNotNull);
      expect(SkillLevelEnum.intermediate, isNotNull);
      expect(SkillLevelEnum.advanced, isNotNull);
    });

    test('should handle SessionStatus enum', () {
      expect(SessionStatus.inProgress, isNotNull);
      expect(SessionStatus.completed, isNotNull);
      expect(SessionStatus.paused, isNotNull);
      expect(SessionStatus.cancelled, isNotNull);
    });
  });

  group('UserProfile Model Tests', () {
    test('should create UserProfile from JSON', () {
      final json = {
        'id': 'profile123',
        'user_id': 'user123',
        'current_skill_level': 'beginner',
        'learning_goals': ['Improve tone', 'Learn scales'],
        'practice_frequency': 'daily',
        'formal_assessment_interval_days': 30,
        'preferred_practice_duration_minutes': 45,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'profile123');
      expect(profile.userId, 'user123');
      expect(profile.currentSkillLevel, SkillLevelEnum.beginner);
      expect(profile.learningGoals, ['Improve tone', 'Learn scales']);
      expect(profile.practiceFrequency, PracticeFrequency.daily);
      expect(profile.formalAssessmentIntervalDays, 30);
      expect(profile.preferredPracticeDurationMinutes, 45);
    });
  });

  group('PerformanceMetrics Model Tests', () {
    test('should create PerformanceMetrics from JSON', () {
      final json = {
        'id': 'metrics123',
        'session_id': 'session123',
        'timestamp': 15.5,
        'intonation_score': 85.0,
        'rhythm_score': 90.0,
        'articulation_score': 78.0,
        'dynamics_score': 82.0,
        'raw_metrics': {'key': 'value'},
        'created_at': '2023-01-01T00:00:00Z',
      };

      final metrics = PerformanceMetrics.fromJson(json);

      expect(metrics.id, 'metrics123');
      expect(metrics.sessionId, 'session123');
      expect(metrics.timestamp, 15.5);
      expect(metrics.intonationScore, 85.0);
      expect(metrics.rhythmScore, 90.0);
      expect(metrics.articulationScore, 78.0);
      expect(metrics.dynamicsScore, 82.0);
      expect(metrics.rawMetrics, {'key': 'value'});
    });
  });

  group('User Model Tests', () {
    test('should create User from JSON', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': 'Test User',
        'is_active': true,
        'initial_assessment_completed': false,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.isActive, true);
      expect(user.initialAssessmentCompleted, false);
      expect(user.createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
      expect(user.updatedAt, DateTime.parse('2023-01-02T00:00:00Z'));
    });

    test('should create User from JSON with null values', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': 'Test User',
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.isActive, true);
      expect(user.initialAssessmentCompleted, false);
    });

    test('should convert User to JSON', () {
      final user = User(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['is_active'], true);
      expect(json['initial_assessment_completed'], false);
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });
  });

  group('CreateUserRequest Tests', () {
    test('should convert CreateUserRequest to JSON', () {
      final request = CreateUserRequest(
        email: 'test@example.com',
        name: 'Test User',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
    });

    test('should convert CreateUserRequest to JSON with null values', () {
      final request = CreateUserRequest(
        email: 'test@example.com',
        name: 'Test User',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
    });
  });

  group('PerformanceSession Tests', () {
    test('should create PerformanceSession from JSON', () {
      final json = {
        'id': 'session123',
        'user_id': 'user123',
        'exercise_id': 'exercise123',
        'start_time': '2023-01-01T10:00:00Z',
        'end_time': '2023-01-01T10:30:00Z',
        'metrics': {'accuracy': 0.85, 'tempo': 120.0},
        'recording_url': 'https://example.com/recording.mp3',
        'feedback': 'Good performance',
      };

      final session = PerformanceSession.fromJson(json);

      expect(session.id, 'session123');
      expect(session.userId, 'user123');
      expect(session.exerciseId, 'exercise123');
      expect(session.startTime, DateTime.parse('2023-01-01T10:00:00Z'));
      expect(session.endTime, DateTime.parse('2023-01-01T10:30:00Z'));
      expect(session.metrics, {'accuracy': 0.85, 'tempo': 120.0});
      expect(session.recordingUrl, 'https://example.com/recording.mp3');
      expect(session.feedback, 'Good performance');
    });

    test('should create PerformanceSession from JSON with null values', () {
      final json = {
        'id': 'session123',
        'user_id': 'user123',
        'exercise_id': null,
        'start_time': '2023-01-01T10:00:00Z',
        'end_time': null,
        'metrics': null,
        'recording_url': null,
        'feedback': null,
      };

      final session = PerformanceSession.fromJson(json);

      expect(session.id, 'session123');
      expect(session.userId, 'user123');
      expect(session.exerciseId, null);
      expect(session.endTime, null);
      expect(session.metrics, null);
      expect(session.recordingUrl, null);
      expect(session.feedback, null);
    });
  });

  group('Exercise Tests', () {
    test('should create Exercise from JSON', () {
      final json = {
        'id': 'exercise123',
        'title': 'Scale Practice',
        'description': 'Practice major scales',
        'exercise_type': 'scales',
        'difficulty_level': 'beginner',
        'estimated_duration_minutes': 15,
        'instructions': ['Play slowly', 'Focus on intonation'],
        'reference_audio_url': 'https://example.com/audio.mp3',
        'sheet_music_url': null,
        'is_active': true,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };

      final exercise = Exercise.fromJson(json);

      expect(exercise.id, 'exercise123');
      expect(exercise.title, 'Scale Practice');
      expect(exercise.description, 'Practice major scales');
      expect(exercise.exerciseType, ExerciseType.scales);
      expect(exercise.difficultyLevel, DifficultyLevel.beginner);
      expect(exercise.estimatedDurationMinutes, 15);
      expect(exercise.instructions, ['Play slowly', 'Focus on intonation']);
      expect(exercise.referenceAudioUrl, 'https://example.com/audio.mp3');
      expect(exercise.sheetMusicUrl, null);
      expect(exercise.isActive, true);
      expect(exercise.createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
      expect(exercise.updatedAt, DateTime.parse('2023-01-02T00:00:00Z'));
    });
  });

  group('ApiResponse Tests', () {
    test('should create successful ApiResponse', () {
      final user = User(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final response = ApiResponse.success(user, 'User created successfully');

      expect(response.success, true);
      expect(response.data, user);
      expect(response.message, 'User created successfully');
      expect(response.error, null);
    });

    test('should create error ApiResponse', () {
      final response = ApiResponse<User>.error('User not found');

      expect(response.success, false);
      expect(response.data, null);
      expect(response.message, null);
      expect(response.error, 'User not found');
    });
  });

  group('PaginatedResponse Tests', () {
    test('should create PaginatedResponse from JSON', () {
      final json = {
        'items': [
          {
            'id': 'user1',
            'email': 'user1@example.com',
            'name': 'User One',
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          },
          {
            'id': 'user2',
            'email': 'user2@example.com',
            'name': 'User Two',
            'created_at': '2023-01-02T00:00:00Z',
            'updated_at': '2023-01-02T00:00:00Z',
          }
        ],
        'total': 100,
        'page': 1,
        'page_size': 20,
        'total_pages': 5,
      };

      final response = PaginatedResponse.fromJson(
        json,
        (json) => User.fromJson(json),
      );

      expect(response.items.length, 2);
      expect(response.items[0].id, 'user1');
      expect(response.items[1].id, 'user2');
      expect(response.total, 100);
      expect(response.page, 1);
      expect(response.pageSize, 20);
      expect(response.totalPages, 5);
    });
  });
}