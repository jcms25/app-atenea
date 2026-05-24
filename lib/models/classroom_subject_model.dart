// Modelo del módulo Actitudinal — respuesta de GET /classroom-event/subject-by-datetime

class ClassroomSubjectResponse {
  final bool status;
  final String matchType; // 'exact' | 'enrollment_fallback' | 'none'
  final List<ClassroomSubject> subjects;

  ClassroomSubjectResponse({
    required this.status,
    required this.matchType,
    required this.subjects,
  });

  factory ClassroomSubjectResponse.fromJson(Map<String, dynamic> json) {
    return ClassroomSubjectResponse(
      status: json['status'] ?? false,
      matchType: json['match_type'] ?? 'none',
      subjects: json['subjects'] != null
          ? List<ClassroomSubject>.from(
              (json['subjects'] as List)
                  .map((e) => ClassroomSubject.fromJson(e)))
          : <ClassroomSubject>[],
    );
  }
}

class ClassroomSubject {
  final int id;
  final String name;
  final bool selected;
  final int teacherId;

  ClassroomSubject({
    required this.id,
    required this.name,
    required this.selected,
    required this.teacherId,
  });

  factory ClassroomSubject.fromJson(Map<String, dynamic> json) {
    return ClassroomSubject(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      selected: json['selected'] ?? false,
      teacherId: json['teacher_id'] ?? 0,
    );
  }
}