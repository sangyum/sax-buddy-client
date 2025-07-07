import '../models/api_models.dart';
import 'api_client.dart';
import 'auth_service.dart';

class SaxBuddyService {
  static final SaxBuddyService _instance = SaxBuddyService._internal();
  factory SaxBuddyService() => _instance;
  SaxBuddyService._internal();

  late final ApiClient _apiClient;
  late final AuthService _authService;

  void initialize({String? baseUrl}) {
    _apiClient = ApiClient(baseUrl: baseUrl);
    _authService = AuthService();
  }

  // User methods
  Future<ApiResponse<User>> createUser(CreateUserRequest request) async {
    return await _apiClient.createUser(request);
  }

  Future<ApiResponse<User>> getCurrentUser() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUser(currentUser.uid);
  }

  Future<ApiResponse<User>> updateCurrentUser(Map<String, dynamic> updates) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.updateUser(currentUser.uid, updates);
  }

  // Performance methods
  Future<ApiResponse<PerformanceSession>> startPerformanceSession(String exerciseId) async {
    final request = CreatePerformanceSessionRequest(exerciseId: exerciseId);
    return await _apiClient.createPerformanceSession(request);
  }

  Future<ApiResponse<PerformanceSession>> endPerformanceSession(
    String sessionId,
    Map<String, double>? metrics,
  ) async {
    final updates = <String, dynamic>{
      'end_time': DateTime.now().toIso8601String(),
      if (metrics != null) 'metrics': metrics,
    };
    return await _apiClient.updatePerformanceSession(sessionId, updates);
  }

  Future<ApiResponse<String>> uploadRecording(String sessionId, String filePath) async {
    return await _apiClient.uploadPerformanceRecording(sessionId, filePath);
  }

  Future<ApiResponse<List<PerformanceSession>>> getUserPerformanceSessions() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUserPerformanceSessions(currentUser.uid);
  }

  // Exercise methods
  Future<ApiResponse<PaginatedResponse<Exercise>>> getExercises({
    int page = 1,
    int pageSize = 20,
    String? difficulty,
    String? category,
  }) async {
    return await _apiClient.getExercises(
      page: page,
      pageSize: pageSize,
      difficulty: difficulty,
      category: category,
    );
  }

  Future<ApiResponse<Exercise>> getExercise(String exerciseId) async {
    return await _apiClient.getExercise(exerciseId);
  }

  // Lesson methods
  Future<ApiResponse<PaginatedResponse<Lesson>>> getLessons({
    int page = 1,
    int pageSize = 20,
    String? category,
  }) async {
    return await _apiClient.getLessons(
      page: page,
      pageSize: pageSize,
      category: category,
    );
  }

  Future<ApiResponse<Lesson>> getLesson(String lessonId) async {
    return await _apiClient.getLesson(lessonId);
  }

  // Lesson plan methods
  Future<ApiResponse<LessonPlan>> generatePersonalizedLessonPlan({
    String? skillLevel,
    List<String>? goals,
  }) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.generateLessonPlan(
      currentUser.uid,
      skillLevel: skillLevel,
      goals: goals,
    );
  }

  Future<ApiResponse<PaginatedResponse<LessonPlan>>> getUserLessonPlans({
    int page = 1,
    int pageSize = 20,
  }) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUserLessonPlans(
      currentUser.uid,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<ApiResponse<LessonPlan>> getLessonPlan(String lessonPlanId) async {
    return await _apiClient.getLessonPlan(lessonPlanId);
  }

  // Assessment methods
  Future<ApiResponse<Assessment>> triggerAssessment(String sessionId) async {
    return await _apiClient.triggerAssessment(sessionId);
  }

  Future<ApiResponse<List<Assessment>>> getUserAssessments() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUserAssessments(currentUser.uid);
  }

  Future<ApiResponse<String>> getSessionFeedback(String sessionId) async {
    return await _apiClient.getSessionFeedback(sessionId);
  }

  // Reference methods
  Future<ApiResponse<List<SkillLevel>>> getSkillLevels() async {
    return await _apiClient.getSkillLevels();
  }

  Future<ApiResponse<List<PerformanceSession>>> getReferencePerformances({
    String? exerciseId,
    String? skillLevel,
  }) async {
    return await _apiClient.getReferencePerformances(
      exerciseId: exerciseId,
      skillLevel: skillLevel,
    );
  }

  // Auth integration
  Future<void> onAuthStateChanged() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      // Get the Google access token and set it in the API client
      final accessToken = _authService.googleAccessToken;
      if (accessToken != null) {
        _apiClient.setAuthToken(accessToken);
      }
    } else {
      _apiClient.clearAuthToken();
    }
  }
}