import 'package:colegia_atenea/models/jornada_model.dart';

/// Verificación del Consejo de Administración sobre un fichaje (o sobre un
/// fichaje que no se hizo).
class JornadaVerificacion {
  final String tipo;
  final String titulo;
  final String? hora;
  final String motivo;
  final String verificador;
  final String cuando;
  final String codigo;
  final int? asignacionId;

  JornadaVerificacion({
    required this.tipo,
    required this.titulo,
    required this.hora,
    required this.motivo,
    required this.verificador,
    required this.cuando,
    required this.codigo,
    required this.asignacionId,
  });

  factory JornadaVerificacion.fromJson(Map<String, dynamic> json) {
    return JornadaVerificacion(
      tipo: json['tipo']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      hora: json['hora']?.toString(),
      motivo: json['motivo']?.toString() ?? '',
      verificador: json['verificador']?.toString() ?? '',
      cuando: json['cuando']?.toString() ?? '',
      codigo: json['codigo']?.toString() ?? '',
      asignacionId: int.tryParse(json['asignacion_id']?.toString() ?? ''),
    );
  }
}

class JornadaHistorialFichaje {
  final String tipo;
  final String origen;
  final int? empresaId;
  final String? agrupamiento;
  final String hora;
  final String horaFichada;
  final String? registrado;
  final JornadaVerificacion? verificacion;

  JornadaHistorialFichaje({
    required this.tipo,
    required this.origen,
    required this.empresaId,
    required this.agrupamiento,
    required this.hora,
    required this.horaFichada,
    required this.registrado,
    required this.verificacion,
  });

  factory JornadaHistorialFichaje.fromJson(Map<String, dynamic> json) {
    return JornadaHistorialFichaje(
      tipo: json['tipo']?.toString() ?? '',
      origen: json['origen']?.toString() ?? '',
      empresaId: int.tryParse(json['empresa_id']?.toString() ?? ''),
      agrupamiento: json['agrupamiento']?.toString(),
      hora: json['hora']?.toString() ?? '',
      horaFichada: json['hora_fichada']?.toString() ?? '',
      registrado: json['registrado']?.toString(),
      verificacion: json['verificacion'] is Map
          ? JornadaVerificacion.fromJson(
              json['verificacion'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Cálculo del día de una asignación (tramos previstos y horas reales), con su
/// puesto y su agrupamiento.
class JornadaHistorialAsignacion {
  final JornadaCalculoAsignacion calculo;
  final String puesto;
  final String agrupamiento;

  JornadaHistorialAsignacion({
    required this.calculo,
    required this.puesto,
    required this.agrupamiento,
  });

  factory JornadaHistorialAsignacion.fromJson(Map<String, dynamic> json) {
    return JornadaHistorialAsignacion(
      calculo: JornadaCalculoAsignacion.fromJson(json),
      puesto: json['puesto']?.toString() ?? '',
      agrupamiento: json['agrupamiento']?.toString() ?? '',
    );
  }
}

/// Todo lo de un día que corresponde a un mismo puesto: lo previsto, lo
/// fichado y lo verificado por el Consejo.
class JornadaHistorialBloque {
  final int? asignacionId;
  final int? empresaId;
  final String agrupamiento;
  final String puesto;
  final List<JornadaTramoCalculado> tramos;
  final List<JornadaHistorialFichaje> fichajes = [];
  final List<JornadaVerificacion> sinFichaje = [];

  JornadaHistorialBloque({
    required this.asignacionId,
    required this.empresaId,
    required this.agrupamiento,
    required this.puesto,
    required this.tramos,
  });

  bool get vacio => tramos.isEmpty && fichajes.isEmpty && sinFichaje.isEmpty;

  /// El último fichaje del puesto es una entrada y el Consejo no dio fe de la
  /// salida: quedó sin salida.
  bool get entradaSinSalida =>
      fichajes.isNotEmpty &&
      fichajes.last.tipo == 'entrada' &&
      !sinFichaje.any((v) => v.tipo == 'salida');

  /// Verificaciones del Consejo de este puesto, por orden de aparición.
  List<JornadaVerificacion> get verificaciones => [
        for (final f in fichajes)
          if (f.verificacion != null) f.verificacion!,
        ...sinFichaje,
      ];

  String get _orden {
    if (tramos.isNotEmpty) return tramos.first.ini;
    if (fichajes.isNotEmpty) return fichajes.first.hora;
    return 'zz';
  }
}

class JornadaHistorialDia {
  final String fecha;
  final List<JornadaHistorialFichaje> fichajes;
  final List<JornadaVerificacion> sinFichaje;
  final List<JornadaHistorialAsignacion> asignaciones;

  JornadaHistorialDia({
    required this.fecha,
    required this.fichajes,
    required this.sinFichaje,
    required this.asignaciones,
  });

  factory JornadaHistorialDia.fromJson(Map<String, dynamic> json) {
    return JornadaHistorialDia(
      fecha: json['fecha']?.toString() ?? '',
      fichajes: ((json['fichajes'] as List?) ?? [])
          .map((e) =>
              JornadaHistorialFichaje.fromJson(e as Map<String, dynamic>))
          .toList(),
      sinFichaje: ((json['sin_fichaje'] as List?) ?? [])
          .map((e) => JornadaVerificacion.fromJson(e as Map<String, dynamic>))
          .toList(),
      asignaciones: ((json['asignaciones'] as List?) ?? [])
          .map((e) =>
              JornadaHistorialAsignacion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Un bloque por puesto con lo previsto, lo fichado y lo verificado. Lo que
  /// no encaja en ningún puesto del cálculo (una asignación ya terminada, por
  /// ejemplo) va en un bloque aparte para que no se pierda.
  List<JornadaHistorialBloque> get bloques {
    final List<JornadaHistorialBloque> lista = [
      for (final a in asignaciones)
        JornadaHistorialBloque(
          asignacionId: a.calculo.asignacionId,
          empresaId: a.calculo.empresaId,
          agrupamiento: a.agrupamiento,
          puesto: a.puesto,
          tramos: a.calculo.tramos,
        ),
    ];
    for (final f in fichajes) {
      JornadaHistorialBloque? b;
      for (final x in lista) {
        if (f.empresaId != null && x.empresaId == f.empresaId) {
          b = x;
          break;
        }
      }
      if (b == null) {
        b = JornadaHistorialBloque(
          asignacionId: null,
          empresaId: f.empresaId,
          agrupamiento: f.agrupamiento ?? '',
          puesto: '',
          tramos: [],
        );
        lista.add(b);
      }
      b.fichajes.add(f);
    }
    for (final v in sinFichaje) {
      JornadaHistorialBloque? b;
      for (final x in lista) {
        if (v.asignacionId != null && x.asignacionId == v.asignacionId) {
          b = x;
          break;
        }
      }
      if (b == null) {
        b = JornadaHistorialBloque(
          asignacionId: v.asignacionId,
          empresaId: null,
          agrupamiento: '',
          puesto: '',
          tramos: [],
        );
        lista.add(b);
      }
      b.sinFichaje.add(v);
    }
    final List<JornadaHistorialBloque> con =
        lista.where((b) => !b.vacio).toList();
    con.sort((a, b) => a._orden.compareTo(b._orden));
    return con;
  }

  /// Horas de las entradas y salidas del día, por orden, con las
  /// verificaciones sin fichaje incluidas.
  List<String> get _horas {
    final List<String> horas = [
      for (final f in fichajes) f.hora,
      for (final v in sinFichaje) v.hora ?? '',
    ].where((h) => h.isNotEmpty).toList();
    horas.sort();
    return horas;
  }

  String get rango {
    final List<String> horas = _horas;
    if (horas.isEmpty) return '—';
    if (horas.length == 1) return horas.first;
    return '${horas.first} → ${horas.last}';
  }

  String get resumen {
    final String base =
        fichajes.length == 1 ? '1 fichaje' : '${fichajes.length} fichajes';
    if (sinFichaje.isEmpty) return base;
    return '$base · ${sinFichaje.length} sin fichar';
  }

  bool get hayVerificacion =>
      sinFichaje.isNotEmpty || fichajes.any((f) => f.verificacion != null);

  bool get hayDeclarada => fichajes.any((f) => f.origen == 'declarado');

  /// Algún puesto terminó el día con una entrada sin salida.
  bool get entradaSinSalida => bloques.any((b) => b.entradaSinSalida);
}

class JornadaHistorial {
  final String mes;
  final List<JornadaHistorialDia> dias;

  JornadaHistorial({required this.mes, required this.dias});

  factory JornadaHistorial.fromJson(Map<String, dynamic> json) {
    return JornadaHistorial(
      mes: json['mes']?.toString() ?? '',
      dias: ((json['dias'] as List?) ?? [])
          .map((e) => JornadaHistorialDia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
