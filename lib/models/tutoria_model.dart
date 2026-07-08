import 'dart:convert';

class TutoriaModel {
  final int id;
  final String tipoSolicitud;
  final int idProfesor;
  final int idPadre;
  final int? idPadre2;
  final int idAlumno;
  final String estado;
  final String fechaPropuesta;
  final String? fechaAceptada;
  final String motivoSolicitud;
  final String motivoRechazo;
  final String asuntosTratados;
  final String asistentes;
  final String observaciones;
  final String anotacionesProfesor;
  final String fechaCreacion;
  final String fechaModificacion;

  // Campos adicionales devueltos por JOIN según el endpoint
  final String profesorNombre;
  final String alumnoNombre;
  final String padreNombre;
  final String padre2Nombre;

  TutoriaModel({
    required this.id,
    required this.tipoSolicitud,
    required this.idProfesor,
    required this.idPadre,
    this.idPadre2,
    required this.idAlumno,
    required this.estado,
    required this.fechaPropuesta,
    this.fechaAceptada,
    required this.motivoSolicitud,
    required this.motivoRechazo,
    required this.asuntosTratados,
    required this.asistentes,
    required this.observaciones,
    required this.anotacionesProfesor,
    required this.fechaCreacion,
    required this.fechaModificacion,
    required this.profesorNombre,
    required this.alumnoNombre,
    required this.padreNombre,
    required this.padre2Nombre,
  });

  factory TutoriaModel.fromJson(Map<String, dynamic> json) {
    return TutoriaModel(
      id:                   int.tryParse(json['id'].toString()) ?? 0,
      tipoSolicitud:        json['tipo_solicitud'] ?? '',
      idProfesor:           int.tryParse(json['id_profesor'].toString()) ?? 0,
      idPadre:              int.tryParse(json['id_padre'].toString()) ?? 0,
      idPadre2:             json['id_padre2'] != null ? int.tryParse(json['id_padre2'].toString()) : null,
      idAlumno:             int.tryParse(json['id_alumno'].toString()) ?? 0,
      estado:               json['estado'] ?? 'pendiente',
      fechaPropuesta:       json['fecha_propuesta'] ?? '',
      fechaAceptada:        json['fecha_aceptada'],
      motivoSolicitud:      json['motivo_solicitud'] ?? '',
      motivoRechazo:        json['motivo_rechazo'] ?? '',
      asuntosTratados:      json['asuntos_tratados'] ?? '',
      asistentes:           json['asistentes'] ?? '',
      observaciones:        json['observaciones'] ?? '',
      anotacionesProfesor:  json['anotaciones_profesor'] ?? '',
      fechaCreacion:        json['fecha_creacion'] ?? '',
      fechaModificacion:    json['fecha_modificacion'] ?? '',
      profesorNombre:       json['profesor_nombre'] ?? '',
      alumnoNombre:         json['alumno_nombre'] ?? '',
      padreNombre:          json['padre_nombre'] ?? '',
      padre2Nombre:         json['padre2_nombre'] ?? '',
    );
  }

  static List<TutoriaModel> listFromJson(List json) {
    return json.map((e) => TutoriaModel.fromJson(e)).toList();
  }
}

class TutoriaDetalleModel {
  final int id;
  final int idTutoria;
  final int autorId;
  final String autorRol;
  final String tipo;
  final String mensaje;
  final String? fechaPropuesta;
  final String fechaCreacion;
  final String autorNombre;

  TutoriaDetalleModel({
    required this.id,
    required this.idTutoria,
    required this.autorId,
    required this.autorRol,
    required this.tipo,
    required this.mensaje,
    this.fechaPropuesta,
    required this.fechaCreacion,
    required this.autorNombre,
  });

  factory TutoriaDetalleModel.fromJson(Map<String, dynamic> json) {
    return TutoriaDetalleModel(
      id:              int.tryParse(json['id'].toString()) ?? 0,
      idTutoria:       int.tryParse(json['id_tutoria'].toString()) ?? 0,
      autorId:         int.tryParse(json['autor_id'].toString()) ?? 0,
      autorRol:        json['autor_rol'] ?? '',
      tipo:            json['tipo'] ?? '',
      mensaje:         json['mensaje'] ?? '',
      fechaPropuesta:  json['fecha_propuesta'],
      fechaCreacion:   json['fecha_creacion'] ?? '',
      autorNombre:     json['autor_nombre'] ?? '',
    );
  }

static List<TutoriaDetalleModel> listFromJson(List json) {
    return json.map((e) => TutoriaDetalleModel.fromJson(e)).toList();
  }
}

class TutoriaProfesorSelectorModel {
  final int wpUsrId;
  final String nombre;
  final String tipo; // 'tutor' o 'area'
  final String? asignatura;
  final String label;
  final int? careDay;
  final String? careTime;
  final String? proximaFechaDisponible;

  TutoriaProfesorSelectorModel({
    required this.wpUsrId,
    required this.nombre,
    required this.tipo,
    this.asignatura,
    required this.label,
    this.careDay,
    this.careTime,
    this.proximaFechaDisponible,
  });

  factory TutoriaProfesorSelectorModel.fromJson(Map<String, dynamic> json) {
    return TutoriaProfesorSelectorModel(
      wpUsrId:                 int.tryParse(json['wp_usr_id'].toString()) ?? 0,
      nombre:                  json['nombre'] ?? '',
      tipo:                    json['tipo'] ?? '',
      asignatura:              json['asignatura'],
      label:                   json['label'] ?? '',
      careDay:                 json['care_day'] != null ? int.tryParse(json['care_day'].toString()) : null,
      careTime:                json['care_time'],
      proximaFechaDisponible:  json['proxima_fecha_disponible'],
    );
  }

  static List<TutoriaProfesorSelectorModel> listFromJson(List json) {
    return json.map((e) => TutoriaProfesorSelectorModel.fromJson(e)).toList();
  }
}

class TutoriaFamiliaModel {
  final int wpUsrId;
  final String nombre;
  final String rol; // 'padre1' o 'padre2'

  TutoriaFamiliaModel({
    required this.wpUsrId,
    required this.nombre,
    required this.rol,
  });

  factory TutoriaFamiliaModel.fromJson(Map<String, dynamic> json) {
    return TutoriaFamiliaModel(
      wpUsrId: int.tryParse(json['wp_usr_id'].toString()) ?? 0,
      nombre:  json['nombre'] ?? '',
      rol:     json['rol'] ?? '',
    );
  }
}

class TutoriaAlumnoSelectorModel {
  final int wpUsrId;
  final String nombre;
  final String label;
  final List<TutoriaFamiliaModel> familia;

  TutoriaAlumnoSelectorModel({
    required this.wpUsrId,
    required this.nombre,
    required this.label,
    required this.familia,
  });

  factory TutoriaAlumnoSelectorModel.fromJson(Map<String, dynamic> json) {
    final List familiaJson = json['familia'] ?? [];
    return TutoriaAlumnoSelectorModel(
      wpUsrId: int.tryParse(json['wp_usr_id'].toString()) ?? 0,
      nombre:  json['nombre'] ?? '',
      label:   json['label'] ?? '',
      familia: familiaJson.map((e) => TutoriaFamiliaModel.fromJson(e)).toList(),
    );
  }
}

class TutoriaClaseSelectorModel {
  final int cid;
  final String cName;
  final List<TutoriaAlumnoSelectorModel> alumnos;

  TutoriaClaseSelectorModel({
    required this.cid,
    required this.cName,
    required this.alumnos,
  });

  factory TutoriaClaseSelectorModel.fromJson(Map<String, dynamic> json) {
    final List alumnosJson = json['alumnos'] ?? [];
    return TutoriaClaseSelectorModel(
      cid:     json['cid'] ?? 0,
      cName:   json['c_name'] ?? '',
      alumnos: alumnosJson.map((e) => TutoriaAlumnoSelectorModel.fromJson(e)).toList(),
    );
  }

static List<TutoriaClaseSelectorModel> listFromJson(List json) {
    return json.map((e) => TutoriaClaseSelectorModel.fromJson(e)).toList();
  }
}

class TutoriaAsistentePersonaModel {
  final int wpUsrId;
  final String nombre;
  final bool bajaLaboral;

  TutoriaAsistentePersonaModel({
    required this.wpUsrId,
    required this.nombre,
    this.bajaLaboral = false,
  });

  factory TutoriaAsistentePersonaModel.fromJson(Map<String, dynamic> json) {
    return TutoriaAsistentePersonaModel(
      wpUsrId:     int.tryParse(json['wp_usr_id'].toString()) ?? 0,
      nombre:      json['nombre'] ?? '',
      bajaLaboral: json['baja_laboral'] == true,
    );
  }

  static List<TutoriaAsistentePersonaModel> listFromJson(List json) {
    return json.map((e) => TutoriaAsistentePersonaModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {'wp_usr_id': wpUsrId, 'nombre': nombre};
}

class TutoriaAsistentesSelectorModel {
  final List<TutoriaAsistentePersonaModel> familia;
  final List<TutoriaAsistentePersonaModel> alumnado;
  final List<TutoriaAsistentePersonaModel> profesorado;
  final List<TutoriaAsistentePersonaModel> otrosProfesores;
  final List<TutoriaAsistentePersonaModel> equipoDirectivo;

  TutoriaAsistentesSelectorModel({
    required this.familia,
    required this.alumnado,
    required this.profesorado,
    required this.otrosProfesores,
    required this.equipoDirectivo,
  });

  factory TutoriaAsistentesSelectorModel.fromJson(Map<String, dynamic> json) {
    return TutoriaAsistentesSelectorModel(
      familia:         TutoriaAsistentePersonaModel.listFromJson(json['familia'] ?? []),
      alumnado:        TutoriaAsistentePersonaModel.listFromJson(json['alumnado'] ?? []),
      profesorado:     TutoriaAsistentePersonaModel.listFromJson(json['profesorado'] ?? []),
      otrosProfesores: TutoriaAsistentePersonaModel.listFromJson(json['otros_profesores'] ?? []),
      equipoDirectivo: TutoriaAsistentePersonaModel.listFromJson(json['equipo_directivo'] ?? []),
    );
  }
}

/// Estructura de asistentes seleccionados, para guardar como JSON
/// en el campo `asistentes` de la tutoría.
class TutoriaAsistentesSeleccionModel {
  final List<TutoriaAsistentePersonaModel> familia;
  final List<TutoriaAsistentePersonaModel> alumnado;
  final List<TutoriaAsistentePersonaModel> profesorado;
  final List<TutoriaAsistentePersonaModel> equipoDirectivo;

  TutoriaAsistentesSeleccionModel({
    this.familia = const [],
    this.alumnado = const [],
    this.profesorado = const [],
    this.equipoDirectivo = const [],
  });

  bool get isEmpty =>
      familia.isEmpty && alumnado.isEmpty && profesorado.isEmpty && equipoDirectivo.isEmpty;

  Map<String, dynamic> toJson() => {
        'familia':          familia.map((p) => p.toJson()).toList(),
        'alumnado':         alumnado.map((p) => p.toJson()).toList(),
        'profesorado':      profesorado.map((p) => p.toJson()).toList(),
        'equipo_directivo': equipoDirectivo.map((p) => p.toJson()).toList(),
      };

  factory TutoriaAsistentesSeleccionModel.fromJsonString(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) {
      return TutoriaAsistentesSeleccionModel();
    }
    try {
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      return TutoriaAsistentesSeleccionModel(
        familia:         TutoriaAsistentePersonaModel.listFromJson(data['familia'] ?? []),
        alumnado:        TutoriaAsistentePersonaModel.listFromJson(data['alumnado'] ?? []),
        profesorado:     TutoriaAsistentePersonaModel.listFromJson(data['profesorado'] ?? []),
        equipoDirectivo: TutoriaAsistentePersonaModel.listFromJson(data['equipo_directivo'] ?? []),
      );
    } catch (_) {
      return TutoriaAsistentesSeleccionModel();
    }
  }

  /// Texto legible para mostrar en pantallas de solo lectura (Historial, Acta).
  String toDisplayText() {
    final List<String> partes = [];
    if (familia.isNotEmpty) partes.add('Familia: ${familia.map((p) => p.nombre).join(', ')}');
    if (alumnado.isNotEmpty) partes.add('Alumnado: ${alumnado.map((p) => p.nombre).join(', ')}');
    if (profesorado.isNotEmpty) partes.add('Profesorado: ${profesorado.map((p) => p.nombre).join(', ')}');
    if (equipoDirectivo.isNotEmpty) partes.add('Equipo Directivo: ${equipoDirectivo.map((p) => p.nombre).join(', ')}');
    return partes.join('\n');
  }
}

class TutoriaFirmaModel {
  final int id;
  final int idTutoria;
  final int wpUsrId;
  final String categoria;
  final String nombre;
  final String estado;
  final String tipoRegistro;
  final String? fechaFirma;
  final String? fechaPropuesta;
  final String? asuntosTratados;
  final String? observaciones;
  final String? alumnoNombre;

  TutoriaFirmaModel({
    required this.id,
    required this.idTutoria,
    required this.wpUsrId,
    required this.categoria,
    required this.nombre,
    required this.estado,
    required this.tipoRegistro,
    this.fechaFirma,
    this.fechaPropuesta,
    this.asuntosTratados,
    this.observaciones,
    this.alumnoNombre,
  });

  factory TutoriaFirmaModel.fromJson(Map<String, dynamic> json) {
    return TutoriaFirmaModel(
      id:              int.tryParse((json['id'] ?? json['firma_id']).toString()) ?? 0,
      idTutoria:       int.tryParse(json['id_tutoria'].toString()) ?? 0,
      wpUsrId:         int.tryParse((json['wp_usr_id'] ?? '0').toString()) ?? 0,
      categoria:       json['categoria'] ?? '',
      nombre:          json['nombre'] ?? '',
      estado:          json['estado'] ?? 'pendiente',
      tipoRegistro:    json['tipo_registro'] ?? 'firma',
      fechaFirma:      json['fecha_firma'],
      fechaPropuesta:  json['fecha_propuesta'],
      asuntosTratados: json['asuntos_tratados'],
      observaciones:   json['observaciones'],
      alumnoNombre:    json['alumno_nombre'],
    );
  }

  static List<TutoriaFirmaModel> listFromJson(List json) {
    return json.map((e) => TutoriaFirmaModel.fromJson(e)).toList();
  }
}

class TutoriaEstadoFirmasModel {
  final List<TutoriaFirmaModel> firmas;
  final int totalAFirmar;
  final int firmadas;
  final bool completo;

  TutoriaEstadoFirmasModel({
    required this.firmas,
    required this.totalAFirmar,
    required this.firmadas,
    required this.completo,
  });

  factory TutoriaEstadoFirmasModel.fromJson(Map<String, dynamic> json) {
    return TutoriaEstadoFirmasModel(
      firmas:       TutoriaFirmaModel.listFromJson(json['firmas'] ?? []),
      totalAFirmar: int.tryParse(json['total_a_firmar'].toString()) ?? 0,
      firmadas:     int.tryParse(json['firmadas'].toString()) ?? 0,
      completo:     json['completo'] == true,
    );
  }
}