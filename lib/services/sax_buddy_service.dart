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

  Future<ApiResponse<UserProfile>> updateCurrentUserProfile(UserProfileUpdate updates) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.updateUserProfile(currentUser.uid, updates);
  }

  Future<ApiResponse<UserProfile>> getCurrentUserProfile() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUserProfile(currentUser.uid);
  }

  // Performance methods
  Future<ApiResponse<PerformanceSession>> startPerformanceSession(String exerciseId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    final request = PerformanceSessionCreate(userId: currentUser.uid, exerciseId: exerciseId);
    return await _apiClient.createPerformanceSession(request);
  }

  Future<ApiResponse<PerformanceSession>> endPerformanceSession(
    String sessionId,
    {int? durationMinutes, String? notes}
  ) async {
    final update = PerformanceSessionUpdate(
      status: SessionStatus.completed,
      endedAt: DateTime.now().toIso8601String(),
      durationMinutes: durationMinutes,
      notes: notes,
    );
    return await _apiClient.updatePerformanceSession(sessionId, update);
  }

  Future<ApiResponse<String>> uploadRecording(String sessionId, String filePath) async {
    return await _apiClient.uploadPerformanceRecording(sessionId, filePath);
  }

  Future<ApiResponse<List<PerformanceMetrics>>> submitSessionMetrics(
    String sessionId,
    List<PerformanceMetricsCreate> metrics,
  ) async {
    return await _apiClient.submitMetrics(sessionId, metrics);
  }

  Future<ApiResponse<List<PerformanceMetrics>>> getSessionMetrics(String sessionId) async {
    return await _apiClient.getSessionMetrics(sessionId);
  }

  // Exercise methods
  Future<ApiResponse<List<Exercise>>> getExercises({
    ExerciseType? exerciseType,
    DifficultyLevel? difficultyLevel,
    int limit = 20,
  }) async {
    return await _apiClient.getExercises(
      exerciseType: exerciseType,
      difficultyLevel: difficultyLevel,
      limit: limit,
    );
  }

  Future<ApiResponse<Exercise>> getExercise(String exerciseId) async {
    return await _apiClient.getExercise(exerciseId);
  }

  // Note: Lesson methods not yet implemented in the new API

  // Lesson plan methods
  Future<ApiResponse<LessonPlan>> generatePersonalizedLessonPlan() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.generateLessonPlan(currentUser.uid);
  }

  // Assessment methods
  Future<ApiResponse<FormalAssessment>> triggerAssessment(
    AssessmentType assessmentType,
    TriggerReason triggerReason,
    {String? notes}
  ) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    final trigger = AssessmentTrigger(
      userId: currentUser.uid,
      assessmentType: assessmentType,
      triggerReason: triggerReason,
      notes: notes,
    );
    return await _apiClient.triggerAssessment(currentUser.uid, trigger);
  }

  Future<ApiResponse<List<FormalAssessment>>> getUserAssessments({int limit = 10}) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUserAssessments(currentUser.uid, limit: limit);
  }

  Future<ApiResponse<Feedback>> getSessionFeedback(String sessionId) async {
    return await _apiClient.getSessionFeedback(sessionId);
  }

  // Reference methods
  Future<ApiResponse<List<SkillLevelDefinition>>> getSkillLevelDefinitions() async {
    return await _apiClient.getSkillLevelDefinitions();
  }

  Future<ApiResponse<List<ReferencePerformance>>> getReferencePerformances({
    String? exerciseId,
    SkillLevelEnum? skillLevel,
  }) async {
    return await _apiClient.getReferencePerformances(
      exerciseId: exerciseId,
      skillLevel: skillLevel,
    );
  }

  Future<ApiResponse<SkillMetrics>> getUserSkillMetrics() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }
    return await _apiClient.getUserSkillMetrics(currentUser.uid);
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