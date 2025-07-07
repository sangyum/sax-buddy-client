enum PracticeFrequency {
  daily('daily'),
  weekly('weekly'),
  occasional('occasional');

  const PracticeFrequency(this.value);
  final String value;

  static PracticeFrequency fromString(String value) {
    return PracticeFrequency.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PracticeFrequency.daily,
    );
  }
}