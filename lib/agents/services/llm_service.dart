import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:ollama_dart/ollama_dart.dart';
import '../models/assessment_models.dart';
import '../../services/logging_service.dart';

class LLMService {
  final LoggingService _logger = LoggingService();
  late final String _environment;
  late final String _modelName;
  
  // Native LLM clients
  OllamaClient? _ollamaClient;

  LLMService() {
    _initializeModel();
  }

  void _initializeModel() {
    _environment = dotenv.env['ENVIRONMENT'] ?? 'development';
    
    if (_environment == 'production') {
      _initializeOpenAI();
    } else {
      _initializeOllama();
    }
    
    _logger.logInfo('LLM Service initialized for $_environment environment');
  }

  void _initializeOpenAI() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    _modelName = dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o-mini';
    
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY not found in environment variables');
    }
    
    // Initialize dart_openai client
    OpenAI.apiKey = apiKey;
    _logger.logInfo('OpenAI client initialized: $_modelName');
  }

  void _initializeOllama() {
    final baseUrl = dotenv.env['OLLAMA_BASE_URL'] ?? 'http://localhost:11434/api';
    _modelName = dotenv.env['OLLAMA_MODEL'] ?? 'llama3.2:3b';
    
    // Initialize ollama_dart client
    _ollamaClient = OllamaClient(baseUrl: baseUrl);
    _logger.logInfo('Ollama client initialized: $_modelName at $baseUrl');
  }


  Future<Map<String, dynamic>> processQuestionnaire(QuestionnaireResponse response) async {
    try {
      _logger.logInfo('Processing questionnaire with real LLM');
      
      final prompt = _buildQuestionnairePrompt(response);
      
      if (_environment == 'production') {
        return await _processWithOpenAI(prompt);
      } else {
        return await _processWithOllama(prompt);
      }
    } catch (e) {
      _logger.logError('Error processing questionnaire', error: e);
      rethrow;
    }
  }

  String _buildQuestionnairePrompt(QuestionnaireResponse response) {
    return '''
You are an expert saxophone instructor analyzing a student's initial assessment questionnaire.

Student Information:
- Experience Level: ${response.experienceLevel}
- Has Formal Instruction: ${response.hasFormalInstruction}
- Musical Goals: ${response.musicalGoals.join(', ')}
- Music Reading Level: ${response.readingLevel.name}
- Preferred Learning Style: ${response.preferredLearningStyle.name}
- Challenges: ${response.challenges.map((c) => c.name).join(', ')}
- Audio Test Results: ${response.audioTests.length} tests completed

Based on this information, provide a JSON response with:
{
  "initial_hypothesis": "Brief assessment of skill level and potential",
  "suggested_difficulty": "very_easy|easy|medium|hard",
  "target_facets": ["list", "of", "musical", "facets", "to", "focus", "on"],
  "confidence": 0.0-1.0,
  "learning_style_notes": "Notes about their learning preferences",
  "priority_areas": ["areas", "that", "need", "attention"]
}

Respond with only the JSON object, no additional text.
''';
  }

  Future<Map<String, dynamic>> _processWithOpenAI(String prompt) async {
    final completion = await OpenAI.instance.chat.create(
      model: _modelName,
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
          role: OpenAIChatMessageRole.user,
        ),
      ],
      temperature: 0.3, // Lower temperature for more consistent results
    );

    final content = completion.choices.first.message.content?.first.text ?? '';
    return _parseJsonResponse(content);
  }

  Future<Map<String, dynamic>> _processWithOllama(String prompt) async {
    final response = await _ollamaClient!.generateCompletion(
      request: GenerateCompletionRequest(
        model: _modelName,
        prompt: prompt,
        options: RequestOptions(temperature: 0.3),
      ),
    );

    return _parseJsonResponse(response.response ?? '');
  }

  Map<String, dynamic> _parseJsonResponse(String content) {
    try {
      // Find JSON object in response
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd <= jsonStart) {
        throw FormatException('No valid JSON found in LLM response');
      }
      
      final jsonString = content.substring(jsonStart, jsonEnd);
      return Map<String, dynamic>.from(
        jsonDecode(jsonString)
      );
    } catch (e) {
      _logger.logError('Error parsing LLM JSON response', error: e);
      // Return fallback response
      return {
        'initial_hypothesis': 'Unable to process - please try again',
        'suggested_difficulty': 'easy',
        'target_facets': ['tone_quality'],
        'confidence': 0.3,
        'learning_style_notes': 'Assessment needs to be repeated',
        'priority_areas': ['basic_skills'],
      };
    }
  }

  Future<PerformanceAnalysis> analyzePerformance(Map<String, dynamic> performanceData) async {
    try {
      _logger.logInfo('Analyzing performance with real LLM');
      
      final prompt = _buildPerformancePrompt(performanceData);
      
      Map<String, dynamic> result;
      if (_environment == 'production') {
        result = await _processWithOpenAI(prompt);
      } else {
        result = await _processWithOllama(prompt);
      }
      
      return PerformanceAnalysis.fromJson(result);
    } catch (e) {
      _logger.logError('Error analyzing performance', error: e);
      rethrow;
    }
  }

  String _buildPerformancePrompt(Map<String, dynamic> performanceData) {
    return '''
You are an expert saxophone instructor analyzing a student's performance data.

Performance Data:
- Challenge ID: ${performanceData['challenge_id']}
- Audio Analysis: ${performanceData['audio_analysis']}
- Attempt Count: ${performanceData['attempt_count'] ?? 1}
- Duration: ${performanceData['duration'] ?? 'Unknown'}
- Previous Performance: ${performanceData['previous_performance'] ?? 'None'}

Analyze the performance across these facets:
- Intonation (pitch accuracy)
- Rhythm (timing consistency)  
- Tone Quality (sound clarity and consistency)
- Articulation (note attacks and releases)

Determine the appropriate next action:
- "step_up": Performance was excellent (>0.85 overall), increase difficulty
- "stay_same": Performance was moderate (0.5-0.85), try similar challenge or focus on specific issue
- "step_down": Performance was poor (<0.5), reduce difficulty or break down further

Provide response in this exact JSON format:
{
  "challenge_id": "${performanceData['challenge_id']}",
  "facet_scores": {
    "intonation": 0.0-1.0,
    "rhythm": 0.0-1.0,
    "tone": 0.0-1.0,
    "articulation": 0.0-1.0
  },
  "overall_score": 0.0-1.0,
  "detected_issues": ["specific", "issues", "identified"],
  "feedback": "Encouraging, specific feedback with concrete next steps",
  "next_action": "step_up|stay_same|step_down"
}

Respond with only the JSON object, no additional text.
''';
  }

  Future<SkillProfile> generateSkillProfile(Map<String, dynamic> consolidatedData) async {
    try {
      _logger.logInfo('Generating skill profile with real LLM');
      
      final prompt = _buildSkillProfilePrompt(consolidatedData);
      
      Map<String, dynamic> result;
      if (_environment == 'production') {
        result = await _processWithOpenAI(prompt);
      } else {
        result = await _processWithOllama(prompt);
      }
      
      return SkillProfile.fromJson(result);
    } catch (e) {
      _logger.logError('Error generating skill profile', error: e);
      rethrow;
    }
  }

  String _buildSkillProfilePrompt(Map<String, dynamic> consolidatedData) {
    return '''
You are an expert saxophone instructor creating a comprehensive skill profile from all assessment data.

Consolidated Assessment Data:
${_formatConsolidatedData(consolidatedData)}

Create a comprehensive skill profile that includes:
1. Overall skill level assessment
2. Detailed facet-by-facet analysis with confidence scores
3. Clear identification of strengths and areas for improvement
4. Specific, actionable next steps tailored to their goals and learning style
5. Encouraging tone that acknowledges progress and potential

Consider the full journey from questionnaire through micro-challenges.
Focus on growth mindset and specific, achievable next steps.

Provide the complete SkillProfile as JSON following this exact structure:
{
  "user_id": "${consolidatedData['userId'] ?? 'unknown'}",
  "overall_level": "beginner|beginnerLowIntermediate|intermediate|intermediateAdvanced|advanced",
  "facet_assessments": {
    "intonation": {
      "facet_name": "intonation",
      "score": 0.0-1.0,
      "level": "beginner|beginnerLowIntermediate|intermediate|intermediateAdvanced|advanced",
      "confidence": 0.0-1.0,
      "description": "Brief description",
      "specific_observations": ["observation1", "observation2"]
    },
    "rhythm": {
      "facet_name": "rhythm",
      "score": 0.0-1.0,
      "level": "beginner|beginnerLowIntermediate|intermediate|intermediateAdvanced|advanced",
      "confidence": 0.0-1.0,
      "description": "Brief description",
      "specific_observations": ["observation1", "observation2"]
    }
  },
  "strengths": ["strength1", "strength2"],
  "areas_for_improvement": ["area1", "area2"],
  "confidence_scores": {
    "intonation": 0.0-1.0,
    "rhythm": 0.0-1.0,
    "tone": 0.0-1.0
  },
  "recommended_next_steps": ["step1", "step2", "step3"],
  "created_at": "${DateTime.now().toIso8601String()}"
}

Respond with only the JSON object, no additional text.
''';
  }

  String _formatConsolidatedData(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    
    if (data.containsKey('questionnaire')) {
      buffer.writeln('Questionnaire Results:');
      buffer.writeln('${data['questionnaire']}');
    }
    
    if (data.containsKey('performance_history')) {
      buffer.writeln('\nPerformance History:');
      final history = data['performance_history'] as List;
      for (int i = 0; i < history.length; i++) {
        buffer.writeln('Challenge ${i + 1}: ${history[i]}');
      }
    }
    
    if (data.containsKey('total_session_time')) {
      buffer.writeln('\nSession Duration: ${data['total_session_time']} minutes');
    }
    
    if (data.containsKey('challenges_attempted')) {
      buffer.writeln('Challenges Attempted: ${data['challenges_attempted']}');
    }
    
    return buffer.toString();
  }




}