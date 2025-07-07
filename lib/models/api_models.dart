// Data models for Sax Buddy API

// User models
class User {
  final String id;
  final String email;
  final String? name;
  final String? skillLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.name,
    this.skillLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      skillLevel: json['skill_level'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'skill_level': skillLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreateUserRequest {
  final String email;
  final String? name;
  final String? skillLevel;

  CreateUserRequest({
    required this.email,
    this.name,
    this.skillLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'skill_level': skillLevel,
    };
  }
}

// Performance models
class PerformanceSession {
  final String id;
  final String userId;
  final String? exerciseId;
  final DateTime startTime;
  final DateTime? endTime;
  final Map<String, double>? metrics;
  final String? recordingUrl;
  final String? feedback;

  PerformanceSession({
    required this.id,
    required this.userId,
    this.exerciseId,
    required this.startTime,
    this.endTime,
    this.metrics,
    this.recordingUrl,
    this.feedback,
  });

  factory PerformanceSession.fromJson(Map<String, dynamic> json) {
    return PerformanceSession(
      id: json['id'],
      userId: json['user_id'],
      exerciseId: json['exercise_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      metrics: json['metrics'] != null ? Map<String, double>.from(json['metrics']) : null,
      recordingUrl: json['recording_url'],
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'metrics': metrics,
      'recording_url': recordingUrl,
      'feedback': feedback,
    };
  }
}

class CreatePerformanceSessionRequest {
  final String exerciseId;
  final String? recordingUrl;

  CreatePerformanceSessionRequest({
    required this.exerciseId,
    this.recordingUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'recording_url': recordingUrl,
    };
  }
}

// Exercise models
class Exercise {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final String? category;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    this.category,
    this.metadata,
    required this.createdAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      category: json['category'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'category': category,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Lesson models
class Lesson {
  final String id;
  final String title;
  final String description;
  final List<String> exerciseIds;
  final int order;
  final String? category;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.exerciseIds,
    required this.order,
    this.category,
    required this.createdAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      exerciseIds: List<String>.from(json['exercise_ids']),
      order: json['order'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exercise_ids': exerciseIds,
      'order': order,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class LessonPlan {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> lessonIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.lessonIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonPlan.fromJson(Map<String, dynamic> json) {
    return LessonPlan(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      lessonIds: List<String>.from(json['lesson_ids']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'lesson_ids': lessonIds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Assessment models
class Assessment {
  final String id;
  final String userId;
  final String sessionId;
  final Map<String, double> scores;
  final String? overallFeedback;
  final DateTime createdAt;

  Assessment({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.scores,
    this.overallFeedback,
    required this.createdAt,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      userId: json['user_id'],
      sessionId: json['session_id'],
      scores: Map<String, double>.from(json['scores']),
      overallFeedback: json['overall_feedback'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'session_id': sessionId,
      'scores': scores,
      'overall_feedback': overallFeedback,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Skill models
class SkillLevel {
  final String id;
  final String name;
  final String description;
  final int level;
  final Map<String, dynamic>? criteria;

  SkillLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    this.criteria,
  });

  factory SkillLevel.fromJson(Map<String, dynamic> json) {
    return SkillLevel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      level: json['level'],
      criteria: json['criteria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'criteria': criteria,
    };
  }
}

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.success(T data, [String? message]) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(
      success: false,
      error: error,
    );
  }
}

// Pagination wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List).map((item) => fromJsonT(item)).toList(),
      total: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
    );
  }
}