enum DifficultyLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced');

  const DifficultyLevel(this.value);
  final String value;

  static DifficultyLevel fromString(String value) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DifficultyLevel.beginner,
    );
  }
}