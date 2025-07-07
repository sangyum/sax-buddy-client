import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/api_models.dart';
import 'logging_service.dart';

class ApiClient {
  late Dio _dio;
  final LoggingService _logger = LoggingService();
  
  static const String _defaultBaseUrl = 'http://0.0.0.0:8000';
  
  // Read from .env file with fallback to compile-time environment variable
  static String get _baseUrl {
    return dotenv.env['SAX_BUDDY_API_BASE_URL'] ?? 
           const String.fromEnvironment('SAX_BUDDY_API_BASE_URL', defaultValue: _defaultBaseUrl);
  }
  
  ApiClient({String? baseUrl, Dio? dio}) {
    _dio = dio ?? Dio(BaseOptions(
      baseUrl: baseUrl ?? _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
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
      final response = await _dio.post('/users', data: request.toJson());
      final user = User.fromJson(response.data);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<User>> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      final user = User.fromJson(response.data);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<User>> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/users/$userId', data: updates);
      final user = User.fromJson(response.data);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<void>> deleteUser(String userId) async {
    try {
      await _dio.delete('/users/$userId');
      return ApiResponse.success(null);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  // Performance endpoints
  Future<ApiResponse<PerformanceSession>> createPerformanceSession(CreatePerformanceSessionRequest request) async {
    try {
      final response = await _dio.post('/performance/sessions', data: request.toJson());
      final session = PerformanceSession.fromJson(response.data);
      return ApiResponse.success(session);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<PerformanceSession>> getPerformanceSession(String sessionId) async {
    try {
      final response = await _dio.get('/performance/sessions/$sessionId');
      final session = PerformanceSession.fromJson(response.data);
      return ApiResponse.success(session);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<List<PerformanceSession>>> getUserPerformanceSessions(String userId) async {
    try {
      final response = await _dio.get('/performance/sessions/user/$userId');
      final sessions = (response.data as List)
          .map((session) => PerformanceSession.fromJson(session))
          .toList();
      return ApiResponse.success(sessions);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<PerformanceSession>> updatePerformanceSession(String sessionId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/performance/sessions/$sessionId', data: updates);
      final session = PerformanceSession.fromJson(response.data);
      return ApiResponse.success(session);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<String>> uploadPerformanceRecording(String sessionId, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post('/performance/sessions/$sessionId/recording', data: formData);
      return ApiResponse.success(response.data['recording_url']);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  // Exercise endpoints
  Future<ApiResponse<PaginatedResponse<Exercise>>> getExercises({
    int page = 1,
    int pageSize = 20,
    String? difficulty,
    String? category,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'page_size': pageSize,
        if (difficulty != null) 'difficulty': difficulty,
        if (category != null) 'category': category,
      };
      
      final response = await _dio.get('/exercises', queryParameters: queryParams);
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data,
        (json) => Exercise.fromJson(json),
      );
      return ApiResponse.success(paginatedResponse);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<Exercise>> getExercise(String exerciseId) async {
    try {
      final response = await _dio.get('/exercises/$exerciseId');
      final exercise = Exercise.fromJson(response.data);
      return ApiResponse.success(exercise);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  // Lesson endpoints
  Future<ApiResponse<PaginatedResponse<Lesson>>> getLessons({
    int page = 1,
    int pageSize = 20,
    String? category,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'page_size': pageSize,
        if (category != null) 'category': category,
      };
      
      final response = await _dio.get('/lessons', queryParameters: queryParams);
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data,
        (json) => Lesson.fromJson(json),
      );
      return ApiResponse.success(paginatedResponse);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<Lesson>> getLesson(String lessonId) async {
    try {
      final response = await _dio.get('/lessons/$lessonId');
      final lesson = Lesson.fromJson(response.data);
      return ApiResponse.success(lesson);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  // Lesson plan endpoints
  Future<ApiResponse<LessonPlan>> generateLessonPlan(String userId, {
    String? skillLevel,
    List<String>? goals,
  }) async {
    try {
      final data = {
        'user_id': userId,
        if (skillLevel != null) 'skill_level': skillLevel,
        if (goals != null) 'goals': goals,
      };
      
      final response = await _dio.post('/lesson-plans/generate', data: data);
      final lessonPlan = LessonPlan.fromJson(response.data);
      return ApiResponse.success(lessonPlan);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<PaginatedResponse<LessonPlan>>> getUserLessonPlans(String userId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'page_size': pageSize,
      };
      
      final response = await _dio.get('/lesson-plans/user/$userId', queryParameters: queryParams);
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data,
        (json) => LessonPlan.fromJson(json),
      );
      return ApiResponse.success(paginatedResponse);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<LessonPlan>> getLessonPlan(String lessonPlanId) async {
    try {
      final response = await _dio.get('/lesson-plans/$lessonPlanId');
      final lessonPlan = LessonPlan.fromJson(response.data);
      return ApiResponse.success(lessonPlan);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  // Assessment endpoints
  Future<ApiResponse<Assessment>> triggerAssessment(String sessionId) async {
    try {
      final response = await _dio.post('/assessments/trigger', data: {'session_id': sessionId});
      final assessment = Assessment.fromJson(response.data);
      return ApiResponse.success(assessment);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<List<Assessment>>> getUserAssessments(String userId) async {
    try {
      final response = await _dio.get('/assessments/user/$userId');
      final assessments = (response.data as List)
          .map((assessment) => Assessment.fromJson(assessment))
          .toList();
      return ApiResponse.success(assessments);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<String>> getSessionFeedback(String sessionId) async {
    try {
      final response = await _dio.get('/assessments/feedback/$sessionId');
      return ApiResponse.success(response.data['feedback']);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  // Reference endpoints
  Future<ApiResponse<List<SkillLevel>>> getSkillLevels() async {
    try {
      final response = await _dio.get('/reference/skill-levels');
      final skillLevels = (response.data as List)
          .map((skillLevel) => SkillLevel.fromJson(skillLevel))
          .toList();
      return ApiResponse.success(skillLevels);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }
  
  Future<ApiResponse<List<PerformanceSession>>> getReferencePerformances({
    String? exerciseId,
    String? skillLevel,
  }) async {
    try {
      final queryParams = {
        if (exerciseId != null) 'exercise_id': exerciseId,
        if (skillLevel != null) 'skill_level': skillLevel,
      };
      
      final response = await _dio.get('/reference/performances', queryParameters: queryParams);
      final performances = (response.data as List)
          .map((performance) => PerformanceSession.fromJson(performance))
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