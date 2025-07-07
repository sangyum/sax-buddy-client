enum SessionStatus {
  inProgress('in_progress'),
  completed('completed'),
  paused('paused'),
  cancelled('cancelled');

  const SessionStatus(this.value);
  final String value;

  static SessionStatus fromString(String value) {
    return SessionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SessionStatus.inProgress,
    );
  }
}