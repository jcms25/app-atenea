// Modelos para el módulo Servicios Contratados

class AlumnoServicioModel {
  final int wpUsrId;
  final String alumnoNombre;
  final String claseNombre;
  final List<String> detalle;

  AlumnoServicioModel({
    required this.wpUsrId,
    required this.alumnoNombre,
    required this.claseNombre,
    required this.detalle,
  });

  factory AlumnoServicioModel.fromJson(Map<String, dynamic> json) {
    return AlumnoServicioModel(
      wpUsrId:      json['wp_usr_id'] ?? 0,
      alumnoNombre: json['alumno_nombre'] ?? '',
      claseNombre:  json['clase_nombre'] ?? '',
      detalle:      json['detalle'] is List
          ? List<String>.from(json['detalle'].map((e) => e.toString()))
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