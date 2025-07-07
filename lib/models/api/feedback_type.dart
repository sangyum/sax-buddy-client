enum FeedbackType {
  postSession('post_session'),
  motivational('motivational'),
  corrective('corrective');

  const FeedbackType(this.value);
  final String value;

  static FeedbackType fromString(String value) {
    return FeedbackType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FeedbackType.postSession,
    );
  }
}