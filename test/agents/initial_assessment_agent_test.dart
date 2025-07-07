import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sax_buddy/agents/models/assessment_models.dart';
import 'package:sax_buddy/agents/initial_assessment_agent.dart';
import 'package:sax_buddy/agents/services/llm_service.dart';
import 'package:sax_buddy/services/logging_service.dart';

import 'initial_assessment_agent_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LLMService>(),
  MockSpec<LoggingService>(),
])
void main() {
  group('InitialAssessmentAgent Tests', () {
    late InitialAssessmentAgent agent;
    late MockLLMService mockLLMService;
    late MockLoggingService mockLoggingService;

    setUp(() {
      mockLLMService = MockLLMService();
      mockLoggingService = MockLoggingService();
      agent = InitialAssessmentAgent(
        llmService: mockLLMService,
        loggingService: mockLoggingService,
      );
    });

    group('Phase 1: Questionnaire Processing', () {
      test('should process questionnaire and generate initial hypothesis', () async {
        // Arrange
        final questionnaireResponse = QuestionnaireResponse(
          experienceLevel: 'Just starting',
          hasFormalInstruction: false,
          musicalGoals: ['Play my favorite songs'],
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

        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.questionnaire,
          data: questionnaireResponse.toJson(),
        );

        when(mockLLMService.processQuestionnaire(any))
            .thenAnswer((_) async => {
              'initial_hypothesis': 'Beginner level, likely needs foundational work on tone and basic notes',
              'suggested_difficulty': 'very_basic',
              'target_facets': ['tone', 'basic_rhythm'],
              'confidence': 0.8,
            });

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        expect(result.success, true);
        expect(result.phase, AssessmentPhase.questionnaire);
        expect(result.nextPhase, 'microChallenges');
        expect(result.result['initial_hypothesis'], contains('Beginner'));
        verify(mockLLMService.processQuestionnaire(any)).called(1);
        verify(mockLoggingService.logInfo(any, data: anyNamed('data'))).called(1);
      });

      test('should handle questionnaire processing errors', () async {
        // Arrange
        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.questionnaire,
          data: {},
        );

        when(mockLLMService.processQuestionnaire(any))
            .thenThrow(Exception('LLM service error'));

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        expect(result.success, false);
        expect(result.error, contains('LLM service error'));
        verify(mockLoggingService.logError(any, error: anyNamed('error'))).called(1);
      });
    });

    group('Phase 2: Micro-Challenge Analysis', () {
      test('should analyze performance and provide adaptive feedback', () async {
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

        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.microChallenges,
          data: performanceData,
        );

        when(mockLLMService.analyzePerformance(any))
            .thenAnswer((_) async => PerformanceAnalysis(
              challengeId: 'basic_tone_test',
              facetScores: {
                'intonation': 0.7,
                'rhythm': 0.9,
                'tone': 0.6,
              },
              overallScore: 0.73,
              detectedIssues: ['Tone quality needs improvement'],
              feedback: 'Good rhythm! Let\'s work on getting a clearer, more consistent tone.',
              nextAction: 'stay_same',
            ));

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        expect(result.success, true);
        expect(result.phase, AssessmentPhase.microChallenges);
        final analysis = PerformanceAnalysis.fromJson(result.result);
        expect(analysis.overallScore, 0.73);
        expect(analysis.nextAction, 'stay_same');
        expect(analysis.feedback, contains('Good rhythm'));
        verify(mockLLMService.analyzePerformance(any)).called(1);
      });

      test('should recommend stepping up difficulty for high performance', () async {
        // Arrange
        final performanceData = {
          'challenge_id': 'basic_tone_test',
          'audio_analysis': {
            'intonation_score': 0.95,
            'rhythm_score': 0.92,
            'tone_quality': 0.88,
          },
        };

        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.microChallenges,
          data: performanceData,
        );

        when(mockLLMService.analyzePerformance(any))
            .thenAnswer((_) async => PerformanceAnalysis(
              challengeId: 'basic_tone_test',
              facetScores: {
                'intonation': 0.95,
                'rhythm': 0.92,
                'tone': 0.88,
              },
              overallScore: 0.92,
              detectedIssues: [],
              feedback: 'Excellent work! You\'re ready for something more challenging.',
              nextAction: 'step_up',
            ));

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        final analysis = PerformanceAnalysis.fromJson(result.result);
        expect(analysis.nextAction, 'step_up');
        expect(analysis.overallScore, greaterThan(0.9));
      });

      test('should recommend stepping down difficulty for poor performance', () async {
        // Arrange
        final performanceData = {
          'challenge_id': 'basic_tone_test',
          'audio_analysis': {
            'intonation_score': 0.3,
            'rhythm_score': 0.4,
            'tone_quality': 0.2,
          },
        };

        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.microChallenges,
          data: performanceData,
        );

        when(mockLLMService.analyzePerformance(any))
            .thenAnswer((_) async => PerformanceAnalysis(
              challengeId: 'basic_tone_test',
              facetScores: {
                'intonation': 0.3,
                'rhythm': 0.4,
                'tone': 0.2,
              },
              overallScore: 0.3,
              detectedIssues: ['Fundamental tone production issues', 'Timing struggles'],
              feedback: 'Let\'s take a step back and focus on the basics. Try producing a clear, steady tone on just one note.',
              nextAction: 'step_down',
            ));

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        final analysis = PerformanceAnalysis.fromJson(result.result);
        expect(analysis.nextAction, 'step_down');
        expect(analysis.overallScore, lessThan(0.5));
        expect(analysis.feedback, contains('step back'));
      });
    });

    group('Phase 3: Skill Profile Generation', () {
      test('should generate comprehensive skill profile from consolidated data', () async {
        // Arrange
        final consolidatedData = {
          'questionnaire': {
            'experience_level': 'Just starting',
            'challenges': ['tone', 'reading_music'],
          },
          'performance_history': [
            {
              'challenge_id': 'basic_tone_1',
              'facet_scores': {'intonation': 0.7, 'rhythm': 0.8, 'tone': 0.6},
            },
            {
              'challenge_id': 'basic_tone_2',
              'facet_scores': {'intonation': 0.75, 'rhythm': 0.85, 'tone': 0.65},
            },
          ],
          'total_session_time': 12.5,
          'challenges_attempted': 3,
        };

        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.skillProfile,
          data: consolidatedData,
        );

        final expectedProfile = SkillProfile(
          userId: 'user123',
          overallLevel: SkillLevel.beginner,
          facetAssessments: {
            'intonation': FacetAssessment(
              facetName: 'intonation',
              score: 0.725,
              level: SkillLevel.beginner,
              confidence: 0.8,
              description: 'Shows good pitch awareness for a beginner',
              specificObservations: ['Consistent improvement across attempts'],
            ),
            'rhythm': FacetAssessment(
              facetName: 'rhythm',
              score: 0.825,
              level: SkillLevel.beginnerLowIntermediate,
              confidence: 0.9,
              description: 'Strong natural rhythm sense',
              specificObservations: ['Excellent timing consistency'],
            ),
            'tone': FacetAssessment(
              facetName: 'tone',
              score: 0.625,
              level: SkillLevel.beginner,
              confidence: 0.7,
              description: 'Needs work on tone production fundamentals',
              specificObservations: ['Some improvement shown', 'Focus area for development'],
            ),
          },
          strengths: ['Rhythm', 'Learning consistency'],
          areasForImprovement: ['Tone production', 'Basic note reading'],
          confidenceScores: {
            'intonation': 0.8,
            'rhythm': 0.9,
            'tone': 0.7,
          },
          recommendedNextSteps: [
            'Focus on long tone exercises',
            'Practice basic scales slowly',
            'Work on breath support techniques',
          ],
          createdAt: DateTime.now(),
        );

        when(mockLLMService.generateSkillProfile(any))
            .thenAnswer((_) async => expectedProfile);

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        expect(result.success, true);
        expect(result.phase, AssessmentPhase.skillProfile);
        final profile = SkillProfile.fromJson(result.result);
        expect(profile.overallLevel, SkillLevel.beginner);
        expect(profile.strengths, contains('Rhythm'));
        expect(profile.areasForImprovement, contains('Tone production'));
        expect(profile.facetAssessments.keys, contains('intonation'));
        expect(profile.facetAssessments['rhythm']!.level, SkillLevel.beginnerLowIntermediate);
        verify(mockLLMService.generateSkillProfile(any)).called(1);
      });
    });


    group('Error Handling', () {
      test('should handle invalid phase gracefully', () async {
        // Arrange
        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.questionnaire, // Valid phase but invalid data
          data: {'invalid': 'data'},
        );

        when(mockLLMService.processQuestionnaire(any))
            .thenThrow(ArgumentError('Invalid questionnaire data'));

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        expect(result.success, false);
        expect(result.error, contains('Invalid questionnaire data'));
      });

      test('should handle LLM service unavailable', () async {
        // Arrange
        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.questionnaire,
          data: {},
        );

        when(mockLLMService.processQuestionnaire(any))
            .thenThrow(Exception('Service unavailable'));

        // Act
        final result = await agent.processAssessment(request);

        // Assert
        expect(result.success, false);
        expect(result.error, contains('Service unavailable'));
      });
    });
  });
}