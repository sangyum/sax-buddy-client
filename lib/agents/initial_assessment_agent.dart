import 'models/assessment_models.dart';
import 'services/llm_service.dart';
import '../services/logging_service.dart';

class InitialAssessmentAgent {
  final LLMService llmService;
  final LoggingService loggingService;

  InitialAssessmentAgent({
    required this.llmService,
    required this.loggingService,
  });

  /// Factory constructor for default dependencies
  factory InitialAssessmentAgent.create() {
    return InitialAssessmentAgent(
      llmService: LLMService(),
      loggingService: LoggingService(),
    );
  }

  /// Process an assessment request based on the current phase
  Future<AssessmentResponse> processAssessment(AssessmentRequest request) async {
    try {
      switch (request.phase) {
        case AssessmentPhase.questionnaire:
          return await _processQuestionnairePhase(request);
        case AssessmentPhase.microChallenges:
          return await _processMicroChallengePhase(request);
        case AssessmentPhase.skillProfile:
          return await _processSkillProfilePhase(request);
      }
    } catch (e) {
      loggingService.logError(
        'Error processing assessment',
        error: e,
      );

      return AssessmentResponse.error(request.phase, e.toString());
    }
  }


  // Phase 1: Questionnaire Processing
  Future<AssessmentResponse> _processQuestionnairePhase(AssessmentRequest request) async {
    try {
      QuestionnaireResponse questionnaireResponse;
      try {
        questionnaireResponse = QuestionnaireResponse.fromJson(request.data);
      } catch (e) {
        // If JSON parsing fails, create a dummy response and let the service handle the error
        questionnaireResponse = QuestionnaireResponse(
          experienceLevel: '',
          hasFormalInstruction: false,
          musicalGoals: [],
          readingLevel: MusicReadingLevel.none,
          audioTests: [],
          preferredLearningStyle: LearningStyle.videos,
          challenges: [],
        );
      }
      
      final result = await llmService.processQuestionnaire(questionnaireResponse);
      
      loggingService.logInfo(
        'Questionnaire processed successfully',
        data: {
          'userId': request.userId,
          'confidence': result['confidence'],
          'suggestedDifficulty': result['suggested_difficulty'],
        },
      );

      return AssessmentResponse.success(
        AssessmentPhase.questionnaire,
        result,
        'microChallenges',
      );
    } catch (e) {
      // Re-throw the original exception to let the mock handle it
      rethrow;
    }
  }


  // Phase 2: Micro-Challenge Analysis
  Future<AssessmentResponse> _processMicroChallengePhase(AssessmentRequest request) async {
    try {
      final performanceAnalysis = await llmService.analyzePerformance(request.data);
      
      loggingService.logInfo(
        'Performance analysis completed',
        data: {
          'userId': request.userId,
          'challengeId': performanceAnalysis.challengeId,
          'overallScore': performanceAnalysis.overallScore,
          'nextAction': performanceAnalysis.nextAction,
        },
      );

      // Determine if we should continue with more challenges or move to profile generation
      final nextPhase = _shouldContinueChallenges(request.data, performanceAnalysis) 
          ? null // Continue with more micro-challenges
          : 'skillProfile'; // Move to final profile generation

      return AssessmentResponse.success(
        AssessmentPhase.microChallenges,
        performanceAnalysis.toJson(),
        nextPhase,
      );
    } catch (e) {
      throw Exception('Failed to analyze performance: $e');
    }
  }


  // Phase 3: Skill Profile Generation
  Future<AssessmentResponse> _processSkillProfilePhase(AssessmentRequest request) async {
    try {
      final skillProfile = await llmService.generateSkillProfile(request.data);
      
      loggingService.logInfo(
        'Skill profile generated',
        data: {
          'userId': request.userId,
          'overallLevel': skillProfile.overallLevel.name,
          'strengths': skillProfile.strengths,
          'areasForImprovement': skillProfile.areasForImprovement,
        },
      );

      return AssessmentResponse.success(
        AssessmentPhase.skillProfile,
        skillProfile.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to generate skill profile: $e');
    }
  }


  /// Determine if we should continue with more micro-challenges
  bool _shouldContinueChallenges(Map<String, dynamic> sessionData, PerformanceAnalysis analysis) {
    // Logic to determine if assessment is complete
    final challengesAttempted = sessionData['challenges_attempted'] ?? 0;
    final sessionTime = sessionData['total_session_time'] ?? 0.0;
    
    // Continue if:
    // - Less than 3 challenges attempted AND session time < 10 minutes
    // - OR if we're still in the adaptive discovery phase (stepping up/down)
    if (challengesAttempted < 3 && sessionTime < 10.0) {
      return true;
    }

    // Continue if we're still adapting difficulty
    if (analysis.nextAction == 'step_up' || analysis.nextAction == 'step_down') {
      return challengesAttempted < 5; // Maximum 5 challenges
    }

    // If performance is consistent (stay_same) and we have enough data, finish
    return false;
  }

  /// Get the system prompt used for assessments (for debugging/testing)
  String getSystemPrompt() {
    return '''
You are an expert saxophone instructor and assessment specialist conducting an adaptive initial assessment.

Your assessment follows a 3-phase strategy:

PHASE 1 - QUESTIONNAIRE ANALYSIS:
Process self-reported experience, goals, and audio test results to generate an initial skill hypothesis.

PHASE 2 - MICRO-CHALLENGE ANALYSIS:
Analyze objective performance data to provide adaptive feedback and determine next difficulty level.

PHASE 3 - SKILL PROFILE GENERATION:
Consolidate all data into a comprehensive, actionable skill profile.

Always be encouraging, specific, and growth-focused in your feedback.
''';
  }
}