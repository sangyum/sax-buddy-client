import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/agents/models/assessment_models.dart';

void main() {
  group('Assessment Models Tests', () {
    group('QuestionnaireResponse', () {
      test('should serialize to and from JSON correctly', () {
        // Arrange
        final response = QuestionnaireResponse(
          experienceLevel: 'Just starting',
          hasFormalInstruction: false,
          instructionDuration: null,
          musicalGoals: ['Play my favorite songs', 'Learn improvisation'],
          readingLevel: MusicReadingLevel.basic,
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

        // Act
        final json = response.toJson();
        final restored = QuestionnaireResponse.fromJson(json);

        // Assert
        expect(restored.experienceLevel, response.experienceLevel);
        expect(restored.hasFormalInstruction, response.hasFormalInstruction);
        expect(restored.musicalGoals, response.musicalGoals);
        expect(restored.readingLevel, response.readingLevel);
        expect(restored.audioTests.length, response.audioTests.length);
        expect(restored.audioTests[0].testType, response.audioTests[0].testType);
        expect(restored.preferredLearningStyle, response.preferredLearningStyle);
        expect(restored.challenges, response.challenges);
      });
    });

    group('PerformanceAnalysis', () {
      test('should serialize to and from JSON correctly', () {
        // Arrange
        final analysis = PerformanceAnalysis(
          challengeId: 'basic_tone_test',
          facetScores: {
            'intonation': 0.85,
            'rhythm': 0.92,
            'tone': 0.78,
          },
          overallScore: 0.85,
          detectedIssues: ['Minor timing inconsistencies'],
          feedback: 'Great job overall! Focus on maintaining steady rhythm.',
          nextAction: 'stay_same',
        );

        // Act
        final json = analysis.toJson();
        final restored = PerformanceAnalysis.fromJson(json);

        // Assert
        expect(restored.challengeId, analysis.challengeId);
        expect(restored.facetScores, analysis.facetScores);
        expect(restored.overallScore, analysis.overallScore);
        expect(restored.detectedIssues, analysis.detectedIssues);
        expect(restored.feedback, analysis.feedback);
        expect(restored.nextAction, analysis.nextAction);
      });
    });

    group('SkillProfile', () {
      test('should serialize to and from JSON correctly', () {
        // Arrange
        final profile = SkillProfile(
          userId: 'user123',
          overallLevel: SkillLevel.beginnerLowIntermediate,
          facetAssessments: {
            'intonation': FacetAssessment(
              facetName: 'intonation',
              score: 0.75,
              level: SkillLevel.beginner,
              confidence: 0.8,
              description: 'Good pitch awareness',
              specificObservations: ['Consistent improvement'],
            ),
          },
          strengths: ['Rhythm', 'Motivation'],
          areasForImprovement: ['Tone production', 'Reading music'],
          confidenceScores: {
            'intonation': 0.8,
            'rhythm': 0.9,
          },
          recommendedNextSteps: [
            'Practice long tones',
            'Work on basic scales',
          ],
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        // Act
        final json = profile.toJson();
        final restored = SkillProfile.fromJson(json);

        // Assert
        expect(restored.userId, profile.userId);
        expect(restored.overallLevel, profile.overallLevel);
        expect(restored.facetAssessments.keys, profile.facetAssessments.keys);
        expect(restored.facetAssessments['intonation']!.score, 
               profile.facetAssessments['intonation']!.score);
        expect(restored.strengths, profile.strengths);
        expect(restored.areasForImprovement, profile.areasForImprovement);
        expect(restored.confidenceScores, profile.confidenceScores);
        expect(restored.recommendedNextSteps, profile.recommendedNextSteps);
        expect(restored.createdAt, profile.createdAt);
      });
    });

    group('AssessmentRequest', () {
      test('should serialize to and from JSON correctly', () {
        // Arrange
        final request = AssessmentRequest(
          userId: 'user123',
          phase: AssessmentPhase.microChallenges,
          data: {
            'challenge_id': 'basic_tone_test',
            'performance_data': {'score': 0.8},
          },
        );

        // Act
        final json = request.toJson();
        final restored = AssessmentRequest.fromJson(json);

        // Assert
        expect(restored.userId, request.userId);
        expect(restored.phase, request.phase);
        expect(restored.data, request.data);
      });
    });

    group('AssessmentResponse', () {
      test('should create success response correctly', () {
        // Arrange & Act
        final response = AssessmentResponse.success(
          AssessmentPhase.questionnaire,
          {'hypothesis': 'Beginner level'},
          'microChallenges',
        );

        // Assert
        expect(response.success, true);
        expect(response.phase, AssessmentPhase.questionnaire);
        expect(response.result['hypothesis'], 'Beginner level');
        expect(response.nextPhase, 'microChallenges');
        expect(response.error, null);
      });

      test('should create error response correctly', () {
        // Arrange & Act
        final response = AssessmentResponse.error(
          AssessmentPhase.microChallenges,
          'Analysis failed',
        );

        // Assert
        expect(response.success, false);
        expect(response.phase, AssessmentPhase.microChallenges);
        expect(response.error, 'Analysis failed');
        expect(response.result, isEmpty);
      });

      test('should serialize to and from JSON correctly', () {
        // Arrange
        final response = AssessmentResponse.success(
          AssessmentPhase.skillProfile,
          {'profile': 'data'},
        );

        // Act
        final json = response.toJson();
        final restored = AssessmentResponse.fromJson(json);

        // Assert
        expect(restored.success, response.success);
        expect(restored.phase, response.phase);
        expect(restored.result, response.result);
        expect(restored.nextPhase, response.nextPhase);
        expect(restored.error, response.error);
      });
    });


    group('Enums', () {
      test('should handle all enum values correctly', () {
        // Test AssessmentPhase
        expect(AssessmentPhase.values.length, 3);
        expect(AssessmentPhase.questionnaire.name, 'questionnaire');
        
        // Test SkillLevel
        expect(SkillLevel.values.length, 5);
        expect(SkillLevel.beginnerLowIntermediate.name, 'beginnerLowIntermediate');
        
        // Test LearningStyle
        expect(LearningStyle.values.length, 4);
        expect(LearningStyle.exercises.name, 'exercises');
        
        // Test MusicReadingLevel
        expect(MusicReadingLevel.values.length, 4);
        expect(MusicReadingLevel.fluent.name, 'fluent');
        
        // Test Challenge
        expect(Challenge.values.length, 5);
        expect(Challenge.fingerSpeed.name, 'fingerSpeed');
      });
    });
  });
}