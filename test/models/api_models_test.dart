import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/models/api_models.dart';

void main() {
  group('User Model Tests', () {
    test('should create User from JSON', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': 'Test User',
        'skill_level': 'beginner',
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.skillLevel, 'beginner');
      expect(user.createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
      expect(user.updatedAt, DateTime.parse('2023-01-02T00:00:00Z'));
    });

    test('should create User from JSON with null values', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': null,
        'skill_level': null,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.name, null);
      expect(user.skillLevel, null);
    });

    test('should convert User to JSON', () {
      final user = User(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        skillLevel: 'beginner',
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['skill_level'], 'beginner');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });
  });

  group('CreateUserRequest Tests', () {
    test('should convert CreateUserRequest to JSON', () {
      final request = CreateUserRequest(
        email: 'test@example.com',
        name: 'Test User',
        skillLevel: 'beginner',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['skill_level'], 'beginner');
    });

    test('should convert CreateUserRequest to JSON with null values', () {
      final request = CreateUserRequest(
        email: 'test@example.com',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['name'], null);
      expect(json['skill_level'], null);
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
        'name': 'Scale Practice',
        'description': 'Practice major scales',
        'difficulty': 'beginner',
        'category': 'scales',
        'metadata': {'tempo': 120, 'key': 'C'},
        'created_at': '2023-01-01T00:00:00Z',
      };

      final exercise = Exercise.fromJson(json);

      expect(exercise.id, 'exercise123');
      expect(exercise.name, 'Scale Practice');
      expect(exercise.description, 'Practice major scales');
      expect(exercise.difficulty, 'beginner');
      expect(exercise.category, 'scales');
      expect(exercise.metadata, {'tempo': 120, 'key': 'C'});
      expect(exercise.createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
    });
  });

  group('ApiResponse Tests', () {
    test('should create successful ApiResponse', () {
      final user = User(
        id: 'user123',
        email: 'test@example.com',
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
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          },
          {
            'id': 'user2',
            'email': 'user2@example.com',
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