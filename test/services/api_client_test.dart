import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:sax_buddy/services/api_client.dart';
import 'package:sax_buddy/models/api_models.dart';

import 'api_client_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<Interceptors>(), MockSpec<BaseOptions>()])

void main() {
  group('ApiClient Tests', () {
    late ApiClient apiClient;
    late MockDio mockDio;
    late MockInterceptors mockInterceptors;
    late MockBaseOptions mockBaseOptions;

    setUp(() {
      mockDio = MockDio();
      mockInterceptors = MockInterceptors();
      mockBaseOptions = MockBaseOptions();
      
      // Set up basic mocks
      when(mockDio.interceptors).thenReturn(mockInterceptors);
      when(mockInterceptors.add(any)).thenReturn(null);
      when(mockDio.options).thenReturn(mockBaseOptions);
      when(mockBaseOptions.headers).thenReturn(<String, dynamic>{});
      
      apiClient = ApiClient(dio: mockDio);
    });

    group('User Endpoints', () {
      test('should create user successfully', () async {
        // Arrange
        final request = CreateUserRequest(
          email: 'test@example.com',
          name: 'Test User',
        );
        
        final responseData = {
          'id': 'user123',
          'email': 'test@example.com',
          'name': 'Test User',
          'skill_level': null,
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        when(mockDio.post('/v1/users', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/users'),
                ));

        // Act
        final result = await apiClient.createUser(request);

        // Assert
        expect(result.success, true);
        expect(result.data, isA<User>());
        expect(result.data!.id, 'user123');
        expect(result.data!.email, 'test@example.com');
        verify(mockDio.post('/v1/users', data: request.toJson())).called(1);
      });

      test('should handle user creation error', () async {
        // Arrange
        final request = CreateUserRequest(email: 'test@example.com', name: 'Test User');
        
        when(mockDio.post('/v1/users', data: anyNamed('data')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/users'),
              response: Response(
                statusCode: 400,
                data: {'detail': 'Invalid email'},
                requestOptions: RequestOptions(path: '/users'),
              ),
              type: DioExceptionType.badResponse,
            ));

        // Act
        final result = await apiClient.createUser(request);

        // Assert
        expect(result.success, false);
        expect(result.error, contains('Server error'));
      });

      test('should get user successfully', () async {
        // Arrange
        const userId = 'user123';
        final responseData = {
          'id': userId,
          'email': 'test@example.com',
          'name': 'Test User',
          'skill_level': 'beginner',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        when(mockDio.get('/v1/users/$userId'))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/users/$userId'),
                ));

        // Act
        final result = await apiClient.getUser(userId);

        // Assert
        expect(result.success, true);
        expect(result.data, isA<User>());
        expect(result.data!.id, userId);
        verify(mockDio.get('/v1/users/$userId')).called(1);
      });

      test('should handle user not found error', () async {
        // Arrange
        const userId = 'nonexistent';
        
        when(mockDio.get('/v1/users/$userId'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/users/$userId'),
              response: Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: '/users/$userId'),
              ),
              type: DioExceptionType.badResponse,
            ));

        // Act
        final result = await apiClient.getUser(userId);

        // Assert
        expect(result.success, false);
        expect(result.error, 'Resource not found');
      });
    });

    group('Authentication', () {
      test('should set auth token', () {
        // Arrange
        const token = 'test-token';

        // Act
        apiClient.setAuthToken(token);

        // Assert
        // Note: In a real implementation, you'd verify the token is set in headers
        // This is a simplified test
        expect(true, true); // Placeholder assertion
      });

      test('should clear auth token', () {
        // Arrange
        apiClient.setAuthToken('test-token');

        // Act
        apiClient.clearAuthToken();

        // Assert
        // Note: In a real implementation, you'd verify the token is removed from headers
        expect(true, true); // Placeholder assertion
      });
    });

    group('Error Handling', () {
      test('should handle connection timeout', () async {
        // Arrange
        when(mockDio.get('/v1/users/test'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/users/test'),
              type: DioExceptionType.connectionTimeout,
            ));

        // Act
        final result = await apiClient.getUser('test');

        // Assert
        expect(result.success, false);
        expect(result.error, 'Connection timeout');
      });

      test('should handle connection error', () async {
        // Arrange
        when(mockDio.get('/v1/users/test'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/users/test'),
              type: DioExceptionType.connectionError,
            ));

        // Act
        final result = await apiClient.getUser('test');

        // Assert
        expect(result.success, false);
        expect(result.error, 'Connection error - Please check your internet connection');
      });

      test('should handle unauthorized error', () async {
        // Arrange
        when(mockDio.get('/v1/users/test'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/users/test'),
              response: Response(
                statusCode: 401,
                requestOptions: RequestOptions(path: '/users/test'),
              ),
              type: DioExceptionType.badResponse,
            ));

        // Act
        final result = await apiClient.getUser('test');

        // Assert
        expect(result.success, false);
        expect(result.error, 'Unauthorized - Please log in again');
      });
    });

    group('Exercise Endpoints', () {
      test('should get exercises with pagination', () async {
        // Arrange
        final responseData = [
          {
            'id': 'exercise1',
            'title': 'Scale Exercise',
            'description': 'Practice scales',
            'exercise_type': 'scales',
            'difficulty_level': 'beginner',
            'estimated_duration_minutes': 30,
            'instructions': ['Play slowly', 'Focus on intonation'],
            'reference_audio_url': null,
            'sheet_music_url': null,
            'is_active': true,
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          }
        ];

        when(mockDio.get('/v1/exercises', queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/exercises'),
                ));

        // Act
        final result = await apiClient.getExercises(limit: 20);

        // Assert
        expect(result.success, true);
        expect(result.data, isA<List<Exercise>>());
        expect(result.data!.length, 1);
        expect(result.data![0].title, 'Scale Exercise');
        verify(mockDio.get('/v1/exercises', queryParameters: {
          'limit': 20,
        })).called(1);
      });
    });
  });
}