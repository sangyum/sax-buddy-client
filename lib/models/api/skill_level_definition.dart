import 'skill_level_enum.dart';

class SkillLevelDefinition {
  final String id;
  final SkillLevelEnum skillLevel;
  final String name;
  final String description;
  final double minScore;
  final double maxScore;
  final List<String> criteria;

  SkillLevelDefinition({
    required this.id,
    required this.skillLevel,
    required this.name,
    required this.description,
    required this.minScore,
    required this.maxScore,
    required this.criteria,
  });

  factory SkillLevelDefinition.fromJson(Map<String, dynamic> json) {
    return SkillLevelDefinition(
      id: json['id'],
      skillLevel: SkillLevelEnum.fromString(json['skill_level']),
      name: json['name'],
      description: json['description'],
      minScore: json['min_score'].toDouble(),
      maxScore: json['max_score'].toDouble(),
      criteria: List<String>.from(json['criteria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill_level': skillLevel.value,
      'name': name,
      'description': description,
      'min_score': minScore,
      'max_score': maxScore,
      'criteria': criteria,
    };
  }
}