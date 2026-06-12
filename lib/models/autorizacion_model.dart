class AutorizacionModel {
  final int respId;
  final int autorizacionId;
  final int studentId;
  final String alumnoNombre;
  final String titulo;
  final String contenido;
  final String fechaCreacion;

  AutorizacionModel({
    required this.respId,
    required this.autorizacionId,
    required this.studentId,
    required this.alumnoNombre,
    required this.titulo,
    required this.contenido,
    required this.fechaCreacion,
  });

  factory AutorizacionModel.fromJson(Map<String, dynamic> json) {
    return AutorizacionModel(
      respId:         json['resp_id'] ?? 0,
      autorizacionId: json['autorizacion_id'] ?? 0,
      studentId:      json['student_id'] ?? 0,
      alumnoNombre:   json['alumno_nombre'] ?? '',
      titulo:         json['titulo'] ?? '',
      contenido:      json['contenido'] ?? '',
      fechaCreacion:  json['fecha_creacion'] ?? '',
    );
  }
}

class AutorizacionHistorialModel {
  final int respId;
  final int autorizacionId;
  final int studentId;
  final String alumnoNombre;
  final String titulo;
  final String academicYear;
  final String respuesta;
  final String fechaRespuesta;
  final String hashVerificacion;
  final String firmaNombre;
  final String segundoFirmanteNombre;
  final String contenidoFirmado;

  AutorizacionHistorialModel({
    required this.respId,
    required this.autorizacionId,
    required this.studentId,
    required this.alumnoNombre,
    required this.titulo,
    required this.academicYear,
    required this.respuesta,
    required this.fechaRespuesta,
    required this.hashVerificacion,
    required this.firmaNombre,
    required this.segundoFirmanteNombre,
    required this.contenidoFirmado,
  });

  factory AutorizacionHistorialModel.fromJson(Map<String, dynamic> json) {
    return AutorizacionHistorialModel(
      respId:                 json['resp_id'] ?? 0,
      autorizacionId:         json['autorizacion_id'] ?? 0,
      studentId:              json['student_id'] ?? 0,
      alumnoNombre:           json['alumno_nombre'] ?? '',
      titulo:                 json['titulo'] ?? '',
      academicYear:           json['academic_year'] ?? '',
      respuesta:              json['respuesta'] ?? '',
      fechaRespuesta:         json['fecha_respuesta'] ?? '',
      hashVerificacion:       json['hash_verificacion'] ?? '',
      firmaNombre:            json['firma_nombre'] ?? '',
      segundoFirmanteNombre:  json['segundo_firmante_nombre'] ?? '',
      contenidoFirmado:       json['contenido_firmado'] ?? '',
    );
  }
}