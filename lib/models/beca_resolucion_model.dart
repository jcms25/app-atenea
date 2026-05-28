// Modelo del módulo Becas — respuesta de GET /beca/resolucion/{parent_id}

class BecaResolucionResponse {
  final bool status;
  final bool tieneBeca;
  final String anioAcademico;
  final List<BecaResolucion> data;

  BecaResolucionResponse({
    required this.status,
    required this.tieneBeca,
    required this.anioAcademico,
    required this.data,
  });

  factory BecaResolucionResponse.fromJson(Map<String, dynamic> json) {
    return BecaResolucionResponse(
      status: json['status'] ?? false,
      tieneBeca: json['tiene_beca'] ?? false,
      anioAcademico: json['anio_academico'] ?? '',
      data: json['data'] != null
          ? List<BecaResolucion>.from(
              (json['data'] as List).map((e) => BecaResolucion.fromJson(e)))
          : <BecaResolucion>[],
    );
  }
}

class BecaResolucion {
  final int alumnoId;
  final String alumnoNombre;
  final int classId;
  final String className; // p. ej. "6ºB Ed. Primaria" (clase concreta)
  final String classGrade; // p. ej. "P6" — para ordenar
  final String classGradeName; // p. ej. "6º Ed. Primaria" (curso, no clase)
  final String classCode; // p. ej. "P6B"
  final String codigo; // 'sbc1' | 'sbc2' | 'nbc3' | 'nbc4' | 'nbc5'
  final bool concedida;
  final String titulo;
  final String texto;

  BecaResolucion({
    required this.alumnoId,
    required this.alumnoNombre,
    required this.classId,
    required this.className,
    required this.classGrade,
    required this.classGradeName,
    required this.classCode,
    required this.codigo,
    required this.concedida,
    required this.titulo,
    required this.texto,
  });

  factory BecaResolucion.fromJson(Map<String, dynamic> json) {
    return BecaResolucion(
      alumnoId: json['alumno_id'] ?? 0,
      alumnoNombre: json['alumno_nombre'] ?? '',
      classId: json['class_id'] ?? 0,
      className: json['class_name'] ?? '',
      classGrade: json['class_grade'] ?? '',
      classGradeName: json['class_grade_name'] ?? '',
      classCode: json['class_code'] ?? '',
      codigo: json['codigo'] ?? '',
      concedida: json['concedida'] ?? false,
      titulo: json['titulo'] ?? '',
      texto: json['texto'] ?? '',
    );
  }
}