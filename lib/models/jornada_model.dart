/// Tramo adicional de hoy (reunión convocada, tarea puntual). Sin hora de fin
/// está pendiente de cerrar horario.
class JornadaExtra {
  final String ini;
  final String? fin;
  final String motivo;
  final bool pendiente;

  JornadaExtra({
    required this.ini,
    required this.fin,
    required this.motivo,
    required this.pendiente,
  });

  factory JornadaExtra.fromJson(Map<String, dynamic> json) {
    return JornadaExtra(
      ini: json['ini']?.toString() ?? '',
      fin: json['fin']?.toString(),
      motivo: json['motivo']?.toString() ?? '',
      pendiente: json['pendiente'] == true,
    );
  }
}

class JornadaAsignacion {
  final int id;
  final int empresaId;
  final String puesto;
  final List<List<String>> tramos;
  final String obs;
  final String aviso;
  final bool fichable;
  final bool enCurso;
  final List<JornadaExtra> extra;

  JornadaAsignacion({
    required this.id,
    required this.empresaId,
    required this.puesto,
    required this.tramos,
    required this.obs,
    required this.aviso,
    required this.fichable,
    required this.enCurso,
    this.extra = const [],
  });

  factory JornadaAsignacion.fromJson(Map<String, dynamic> json) {
    return JornadaAsignacion(
      id: int.tryParse(json['id'].toString()) ?? 0,
      empresaId: int.tryParse(json['empresa_id'].toString()) ?? 0,
      puesto: json['puesto']?.toString() ?? '',
      tramos: ((json['tramos'] as List?) ?? [])
          .map<List<String>>(
              (t) => (t as List).map((h) => h.toString()).toList())
          .toList(),
      obs: json['obs']?.toString() ?? '',
      aviso: json['aviso']?.toString() ?? '',
      fichable: json['fichable'] == true,
      enCurso: json['en_curso'] == true,
      extra: ((json['extra'] as List?) ?? [])
          .map((e) => JornadaExtra.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class JornadaFichaje {
  final String tipo;
  final String origen;
  final int? empresaId;
  final String hora;

  JornadaFichaje({
    required this.tipo,
    required this.origen,
    required this.empresaId,
    required this.hora,
  });

  factory JornadaFichaje.fromJson(Map<String, dynamic> json) {
    return JornadaFichaje(
      tipo: json['tipo']?.toString() ?? '',
      origen: json['origen']?.toString() ?? '',
      empresaId: json['empresa_id'] == null
          ? null
          : int.tryParse(json['empresa_id'].toString()),
      hora: json['hora']?.toString() ?? '',
    );
  }
}

class JornadaTramoCalculado {
  final String ini;
  final String fin;
  final bool trabajado;
  final bool futuro;
  final String? iniReal;
  final bool iniRojo;
  final String? finReal;
  final bool finRojo;
  final String? extra;
  final bool pendiente;

  JornadaTramoCalculado({
    required this.ini,
    required this.fin,
    required this.trabajado,
    required this.futuro,
    required this.iniReal,
    required this.iniRojo,
    required this.finReal,
    required this.finRojo,
    this.extra,
    this.pendiente = false,
  });

  factory JornadaTramoCalculado.fromJson(Map<String, dynamic> json) {
    return JornadaTramoCalculado(
      ini: json['ini']?.toString() ?? '',
      fin: json['fin']?.toString() ?? '',
      trabajado: json['trabajado'] == true,
      futuro: json['futuro'] == true,
      iniReal: json['ini_real']?.toString(),
      iniRojo: json['ini_rojo'] == true,
      finReal: json['fin_real']?.toString(),
      finRojo: json['fin_rojo'] == true,
      extra: json['extra']?.toString(),
      pendiente: json['pendiente'] == true,
    );
  }
}

class JornadaHueco {
  final String salida;
  final String entrada;

  JornadaHueco({required this.salida, required this.entrada});

  factory JornadaHueco.fromJson(Map<String, dynamic> json) {
    return JornadaHueco(
      salida: json['salida']?.toString() ?? '',
      entrada: json['entrada']?.toString() ?? '',
    );
  }
}

class JornadaCalculoAsignacion {
  final int asignacionId;
  final int empresaId;
  final String obsPrevisto;
  final List<JornadaTramoCalculado> tramos;
  final List<JornadaHueco> huecos;
  final List<String> avisos;

  JornadaCalculoAsignacion({
    required this.asignacionId,
    required this.empresaId,
    required this.obsPrevisto,
    required this.tramos,
    required this.huecos,
    required this.avisos,
  });

  factory JornadaCalculoAsignacion.fromJson(Map<String, dynamic> json) {
    return JornadaCalculoAsignacion(
      asignacionId: int.tryParse(json['asignacion_id'].toString()) ?? 0,
      empresaId: int.tryParse(json['empresa_id'].toString()) ?? 0,
      obsPrevisto: json['obs_previsto']?.toString() ?? '',
      tramos: ((json['tramos'] as List?) ?? [])
          .map((e) => JornadaTramoCalculado.fromJson(e as Map<String, dynamic>))
          .toList(),
      huecos: ((json['huecos'] as List?) ?? [])
          .map((e) => JornadaHueco.fromJson(e as Map<String, dynamic>))
          .toList(),
      avisos: ((json['avisos'] as List?) ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class JornadaHoy {
  final String fecha;
  final List<JornadaAsignacion> asignaciones;
  final bool dentro;
  final String? entradaAbierta;
  final int? empresaAbierta;
  final List<JornadaFichaje> fichajes;
  final bool calculoOk;
  final String calculoAviso;
  final List<JornadaCalculoAsignacion> calculo;

  JornadaHoy({
    required this.fecha,
    required this.asignaciones,
    required this.dentro,
    required this.entradaAbierta,
    required this.empresaAbierta,
    required this.fichajes,
    required this.calculoOk,
    required this.calculoAviso,
    required this.calculo,
  });

  factory JornadaHoy.fromJson(Map<String, dynamic> json) {
    final Map? c = json['calculo'] is Map ? json['calculo'] as Map : null;
    final bool ok = c != null && c['ok'] == true;
    return JornadaHoy(
      fecha: json['fecha']?.toString() ?? '',
      asignaciones: ((json['asignaciones'] as List?) ?? [])
          .map((e) => JornadaAsignacion.fromJson(e as Map<String, dynamic>))
          .toList(),
      dentro: json['estado'] == 'dentro',
      entradaAbierta: json['entrada_abierta']?.toString(),
      empresaAbierta: json['empresa_abierta'] == null
          ? null
          : int.tryParse(json['empresa_abierta'].toString()),
      fichajes: ((json['fichajes'] as List?) ?? [])
          .map((e) => JornadaFichaje.fromJson(e as Map<String, dynamic>))
          .toList(),
      calculoOk: ok,
      calculoAviso: c?['aviso']?.toString() ?? '',
      calculo: ok
          ? ((c['asignaciones'] as List?) ?? [])
              .map((e) =>
                  JornadaCalculoAsignacion.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  /// Hay una entrada abierta de un día anterior: hay que declarar la salida antes de fichar.
  bool get pendienteDeDiaAnterior =>
      dentro && entradaAbierta != null && entradaAbierta != fecha;

  /// Opciones para fichar una entrada ahora: una por empresa, con la que está en curso primero.
  List<JornadaAsignacion> get opcionesEntrada {
    final Map<int, JornadaAsignacion> porEmpresa = {};
    for (final a in asignaciones.where((a) => a.fichable)) {
      final actual = porEmpresa[a.empresaId];
      if (actual == null || (a.enCurso && !actual.enCurso)) {
        porEmpresa[a.empresaId] = a;
      }
    }
    final lista = porEmpresa.values.toList();
    lista.sort((x, y) => (y.enCurso ? 1 : 0) - (x.enCurso ? 1 : 0));
    return lista;
  }
}
