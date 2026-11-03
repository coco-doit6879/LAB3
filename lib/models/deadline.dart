class Deadline {
  const Deadline({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueAt,
    this.completed = false,
  });
  final String id;
  final String title;
  final String courseId;
  final DateTime dueAt;
  final bool completed;

  Deadline copyWith({
    String? title,
    String? courseId,
    DateTime? dueAt,
    bool? completed,
  }) => Deadline(
    id: id,
    title: title ?? this.title,
    courseId: courseId ?? this.courseId,
    dueAt: dueAt ?? this.dueAt,
    completed: completed ?? this.completed,
  );

  static String? validateTitle(String value) {
    if (value.trim().isEmpty) return 'Nhập tiêu đề deadline.';
    if (value.trim().length > 120) return 'Tiêu đề tối đa 120 ký tự.';
    return null;
  }
}
