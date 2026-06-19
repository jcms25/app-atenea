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

class AutorizacionAlumnoModel {
  final int wpUsrId;
  final String nombre;
  final String apellidos;

  AutorizacionAlumnoModel({
    required this.wpUsrId,
    required this.nombre,
    required this.apellidos,
  });

  String get nombreCompleto => '$apellidos, $nombre';

  factory AutorizacionAlumnoModel.fromJson(Map<String, dynamic> json) {
    return AutorizacionAlumnoModel(
      wpUsrId:   json['wp_usr_id'] ?? 0,
      nombre:    json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
    );
  }
}

class AutorizacionTutorClaseModel {
  final int cid;
  final String cName;
  final List<AutorizacionAlumnoModel> alumnos;

  AutorizacionTutorClaseModel({
    required this.cid,
    required this.cName,
    required this.alumnos,
  });

  factory AutorizacionTutorClaseModel.fromJson(Map<String, dynamic> json) {
    final List alumnosJson = json['alumnos'] ?? [];
    return AutorizacionTutorClaseModel(
      cid:     json['cid'] ?? 0,
      cName:   json['c_name'] ?? '',
      alumnos: alumnosJson
          .map((e) => AutorizacionAlumnoModel.fromJson(e))
          .toList(),
    );
  }

  static List<AutorizacionTutorClaseModel> listFromJson(List json) {
    return json.map((e) => AutorizacionTutorClaseModel.fromJson(e)).toList();
  }
}

class AutorizacionPlantillaModel {
  final int id;
  final String titulo;
  final String contenido;
  final String contenidoPreview;
  final String plantillaNombre;

  AutorizacionPlantillaModel({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.contenidoPreview,
    required this.plantillaNombre,
  });

  factory AutorizacionPlantillaModel.fromJson(Map<String, dynamic> json) {
    return AutorizacionPlantillaModel(
      id:               json['id'] ?? 0,
      titulo:           json['titulo'] ?? '',
      contenido:        json['contenido'] ?? '',
      contenidoPreview: json['contenido_preview'] ?? json['contenido'] ?? '',
      plantillaNombre:  json['plantilla_nombre'] ?? '',
    );
  }
}

class AutorizacionRegistroAlumnoModel {
  final int studentId;
  final String nombre;
  final String apellidos;
  final String respuesta;
  final String fechaRespuesta;
  final String firmaNombre;

  AutorizacionRegistroAlumnoModel({
    required this.studentId,
    required this.nombre,
    required this.apellidos,
    required this.respuesta,
    required this.fechaRespuesta,
    required this.firmaNombre,
  });

  String get nombreCompleto => '$apellidos, $nombre';

  factory AutorizacionRegistroAlumnoModel.fromJson(Map<String, dynamic> json) {
    return AutorizacionRegistroAlumnoModel(
      studentId:      json['student_id'] ?? 0,
      nombre:         json['nombre'] ?? '',
      apellidos:      json['apellidos'] ?? '',
      respuesta:      json['respuesta'] ?? '',
      fechaRespuesta: json['fecha_respuesta'] ?? '',
      firmaNombre:    json['firma_nombre'] ?? '',
    );
  }
}

class AutorizacionRegistroItemModel {
  final int autorizacionId;
  final String titulo;
  final String fechaCreacion;
  final String origen;
  final int resumenPendiente;
  final int resumenAutorizado;
  final int resumenNoAutorizado;
  final List<AutorizacionRegistroAlumnoModel> alumnos;

  AutorizacionRegistroItemModel({
    required this.autorizacionId,
    required this.titulo,
    required this.fechaCreacion,
    required this.origen,
    required this.resumenPendiente,
    required this.resumenAutorizado,
    required this.resumenNoAutorizado,
    required this.alumnos,
  });

  factory AutorizacionRegistroItemModel.fromJson(Map<String, dynamic> json) {
    final List alumnosJson = json['alumnos'] ?? [];
    final Map resumen = json['resumen'] ?? {};
    return AutorizacionRegistroItemModel(
      autorizacionId:      json['autorizacion_id'] ?? 0,
      titulo:              json['titulo'] ?? '',
      fechaCreacion:       json['fecha_creacion'] ?? '',
      origen:              json['origen'] ?? '',
      resumenPendiente:    resumen['pendiente'] ?? 0,
      resumenAutorizado:   resumen['autorizado'] ?? 0,
      resumenNoAutorizado: resumen['no_autorizado'] ?? 0,
      alumnos: alumnosJson
          .map((e) => AutorizacionRegistroAlumnoModel.fromJson(e))
          .toList(),
    );
  }
}

class AutorizacionTutorRegistroModel {
  final int cid;
  final String cName;
  final List<AutorizacionRegistroItemModel> autorizaciones;

  AutorizacionTutorRegistroModel({
    required this.cid,
    required this.cName,
    required this.autorizaciones,
  });

  factory AutorizacionTutorRegistroModel.fromJson(Map<String, dynamic> json) {
    final List autJson = json['autorizaciones'] ?? [];
    return AutorizacionTutorRegistroModel(
      cid:  json['cid'] ?? 0,
      cName: json['c_name'] ?? '',
      autorizaciones: autJson
          .map((e) => AutorizacionRegistroItemModel.fromJson(e))
          .toList(),
    );
  }
}