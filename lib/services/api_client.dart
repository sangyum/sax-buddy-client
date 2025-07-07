import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/api_models.dart';
import 'logging_service.dart';

class ApiClient {
  late Dio _dio;
  final LoggingService _logger = LoggingService();

  static const String _defaultBaseUrl = 'http://127.0.0.1:8000';

  // Read from .env file with fallback to compile-time environment variable
  static String get _baseUrl {
    return dotenv.env['SAX_BUDDY_API_BASE_URL'] ??
        const String.fromEnvironment(
          'SAX_BUDDY_API_BASE_URL',
          defaultValue: _defaultBaseUrl,
        );
  }

  ApiClient({String? baseUrl, Dio? dio}) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl ?? _baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.logNetworkCall(
            options.method,
            options.path,
            data: options.data != null ? {'hasBody': true} : null,
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.logNetworkCall(
            response.requestOptions.method,
            response.requestOptions.path,
            statusCode: response.statusCode,
          );
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.logError(
            'Network error: ${error.message}',
            error: error,
            data: {
              'statusCode': error.response?.statusCode,
              'path': error.requestOptions.path,
              'method': error.requestOptions.method,
            },
          );
          handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // User endpoints
  Future<ApiResponse<User>> createUser(CreateUserRequest request) async {
    try {
      final response = await _dio.post('/v1/users', data: request.toJson());
      final user = User.fromJson(response.data);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<User>> getUser(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId');
      final user = User.fromJson(response.data);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // User profile endpoints
  Future<ApiResponse<UserProfile>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/profile');
      final profile = UserProfile.fromJson(response.data);
      return ApiResponse.success(profile);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<UserProfile>> updateUserProfile(
    String userId,
    UserProfileUpdate update,
  ) async {
    try {
      final response = await _dio.put(
        '/v1/users/$userId/profile',
        data: update.toJson(),
      );
      final profile = UserProfile.fromJson(response.data);
      return ApiResponse.success(profile);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<UserProgress>> getUserProgress(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/progress');
      final progress = UserProgress.fromJson(response.data);
      return ApiResponse.success(progress);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // Performance endpoints
  Future<ApiResponse<PerformanceSession>> createPerformanceSession(
    PerformanceSessionCreate request,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/performance/sessions',
        data: request.toJson(),
      );
      final session = PerformanceSession.fromJson(response.data);
      return ApiResponse.success(session);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<PerformanceSession>> getPerformanceSession(
    String sessionId,
  ) async {
    try {
      final response = await _dio.get('/v1/performance/sessions/$sessionId');
      final session = PerformanceSession.fromJson(response.data);
      return ApiResponse.success(session);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<PerformanceSession>> updatePerformanceSession(
    String sessionId,
    PerformanceSessionUpdate update,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/performance/sessions/$sessionId',
        data: update.toJson(),
      );
      final session = PerformanceSession.fromJson(response.data);
      return ApiResponse.success(session);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<String>> uploadPerformanceRecording(
    String sessionId,
    String filePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '/v1/performance/sessions/$sessionId/file',
        data: formData,
      );
      return ApiResponse.success(response.data.toString());
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<List<PerformanceMetrics>>> submitMetrics(
    String sessionId,
    List<PerformanceMetricsCreate> metrics,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/performance/sessions/$sessionId/metrics',
        data: metrics.map((m) => m.toJson()).toList(),
      );
      final metricsList = (response.data as List)
          .map((metric) => PerformanceMetrics.fromJson(metric))
          .toList();
      return ApiResponse.success(metricsList);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<List<PerformanceMetrics>>> getSessionMetrics(
    String sessionId,
  ) async {
    try {
      final response = await _dio.get(
        '/v1/performance/sessions/$sessionId/metrics',
      );
      final metrics = (response.data as List)
          .map((metric) => PerformanceMetrics.fromJson(metric))
          .toList();
      return ApiResponse.success(metrics);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // Exercise endpoints
  Future<ApiResponse<List<Exercise>>> getExercises({
    ExerciseType? exerciseType,
    DifficultyLevel? difficultyLevel,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (exerciseType != null) {
        queryParams['exercise_type'] = exerciseType.value;
      }
      if (difficultyLevel != null) {
        queryParams['difficulty_level'] = difficultyLevel.value;
      }

      final response = await _dio.get(
        '/v1/exercises',
        queryParameters: queryParams,
      );
      final exercises = (response.data as List)
          .map((exercise) => Exercise.fromJson(exercise))
          .toList();
      return ApiResponse.success(exercises);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Exercise>> getExercise(String exerciseId) async {
    try {
      final response = await _dio.get('/v1/exercises/$exerciseId');
      final exercise = Exercise.fromJson(response.data);
      return ApiResponse.success(exercise);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // Lesson plan endpoints
  Future<ApiResponse<LessonPlan>> generateLessonPlan(String userId) async {
    try {
      final response = await _dio.post('/v1/users/$userId/lesson-plans');
      final lessonPlan = LessonPlan.fromJson(response.data);
      return ApiResponse.success(lessonPlan);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // Assessment endpoints
  Future<ApiResponse<List<FormalAssessment>>> getUserAssessments(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/v1/users/$userId/assessments',
        queryParameters: {'limit': limit},
      );
      final assessments = (response.data as List)
          .map((assessment) => FormalAssessment.fromJson(assessment))
          .toList();
      return ApiResponse.success(assessments);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<FormalAssessment>> triggerAssessment(
    String userId,
    AssessmentTrigger trigger,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/users/$userId/assessments',
        data: trigger.toJson(),
      );
      final assessment = FormalAssessment.fromJson(response.data);
      return ApiResponse.success(assessment);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Feedback>> getSessionFeedback(String sessionId) async {
    try {
      final response = await _dio.get(
        '/v1/performance/sessions/$sessionId/feedback',
      );
      final feedback = Feedback.fromJson(response.data);
      return ApiResponse.success(feedback);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<SkillMetrics>> getUserSkillMetrics(
    String userId, {
    int periodDays = 30,
  }) async {
    try {
      final response = await _dio.get(
        '/v1/users/$userId/skill-metrics',
        queryParameters: {'period_days': periodDays},
      );
      final metrics = SkillMetrics.fromJson(response.data);
      return ApiResponse.success(metrics);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // Reference endpoints
  Future<ApiResponse<List<SkillLevelDefinition>>> getSkillLevelDefinitions() async {
    try {
      final response = await _dio.get('/v1/reference/skill-levels');
      final skillLevels = (response.data as List)
          .map((skillLevel) => SkillLevelDefinition.fromJson(skillLevel))
          .toList();
      return ApiResponse.success(skillLevels);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<List<ReferencePerformance>>> getReferencePerformances({
    String? exerciseId,
    SkillLevelEnum? skillLevel,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (exerciseId != null) queryParams['exercise_id'] = exerciseId;
      if (skillLevel != null) queryParams['skill_level'] = skillLevel.value;

      final response = await _dio.get(
        '/v1/reference/performances',
        queryParameters: queryParams,
      );
      final performances = (response.data as List)
          .map((performance) => ReferencePerformance.fromJson(performance))
          .toList();
      return ApiResponse.success(performances);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        if (statusCode == 401) {
          return 'Unauthorized - Please log in again';
        } else if (statusCode == 403) {
          return 'Forbidden - You don\'t have permission to access this resource';
        } else if (statusCode == 404) {
          return 'Resource not found';
        } else if (statusCode == 422) {
          return 'Validation error: ${data?['detail'] ?? 'Invalid data'}';
        } else if (statusCode == 500) {
          return 'Internal server error';
        } else {
          return 'Server error ($statusCode): ${data?['message'] ?? data?['detail'] ?? 'Unknown error'}';
        }
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error - Please check your internet connection';
      case DioExceptionType.unknown:
        return 'Unknown error: ${e.message}';
      default:
        return 'Network error: ${e.message}';
    }
  }
}