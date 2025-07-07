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