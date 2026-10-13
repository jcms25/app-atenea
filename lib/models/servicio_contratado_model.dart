// Modelos para el módulo Servicios Contratados

class AlumnoServicioModel {
  final int wpUsrId;
  final String alumnoNombre;
  final String claseNombre;
  final List<String> detalle;
  final String? origen; // 'app' | 'secretaria' — solo en servicios con formulario (com, mat, gab)
  final List<String> detalleOrigen; // 'app' | 'secretaria' por cada línea de detalle — solo en Extraescolares

  AlumnoServicioModel({
    required this.wpUsrId,
    required this.alumnoNombre,
    required this.claseNombre,
    required this.detalle,
    this.origen,
    this.detalleOrigen = const [],
  });

  factory AlumnoServicioModel.fromJson(Map<String, dynamic> json) {
    return AlumnoServicioModel(
      wpUsrId:      json['wp_usr_id'] ?? 0,
      alumnoNombre: json['alumno_nombre'] ?? '',
      claseNombre:  json['clase_nombre'] ?? '',
      detalle:      json['detalle'] is List
          ? List<String>.from(json['detalle'].map((e) => e.toString()))
          : <String>[],
      origen:       json['origen']?.toString(),
      detalleOrigen: json['detalle_origen'] is List
          ? List<String>.from(json['detalle_origen'].map((e) => e.toString()))
          : <String>[],
    );
  }
}

class ServicioContratadoModel {
  final String campo;
  final String nombre;
  final bool contratado;
  final List<AlumnoServicioModel> alumnos;

  ServicioContratadoModel({
    required this.campo,
    required this.nombre,
    required this.contratado,
    required this.alumnos,
  });

  factory ServicioContratadoModel.fromJson(Map<String, dynamic> json) {
    return ServicioContratadoModel(
      campo:      json['campo'] ?? '',
      nombre:     json['nombre'] ?? '',
      contratado: json['contratado'] ?? false,
      alumnos: json['alumnos'] is List
          ? List<AlumnoServicioModel>.from(
              json['alumnos'].map((e) => AlumnoServicioModel.fromJson(e)))
          : <AlumnoServicioModel>[],
    );
  }
}

class ServiciosContratadosResponseModel {
  final String academicYear;
  final List<ServicioContratadoModel> servicios;

  ServiciosContratadosResponseModel({
    required this.academicYear,
    required this.servicios,
  });

  factory ServiciosContratadosResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiciosContratadosResponseModel(
      academicYear: json['academic_year'] ?? '',
      servicios: json['servicios'] is List
          ? List<ServicioContratadoModel>.from(
              json['servicios'].map((e) => ServicioContratadoModel.fromJson(e)))
          : <ServicioContratadoModel>[],
    );
  }
}

class ReciboMandatoModel {
  final int idMandato;
  final String fechaMandato;
  final double importeAdeudo;
  final String concepto;

  ReciboMandatoModel({
    required this.idMandato,
    required this.fechaMandato,
    required this.importeAdeudo,
    required this.concepto,
  });

  factory ReciboMandatoModel.fromJson(Map<String, dynamic> json) {
    return ReciboMandatoModel(
      idMandato:     json['id_mandato'] ?? 0,
      fechaMandato:  json['fecha_mandato'] ?? '',
      importeAdeudo: (json['importe_adeudo'] ?? 0).toDouble(),
      concepto:      json['concepto'] ?? '',
    );
  }
}

class DetalleReciboModel {
  final String concepto;
  final int cantidad;
  final double total;

  DetalleReciboModel({
    required this.concepto,
    required this.cantidad,
    required this.total,
  });

  factory DetalleReciboModel.fromJson(Map<String, dynamic> json) {
    return DetalleReciboModel(
      concepto: json['concepto'] ?? '',
      cantidad: json['cantidad'] ?? 1,
      total:    (json['total'] ?? 0).toDouble(),
    );
  }
}

class ReciboNoDomiciliadoModel {
  final int idRecibo;
  final String fechaRecibo;
  final double totalRecibo;
  final List<DetalleReciboModel> detalle;

  ReciboNoDomiciliadoModel({
    required this.idRecibo,
    required this.fechaRecibo,
    required this.totalRecibo,
    required this.detalle,
  });

  factory ReciboNoDomiciliadoModel.fromJson(Map<String, dynamic> json) {
    return ReciboNoDomiciliadoModel(
      idRecibo:    json['id_recibo'] ?? 0,
      fechaRecibo: json['fecha_recibo'] ?? '',
      totalRecibo: (json['total_recibo'] ?? 0).toDouble(),
      detalle: json['detalle'] is List
          ? List<DetalleReciboModel>.from(
              json['detalle'].map((e) => DetalleReciboModel.fromJson(e)))
          : <DetalleReciboModel>[],
    );
  }
}

class CursoRecibosModel {
  final String academicYear;
  final List<ReciboMandatoModel> domiciliados;
  final List<ReciboNoDomiciliadoModel> noDomiciliados;

  CursoRecibosModel({
    required this.academicYear,
    required this.domiciliados,
    required this.noDomiciliados,
  });

  factory CursoRecibosModel.fromJson(Map<String, dynamic> json) {
    return CursoRecibosModel(
      academicYear: json['academic_year'] ?? '',
      domiciliados: json['domiciliados'] is List
          ? List<ReciboMandatoModel>.from(
              json['domiciliados'].map((e) => ReciboMandatoModel.fromJson(e)))
          : <ReciboMandatoModel>[],
      noDomiciliados: json['no_domiciliados'] is List
          ? List<ReciboNoDomiciliadoModel>.from(
              json['no_domiciliados'].map((e) => ReciboNoDomiciliadoModel.fromJson(e)))
          : <ReciboNoDomiciliadoModel>[],
    );
  }
}

class RecibosResponseModel {
  final String academicYearActiva;
  final List<CursoRecibosModel> cursos;

  RecibosResponseModel({
    required this.academicYearActiva,
    required this.cursos,
  });

  factory RecibosResponseModel.fromJson(Map<String, dynamic> json) {
    return RecibosResponseModel(
      academicYearActiva: json['academic_year_activa'] ?? '',
      cursos: json['cursos'] is List
          ? List<CursoRecibosModel>.from(
              json['cursos'].map((e) => CursoRecibosModel.fromJson(e)))
          : <CursoRecibosModel>[],
    );
  }
}

// ============================================================
// MÓDULO SOLICITUDES
// ============================================================

class ActividadExtraescolarModel {
  final int id;
  final String modalidad;
  final String cursos;
  final String dias;
  final double precio;
  final String pago; // 'mensual' | 'trimestral'

  ActividadExtraescolarModel({
    required this.id,
    required this.modalidad,
    required this.cursos,
    required this.dias,
    required this.precio,
    required this.pago,
  });

  factory ActividadExtraescolarModel.fromJson(Map<String, dynamic> json) {
    return ActividadExtraescolarModel(
      id:        json['id'] ?? 0,
      modalidad: json['modalidad'] ?? '',
      cursos:    json['cursos'] ?? '',
      dias:      json['dias'] ?? '',
      precio:    (json['precio'] ?? 0).toDouble(),
      pago:      json['pago'] ?? '',
    );
  }
}

class FormularioSolicitudModel {
  final int id;
  final String nombre;
  final String slug;
  final String descripcion;
  final String condiciones;
  final bool requiereTipo;
  final bool requiereIban;
  final List<ActividadExtraescolarModel> actividades; // solo en el formulario de Extraescolares

  FormularioSolicitudModel({
    required this.id,
    required this.nombre,
    required this.slug,
    required this.descripcion,
    required this.condiciones,
    required this.requiereTipo,
    required this.requiereIban,
    this.actividades = const [],
  });

  factory FormularioSolicitudModel.fromJson(Map<String, dynamic> json) {
    return FormularioSolicitudModel(
      id:           json['id'] ?? 0,
      nombre:       json['nombre'] ?? '',
      slug:         json['slug'] ?? '',
      descripcion:  json['descripcion'] ?? '',
      condiciones:  json['condiciones'] ?? '',
      requiereTipo: json['requiere_tipo'] ?? true,
      requiereIban: json['requiere_iban'] ?? true,
      actividades: json['actividades'] is List
          ? List<ActividadExtraescolarModel>.from(json['actividades']
              .map((e) => ActividadExtraescolarModel.fromJson(e)))
          : <ActividadExtraescolarModel>[],
    );
  }
}

class HijoSolicitudModel {
  final int wpUsrId;
  final String nombre;
  final String claseNombre;
  final Map<String, bool> yaContratado;
  final List<int> actividadesContratadas; // ids de student_opc.ext (Extraescolares)

  HijoSolicitudModel({
    required this.wpUsrId,
    required this.nombre,
    required this.claseNombre,
    required this.yaContratado,
    this.actividadesContratadas = const [],
  });

  factory HijoSolicitudModel.fromJson(Map<String, dynamic> json) {
    return HijoSolicitudModel(
      wpUsrId:     json['wp_usr_id'] ?? 0,
      nombre:      json['nombre'] ?? '',
      claseNombre: json['clase_nombre'] ?? '',
      yaContratado: json['ya_contratado'] is Map
          ? (json['ya_contratado'] as Map)
              .map((k, v) => MapEntry(k.toString(), v == true))
          : <String, bool>{},
      actividadesContratadas: json['actividades_contratadas'] is List
          ? List<int>.from((json['actividades_contratadas'] as List)
              .map((e) => int.tryParse(e.toString()) ?? 0))
          : <int>[],
    );
  }
}

class PadreSolicitudModel {
  final String nombreCompleto;
  final String nif;
  final String email;
  final String telefono;
  final String iban;
  final String titularCuenta;
  final String nifTitular;

  PadreSolicitudModel({
    required this.nombreCompleto,
    required this.nif,
    required this.email,
    required this.telefono,
    required this.iban,
    required this.titularCuenta,
    required this.nifTitular,
  });

  factory PadreSolicitudModel.fromJson(Map<String, dynamic> json) {
    return PadreSolicitudModel(
      nombreCompleto: json['nombre_completo'] ?? '',
      nif:            json['nif'] ?? '',
      email:          json['email'] ?? '',
      telefono:       json['telefono'] ?? '',
      iban:           json['iban'] ?? '',
      titularCuenta:  json['titular_cuenta'] ?? '',
      nifTitular:     json['nif_titular'] ?? '',
    );
  }
}

class MisHijosSolicitudResponseModel {
  final PadreSolicitudModel padre;
  final List<HijoSolicitudModel> hijos;

  MisHijosSolicitudResponseModel({
    required this.padre,
    required this.hijos,
  });

  factory MisHijosSolicitudResponseModel.fromJson(Map<String, dynamic> json) {
    return MisHijosSolicitudResponseModel(
      padre: PadreSolicitudModel.fromJson(json['padre'] ?? {}),
      hijos: json['hijos'] is List
          ? List<HijoSolicitudModel>.from(
              json['hijos'].map((e) => HijoSolicitudModel.fromJson(e)))
          : <HijoSolicitudModel>[],
    );
  }
}

class SolicitudHistorialModel {
  final int id;
  final int formularioId;
  final String formularioNombre;
  final String formularioSlug;
  final String academicYear;
  final int studentId;
  final int? actividadId; // solo en solicitudes de Extraescolares
  final String actividadNombre;
  final String alumnoNombre;
  final String claseNombre;
  final String tipoServicio;
  final String fechaSolicitud;
  final String estado;
  final String firmaNombre;
  final String hashVerificacion;
  final String condicionesTexto;

  SolicitudHistorialModel({
    required this.id,
    required this.formularioId,
    required this.formularioNombre,
    required this.formularioSlug,
    required this.academicYear,
    required this.studentId,
    this.actividadId,
    this.actividadNombre = '',
    required this.alumnoNombre,
    required this.claseNombre,
    required this.tipoServicio,
    required this.fechaSolicitud,
    required this.estado,
    required this.firmaNombre,
    required this.hashVerificacion,
    required this.condicionesTexto,
  });

  factory SolicitudHistorialModel.fromJson(Map<String, dynamic> json) {
    return SolicitudHistorialModel(
      id:                 json['id'] ?? 0,
      formularioId:       json['formulario_id'] ?? 0,
      formularioNombre:   json['formulario_nombre'] ?? '',
      formularioSlug:     json['formulario_slug'] ?? '',
      academicYear:       json['academic_year'] ?? '',
      studentId:          json['student_id'] ?? 0,
      actividadId:        json['actividad_id'] == null
          ? null
          : int.tryParse(json['actividad_id'].toString()),
      actividadNombre:    json['actividad_nombre'] ?? '',
      alumnoNombre:       json['alumno_nombre'] ?? '',
      claseNombre:        json['clase_nombre'] ?? '',
      tipoServicio:       json['tipo_servicio'] ?? '',
      fechaSolicitud:     json['fecha_solicitud'] ?? '',
      estado:             json['estado'] ?? '',
      firmaNombre:        json['firma_nombre'] ?? '',
      hashVerificacion:   json['hash_verificacion'] ?? '',
      condicionesTexto:   json['condiciones_texto'] ?? '',
    );
  }
}