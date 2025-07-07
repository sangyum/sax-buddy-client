enum ExerciseType {
  scales('scales'),
  arpeggios('arpeggios'),
  technical('technical'),
  etudes('etudes'),
  songs('songs'),
  longTone('long_tone');

  const ExerciseType(this.value);
  final String value;

  static ExerciseType fromString(String value) {
    return ExerciseType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExerciseType.scales,
    );
  }
}