// Assessment data models for InitialAssessmentAgent

enum AssessmentPhase { 
  questionnaire, 
  microChallenges, 
  skillProfile 
}

enum SkillLevel { 
  beginner, 
  beginnerLowIntermediate, 
  intermediate, 
  intermediateAdvanced, 
  advanced 
}

enum LearningStyle { 
  videos, 
  exercises, 
  fullSongs, 
  theory 
}

enum MusicReadingLevel { 
  none, 
  basic, 
  mostNotes, 
  fluent 
}

enum Challenge { 
  tone, 
  intonation, 
  rhythm, 
  fingerSpeed, 
  readingMusic 
}

// Phase 1: Questionnaire Models
class QuestionnaireResponse {
  final String experienceLevel;
  final bool hasFormalInstruction;
  final String? instructionDuration;
  final List<String> musicalGoals;
  final MusicReadingLevel readingLevel;
  final List<AudioTestResponse> audioTests;
  final LearningStyle preferredLearningStyle;
  final List<Challenge> challenges;

  QuestionnaireResponse({
    required this.experienceLevel,
    required this.hasFormalInstruction,
    this.instructionDuration,
    required this.musicalGoals,
    required this.readingLevel,
    required this.audioTests,
    required this.preferredLearningStyle,
    required this.challenges,
  });

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    return QuestionnaireResponse(
      experienceLevel: json['experience_level'],
      hasFormalInstruction: json['has_formal_instruction'],
      instructionDuration: json['instruction_duration'],
      musicalGoals: List<String>.from(json['musical_goals']),
      readingLevel: MusicReadingLevel.values.byName(json['reading_level']),
      audioTests: (json['audio_tests'] as List)
          .map((test) => AudioTestResponse.fromJson(test))
          .toList(),
      preferredLearningStyle: LearningStyle.values.byName(json['preferred_learning_style']),
      challenges: (json['challenges'] as List)
          .map((challenge) => Challenge.values.byName(challenge))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experience_level': experienceLevel,
      'has_formal_instruction': hasFormalInstruction,
      'instruction_duration': instructionDuration,
      'musical_goals': musicalGoals,
      'reading_level': readingLevel.name,
      'audio_tests': audioTests.map((test) => test.toJson()).toList(),
      'preferred_learning_style': preferredLearningStyle.name,
      'challenges': challenges.map((challenge) => challenge.name).toList(),
    };
  }
}

class AudioTestResponse {
  final String testType;
  final String userResponse;
  final String correctAnswer;
  final bool isCorrect;

  AudioTestResponse({
    required this.testType,
    required this.userResponse,
    required this.correctAnswer,
    required this.isCorrect,
  });

  factory AudioTestResponse.fromJson(Map<String, dynamic> json) {
    return AudioTestResponse(
      testType: json['test_type'],
      userResponse: json['user_response'],
      correctAnswer: json['correct_answer'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'test_type': testType,
      'user_response': userResponse,
      'correct_answer': correctAnswer,
      'is_correct': isCorrect,
    };
  }
}

// Phase 2: Micro-Challenge Models
class MicroChallengeRequest {
  final String challengeId;
  final String difficulty;
  final List<String> targetFacets;
  final Map<String, dynamic> challengeParameters;

  MicroChallengeRequest({
    required this.challengeId,
    required this.difficulty,
    required this.targetFacets,
    required this.challengeParameters,
  });

  factory MicroChallengeRequest.fromJson(Map<String, dynamic> json) {
    return MicroChallengeRequest(
      challengeId: json['challenge_id'],
      difficulty: json['difficulty'],
      targetFacets: List<String>.from(json['target_facets']),
      challengeParameters: json['challenge_parameters'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'difficulty': difficulty,
      'target_facets': targetFacets,
      'challenge_parameters': challengeParameters,
    };
  }
}

class PerformanceAnalysis {
  final String challengeId;
  final Map<String, double> facetScores;
  final double overallScore;
  final List<String> detectedIssues;
  final String feedback;
  final String nextAction; // 'step_up', 'stay_same', 'step_down'

  PerformanceAnalysis({
    required this.challengeId,
    required this.facetScores,
    required this.overallScore,
    required this.detectedIssues,
    required this.feedback,
    required this.nextAction,
  });

  factory PerformanceAnalysis.fromJson(Map<String, dynamic> json) {
    return PerformanceAnalysis(
      challengeId: json['challenge_id'],
      facetScores: Map<String, double>.from(json['facet_scores']),
      overallScore: json['overall_score'].toDouble(),
      detectedIssues: List<String>.from(json['detected_issues']),
      feedback: json['feedback'],
      nextAction: json['next_action'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'facet_scores': facetScores,
      'overall_score': overallScore,
      'detected_issues': detectedIssues,
      'feedback': feedback,
      'next_action': nextAction,
    };
  }
}

// Phase 3: Skill Profile Models
class SkillProfile {
  final String userId;
  final SkillLevel overallLevel;
  final Map<String, FacetAssessment> facetAssessments;
  final List<String> strengths;
  final List<String> areasForImprovement;
  final Map<String, double> confidenceScores;
  final List<String> recommendedNextSteps;
  final DateTime createdAt;

  SkillProfile({
    required this.userId,
    required this.overallLevel,
    required this.facetAssessments,
    required this.strengths,
    required this.areasForImprovement,
    required this.confidenceScores,
    required this.recommendedNextSteps,
    required this.createdAt,
  });

  factory SkillProfile.fromJson(Map<String, dynamic> json) {
    return SkillProfile(
      userId: json['user_id'],
      overallLevel: SkillLevel.values.byName(json['overall_level']),
      facetAssessments: (json['facet_assessments'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, FacetAssessment.fromJson(value))),
      strengths: List<String>.from(json['strengths']),
      areasForImprovement: List<String>.from(json['areas_for_improvement']),
      confidenceScores: Map<String, double>.from(json['confidence_scores']),
      recommendedNextSteps: List<String>.from(json['recommended_next_steps']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'overall_level': overallLevel.name,
      'facet_assessments': facetAssessments
          .map((key, value) => MapEntry(key, value.toJson())),
      'strengths': strengths,
      'areas_for_improvement': areasForImprovement,
      'confidence_scores': confidenceScores,
      'recommended_next_steps': recommendedNextSteps,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class FacetAssessment {
  final String facetName;
  final double score;
  final SkillLevel level;
  final double confidence;
  final String description;
  final List<String> specificObservations;

  FacetAssessment({
    required this.facetName,
    required this.score,
    required this.level,
    required this.confidence,
    required this.description,
    required this.specificObservations,
  });

  factory FacetAssessment.fromJson(Map<String, dynamic> json) {
    return FacetAssessment(
      facetName: json['facet_name'],
      score: json['score'].toDouble(),
      level: SkillLevel.values.byName(json['level']),
      confidence: json['confidence'].toDouble(),
      description: json['description'],
      specificObservations: List<String>.from(json['specific_observations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facet_name': facetName,
      'score': score,
      'level': level.name,
      'confidence': confidence,
      'description': description,
      'specific_observations': specificObservations,
    };
  }
}

// Assessment Request/Response Models
class AssessmentRequest {
  final String userId;
  final AssessmentPhase phase;
  final Map<String, dynamic> data;

  AssessmentRequest({
    required this.userId,
    required this.phase,
    required this.data,
  });

  factory AssessmentRequest.fromJson(Map<String, dynamic> json) {
    return AssessmentRequest(
      userId: json['user_id'],
      phase: AssessmentPhase.values.byName(json['phase']),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phase': phase.name,
      'data': data,
    };
  }
}

class AssessmentResponse {
  final bool success;
  final AssessmentPhase phase;
  final Map<String, dynamic> result;
  final String? nextPhase;
  final String? error;

  AssessmentResponse({
    required this.success,
    required this.phase,
    required this.result,
    this.nextPhase,
    this.error,
  });

  factory AssessmentResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentResponse(
      success: json['success'],
      phase: AssessmentPhase.values.byName(json['phase']),
      result: json['result'],
      nextPhase: json['next_phase'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'phase': phase.name,
      'result': result,
      'next_phase': nextPhase,
      'error': error,
    };
  }

  factory AssessmentResponse.success(
    AssessmentPhase phase,
    Map<String, dynamic> result, [
    String? nextPhase,
  ]) {
    return AssessmentResponse(
      success: true,
      phase: phase,
      result: result,
      nextPhase: nextPhase,
    );
  }

  factory AssessmentResponse.error(AssessmentPhase phase, String error) {
    return AssessmentResponse(
      success: false,
      phase: phase,
      result: {},
      error: error,
    );
  }
}

