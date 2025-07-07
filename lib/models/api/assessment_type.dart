enum AssessmentType {
  periodic('periodic'),
  onDemand('on_demand'),
  milestone('milestone');

  const AssessmentType(this.value);
  final String value;

  static AssessmentType fromString(String value) {
    return AssessmentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AssessmentType.periodic,
    );
  }
}