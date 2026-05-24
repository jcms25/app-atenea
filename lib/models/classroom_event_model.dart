// Modelo del módulo Actitudinal — respuesta de GET /classroom-events

class ClassroomEventsResponse {
  final bool status;
  final ClassroomEventsSummary? summary;
  final List<ClassroomEvent> data;

  ClassroomEventsResponse({
    required this.status,
    this.summary,
    required this.data,
  });

  factory ClassroomEventsResponse.fromJson(Map<String, dynamic> json) {
    return ClassroomEventsResponse(
      status: json['status'] ?? false,
      summary: json['summary'] != null
          ? ClassroomEventsSummary.fromJson(json['summary'])
          : null,
      data: json['data'] != null
          ? List<ClassroomEvent>.from(
              (json['data'] as List).map((e) => ClassroomEvent.fromJson(e)))
          : <ClassroomEvent>[],
    );
  }
}

class ClassroomEventsSummary {
  final int total;
  final int positive;
  final int negative;
  final String academicYear;

  ClassroomEventsSummary({
    required this.total,
    required this.positive,
    required this.negative,
    required this.academicYear,
  });

  factory ClassroomEventsSummary.fromJson(Map<String, dynamic> json) {
    return ClassroomEventsSummary(
      total: json['total'] ?? 0,
      positive: json['positive'] ?? 0,
      negative: json['negative'] ?? 0,
      academicYear: json['academic_year'] ?? '',
    );
  }
}

class ClassroomEvent {
  final int id;
  final String eventDate;
  final String className;
  final String subjectName;
  final String teacherName;
  final String emoji;
  final String label;
  final String type; // 'positive' | 'negative'
  final String comment;

  ClassroomEvent({
    required this.id,
    required this.eventDate,
    required this.className,
    required this.subjectName,
    required this.teacherName,
    required this.emoji,
    required this.label,
    required this.type,
    required this.comment,
  });

  factory ClassroomEvent.fromJson(Map<String, dynamic> json) {
    return ClassroomEvent(
      id: json['id'] ?? 0,
      eventDate: json['event_date'] ?? '',
      className: json['class_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      emoji: json['emoji'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? '',
      comment: json['comment'] ?? '',
    );
  }

  /// true si la incidencia es positiva
  bool get isPositive => type == 'positive';
}