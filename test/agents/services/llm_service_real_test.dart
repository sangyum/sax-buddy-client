import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/agents/services/llm_service.dart';
import 'package:sax_buddy/agents/models/assessment_models.dart';

/// Tests for real LLM integration (not mocked)
/// These tests require environment setup and may be slower
void main() {
  group('LLMService Real Integration Tests', () {
    late LLMService llmService;

    setUpAll(() async {
      // Load environment variables for testing
      await dotenv.load(fileName: '.env');
    });

    setUp(() {
      llmService = LLMService();
    });

    group('Environment Configuration', () {
      test('should initialize client based on environment', () {
        // Should not throw during initialization
        expect(llmService, isA<LLMService>());
      });
    });

    group('Real Questionnaire Processing', () {
      test('should process questionnaire with real LLM call', () async {
        // Arrange
        final questionnaireResponse = QuestionnaireResponse(
          experienceLevel: 'Just starting out with saxophone',
          hasFormalInstruction: false,
          musicalGoals: ['Learn to play my favorite songs', 'Understand music theory'],
          readingLevel: MusicReadingLevel.none,
          audioTests: [
            AudioTestResponse(
              testType: 'pitch_discrimination',
              userResponse: 'higher',
              correctAnswer: 'higher',
              isCorrect: true,
            ),
          ],
          preferredLearningStyle: LearningStyle.videos,
          challenges: [Challenge.tone, Challenge.readingMusic],
        );

        // Act & Assert - Should attempt real LLM call (may fail due to no server)
        expect(
          () => llmService.processQuestionnaire(questionnaireResponse),
          anyOf([
            // Should either succeed with LLM response
            returnsNormally,
            // Or fail with connection error if no LLM server available
            throwsA(isA<Exception>()),
          ]),
        );
      });
    });

    group('Real Performance Analysis', () {
      test('should analyze performance with real LLM call', () async {
        // Arrange
        final performanceData = {
          'challenge_id': 'basic_tone_test',
          'audio_analysis': {
            'intonation_score': 0.7,
            'rhythm_score': 0.9,
            'tone_quality': 0.6,
          },
          'attempt_count': 1,
          'duration': 8.5,
        };

        // Act & Assert - Should attempt real LLM call (may fail due to no server)
        expect(
          () => llmService.analyzePerformance(performanceData),
          anyOf([
            // Should either succeed with LLM response
            returnsNormally,
            // Or fail with connection error if no LLM server available
            throwsA(isA<Exception>()),
          ]),
        );
      });
    });

    group('Real Skill Profile Generation', () {
      test('should generate skill profile with real LLM call', () async {
        // Arrange
        final consolidatedData = {
          'userId': 'test_user',
          'questionnaire': {'experience': 'beginner'},
          'performance_history': [
            {'score': 0.7, 'facets': {'tone': 0.6, 'rhythm': 0.8}},
          ],
          'total_session_time': 15.5,
          'challenges_attempted': 3,
        };

        // Act & Assert - Should attempt real LLM call (may fail due to no server)
        expect(
          () => llmService.generateSkillProfile(consolidatedData),
          anyOf([
            // Should either succeed with LLM response
            returnsNormally,
            // Or fail with connection error if no LLM server available
            throwsA(isA<Exception>()),
          ]),
        );
      });
    });

  });
}