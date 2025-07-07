enum TriggerReason {
  scheduledInterval('scheduled_interval'),
  userRequested('user_requested'),
  skillThreshold('skill_threshold'),
  lessonCompletion('lesson_completion');

  const TriggerReason(this.value);
  final String value;

  static TriggerReason fromString(String value) {
    return TriggerReason.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TriggerReason.scheduledInterval,
    );
  }
}