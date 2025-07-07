import 'session_status.dart';

class PerformanceSessionUpdate {
  final int? durationMinutes;
  final SessionStatus? status;
  final String? endedAt;
  final String? notes;

  PerformanceSessionUpdate({
    this.durationMinutes,
    this.status,
    this.endedAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (durationMinutes != null) json['duration_minutes'] = durationMinutes;
    if (status != null) json['status'] = status!.value;
    if (endedAt != null) json['ended_at'] = endedAt;
    if (notes != null) json['notes'] = notes;
    return json;
  }
}