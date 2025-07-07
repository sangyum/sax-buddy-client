enum SkillLevelEnum {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced');

  const SkillLevelEnum(this.value);
  final String value;

  static SkillLevelEnum fromString(String value) {
    return SkillLevelEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SkillLevelEnum.beginner,
    );
  }
}