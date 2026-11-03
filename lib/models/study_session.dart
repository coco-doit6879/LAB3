enum SessionStatus { planned, running, completed }

class StudySession {
  const StudySession({
    required this.id,
    required this.title,
    required this.plannedAt,
    required this.plannedMinutes,
    this.status = SessionStatus.planned,
    this.startedAt,
    this.endedAt,
  });
  final String id;
  final String title;
  final DateTime plannedAt;
  final int plannedMinutes;
  final SessionStatus status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  Duration elapsed(DateTime now) {
    if (startedAt == null) return Duration.zero;
    final duration = (endedAt ?? now).difference(startedAt!);
    return duration.isNegative ? Duration.zero : duration;
  }
}
