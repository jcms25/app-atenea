import 'dart:async';

import 'package:colegia_atenea/models/jornada_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

class JornadaScreen extends StatefulWidget {
  const JornadaScreen({super.key});

  @override
  State<JornadaScreen> createState() => _JornadaScreenState();
}

class _JornadaScreenState extends State<JornadaScreen>
    with WidgetsBindingObserver {
  static const List<String> _dias = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];
  static const List<String> _meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  final ApiClass _api = ApiClass();
  JornadaHoy? _hoy;
  bool _cargando = true;
  bool _enviando = false;
  String? _error;
  TimeOfDay? _horaDeclarada;
  Timer? _refresco;
  int _cargaId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cargar();
    _refresco = Timer.periodic(const Duration(seconds: 60), (_) {
      if (!_enviando) _cargar(mostrarCarga: false);
    });
  }

  @override
  void dispose() {
    _refresco?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_enviando) {
      _cargar(mostrarCarga: false);
    }
  }

  String _token() => AppSharedPreferences.getBasicAthToken() ?? '';
  String _cookie() {
    if (AppSharedPreferences.getUserLoggedInRole() == 'assistant') {
      return AppSharedPreferences.getAssistantLoggedInData()?.cookie ?? '';
    }
    return AppSharedPreferences.getUserData()?.cookies ?? '';
  }

  Future<void> _cargar({bool mostrarCarga = true}) async {
    final int id = ++_cargaId;
    if (mostrarCarga) setState(() => _cargando = true);
    try {
      final response =
          await _api.getJornadaHoy(token: _token(), cookie: _cookie());
      if (!mounted || id != _cargaId) return;
      if (response['status'] == true) {
        setState(() {
          _hoy = JornadaHoy.fromJson(response);
          _error = null;
          _cargando = false;
        });
      } else {
        setState(() {
          _error = response['Message']?.toString() ??
              'No se pudo cargar tu jornada';
          _cargando = false;
        });
      }
    } catch (e) {
      if (!mounted || id != _cargaId) return;
      setState(() {
        _error = 'No se pudo cargar tu jornada';
        _cargando = false;
      });
    }
  }

  void _avisar(dynamic response) {
    final bool ok = response['status'] == true;
    final String mensaje = response['Message']?.toString() ??
        (ok ? 'Hecho' : 'No se pudo completar la acción');
    AppConstants.showCustomToast(status: ok, message: mensaje);
  }

  Future<void> _fichar(String tipo, {int? empresaId}) async {
    if (_enviando) return;
    setState(() => _enviando = true);
    try {
      final response = await _api.jornadaFichar(
        token: _token(),
        cookie: _cookie(),
        uuidEnvio: _api.jornadaNuevoUuid(),
        tipoEsperado: tipo,
        empresaId: empresaId,
      );
      _avisar(response);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
    await _cargar(mostrarCarga: false);
  }

  /// Pide confirmación si la salida se ficha con 10 minutos o más de antelación
  /// sobre el final del tramo en curso. Si no, ficha la salida directamente.
  Future<void> _pedirSalida(JornadaHoy hoy) async {
    final int? faltan = _minutosParaFinTramo(hoy);
    if (faltan != null && faltan >= 10) {
      final bool? seguir = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            '¿Fichar la salida ahora?',
            style: AppTextStyle.getOutfit600(
                textSize: 17, textColor: AppColors.secondary),
          ),
          content: Text(
            'Todavía faltan $faltan minutos para que acabe tu tramo. '
            'Si sales ahora, la salida quedará registrada a esta hora y no se puede deshacer.',
            style: AppTextStyle.getOutfit400(
                textSize: 14, textColor: AppColors.secondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancelar',
                style: AppTextStyle.getOutfit600(
                    textSize: 14,
                    textColor: AppColors.secondary.withValues(alpha: 0.7)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Fichar salida',
                style: AppTextStyle.getOutfit600(
                    textSize: 14, textColor: AppColors.primary),
              ),
            ),
          ],
        ),
      );
      if (seguir != true || !mounted) return;
    }
    await _fichar('salida');
  }

  Future<void> _cambiar(int empresaDestino) async {
    if (_enviando) return;
    setState(() => _enviando = true);
    try {
      final salida = await _api.jornadaFichar(
        token: _token(),
        cookie: _cookie(),
        uuidEnvio: _api.jornadaNuevoUuid(),
        tipoEsperado: 'salida',
      );
      if (salida['status'] == true) {
        final entrada = await _api.jornadaFichar(
          token: _token(),
          cookie: _cookie(),
          uuidEnvio: _api.jornadaNuevoUuid(),
          tipoEsperado: 'entrada',
          empresaId: empresaDestino,
        );
        _avisar(entrada);
      } else {
        _avisar(salida);
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
    await _cargar(mostrarCarga: false);
  }

  Future<void> _elegirHora() async {
    final TimeOfDay? elegida = await showTimePicker(
      context: context,
      initialTime: _horaDeclarada ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (elegida != null && mounted) {
      setState(() => _horaDeclarada = elegida);
    }
  }

  String _formatoHora(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _declararSalida() async {
    final TimeOfDay? hora = _horaDeclarada;
    if (hora == null) {
      AppConstants.showCustomToast(
          status: false, message: 'Indica la hora de salida');
      return;
    }
    if (_enviando) return;
    setState(() => _enviando = true);
    try {
      final response = await _api.jornadaDeclararSalida(
        token: _token(),
        cookie: _cookie(),
        uuidEnvio: _api.jornadaNuevoUuid(),
        hora: _formatoHora(hora),
      );
      _avisar(response);
      if (response['status'] == true) {
        _horaDeclarada = null;
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
    await _cargar(mostrarCarga: false);
  }

  // ------------------------------------------------------------
  // Utilidades de datos y fechas
  // ------------------------------------------------------------
  int _min(String hhmm) =>
      (int.tryParse(hhmm.substring(0, 2)) ?? 0) * 60 +
      (int.tryParse(hhmm.substring(3, 5)) ?? 0);

  String _hhmm(int m) =>
      '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

  int _ahora() {
    final DateTime n = DateTime.now();
    return n.hour * 60 + n.minute;
  }

  /// Minutos que faltan para que acabe el tramo en curso de la empresa en la
  /// que estás dentro, o null si ahora no hay ningún tramo en curso.
  int? _minutosParaFinTramo(JornadaHoy hoy) {
    final int ahora = _ahora();
    for (final a in hoy.asignaciones) {
      if (a.empresaId != hoy.empresaAbierta) continue;
      for (final t in a.tramos) {
        final int ini = _min(t[0]);
        final int fin = _min(t[1]);
        if (ahora >= ini && ahora < fin) return fin - ahora;
      }
    }
    return null;
  }

  String _fechaCabecera(String fecha) {
    final DateTime? d = DateTime.tryParse(fecha);
    if (d == null) return fecha;
    final String dia = _dias[d.weekday - 1];
    return '${dia[0].toUpperCase()}${dia.substring(1)}, ${d.day} de ${_meses[d.month - 1]}';
  }

  String _fechaLarga(String fecha) {
    final DateTime? d = DateTime.tryParse(fecha);
    if (d == null) return fecha;
    return '${_dias[d.weekday - 1]} ${d.day} de ${_meses[d.month - 1]}';
  }

  String _puestoDeEmpresa(int? empresaId) {
    final JornadaHoy? hoy = _hoy;
    if (hoy == null || empresaId == null) return '';
    for (final a in hoy.asignaciones) {
      if (a.empresaId == empresaId) return a.puesto;
    }
    return '';
  }

  String _puestoDeAsignacion(int asignacionId) {
    final JornadaHoy? hoy = _hoy;
    if (hoy == null) return '';
    for (final a in hoy.asignaciones) {
      if (a.id == asignacionId) return a.puesto;
    }
    return '';
  }

  JornadaAsignacion? _otraOpcion(JornadaHoy hoy) {
    for (final o in hoy.opcionesEntrada) {
      if (o.empresaId != hoy.empresaAbierta) return o;
    }
    return null;
  }

  String _detalleOpcion(JornadaAsignacion a) {
    final int ahora = _ahora();
    for (final t in a.tramos) {
      if (ahora >= _min(t[0]) && ahora < _min(t[1])) {
        return 'En curso hasta ${t[1]}';
      }
    }
    for (final t in a.tramos) {
      if (_min(t[0]) > ahora) return 'Desde ${t[0]}';
    }
    return '';
  }

  String _mensajeSinOpciones(JornadaHoy hoy) {
    bool hayTramos = false;
    bool ausenciaTotal = false;
    for (final a in hoy.asignaciones) {
      if (a.tramos.isNotEmpty) hayTramos = true;
      if (a.obs.contains('Ausencia: todo el día')) ausenciaTotal = true;
    }
    if (!hayTramos) {
      return ausenciaTotal
          ? 'Tienes una ausencia de todo el día registrada.'
          : 'Hoy no tienes horario previsto. Si debes fichar, pide que lo configuren en la web.';
    }
    final int ahora = _ahora();
    int? proximo;
    for (final a in hoy.asignaciones) {
      for (final t in a.tramos) {
        final int ini = _min(t[0]);
        if (ini > ahora && (proximo == null || ini < proximo)) proximo = ini;
      }
    }
    if (proximo != null) return 'Podrás fichar desde las ${_hhmm(proximo - 15)}.';
    return 'Hoy ya no tienes más tramos previstos.';
  }

  // ------------------------------------------------------------
  // Construcción de la pantalla
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _cabecera(),
          Expanded(child: _cuerpo()),
        ],
      ),
    );
  }

  Widget _cabecera() {
    final String? fecha = _hoy?.fecha;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios,
                      color: AppColors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Text(
                  'Mi jornada de hoy',
                  style: AppTextStyle.getOutfit600(
                      textSize: 22, textColor: AppColors.white),
                ),
              ],
            ),
          ),
          if (fecha != null)
            Padding(
              padding: const EdgeInsets.only(left: 47, top: 4),
              child: Text(
                _fechaCabecera(fecha),
                style: AppTextStyle.getOutfit400(
                    textSize: 13,
                    textColor: AppColors.white.withValues(alpha: 0.85)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    final JornadaHoy? hoy = _hoy;
    if (hoy == null) {
      return _mensajeCentrado(_error ?? 'No se pudo cargar tu jornada');
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _cargar(mostrarCarga: false),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: hoy.asignaciones.isEmpty
            ? [_texto('No tienes ningún horario previsto en el registro de jornada.')]
            : hoy.pendienteDeDiaAnterior
                ? _vistaSalidaPendiente(hoy)
                : _vistaNormal(hoy),
      ),
    );
  }

  Widget _mensajeCentrado(String texto) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texto,
              textAlign: TextAlign.center,
              style: AppTextStyle.getOutfit400(
                  textSize: 15, textColor: AppColors.secondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _cargar(),
              child: Text(
                'Reintentar',
                style: AppTextStyle.getOutfit600(
                    textSize: 15, textColor: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _vistaNormal(JornadaHoy hoy) {
    return [
      ...(hoy.dentro ? _bloqueDentro(hoy) : _bloqueFuera(hoy)),
      if (hoy.fichajes.isNotEmpty) ..._bloqueRegistros(hoy),
      if (hoy.calculoOk) ..._bloqueResumen(hoy),
    ];
  }

  List<Widget> _bloqueFuera(JornadaHoy hoy) {
    final List<JornadaAsignacion> opciones = hoy.opcionesEntrada;
    final List<Widget> widgets = [
      _chip(Icons.exit_to_app, 'Fuera del centro', activo: false),
      const SizedBox(height: 18),
    ];
    if (opciones.isEmpty) {
      widgets.add(_texto(_mensajeSinOpciones(hoy)));
    } else if (opciones.length == 1) {
      widgets.add(_botonPrimario(
        icono: Icons.login,
        texto: 'Fichar entrada',
        onTap: () => _fichar('entrada', empresaId: opciones.first.empresaId),
      ));
    } else {
      widgets.add(_etiqueta('Fichar entrada en'));
      for (int i = 0; i < opciones.length; i++) {
        widgets.add(_tarjetaOpcion(opciones[i], propuesto: i == 0));
      }
      widgets.add(_nota(
          'Solo aparecen las opciones con un tramo ahora o que empiece en 15 minutos.'));
    }
    return widgets;
  }

  List<Widget> _bloqueDentro(JornadaHoy hoy) {
    String desde = '';
    for (final f in hoy.fichajes) {
      if (f.tipo == 'entrada') desde = f.hora;
    }
    final String puesto = _puestoDeEmpresa(hoy.empresaAbierta);
    final String texto = 'Dentro'
        '${puesto.isNotEmpty ? ' en $puesto' : ''}'
        '${desde.isNotEmpty ? ' desde las $desde' : ''}';
    final JornadaAsignacion? destino = _otraOpcion(hoy);
    return [
      _chip(Icons.check_circle_outline, texto, activo: true),
      const SizedBox(height: 18),
      _botonPrimario(
        icono: Icons.logout,
        texto: 'Fichar salida',
        onTap: () => _pedirSalida(hoy),
      ),
      if (destino != null) ...[
        const SizedBox(height: 10),
        _botonSecundario(
          icono: Icons.swap_horiz,
          texto: 'Cambiar a ${destino.puesto}',
          onTap: () => _cambiar(destino.empresaId),
        ),
        _nota('Registra tu salida${puesto.isNotEmpty ? ' de $puesto' : ''} '
            'y tu entrada en ${destino.puesto}.'),
      ],
    ];
  }

  List<Widget> _bloqueRegistros(JornadaHoy hoy) {
    return [
      const SizedBox(height: 22),
      _etiqueta('Tus registros de hoy'),
      for (final f in hoy.fichajes) _filaRegistro(f),
    ];
  }

  Widget _filaRegistro(JornadaFichaje f) {
    final bool esEntrada = f.tipo == 'entrada';
    final String puesto = _puestoDeEmpresa(f.empresaId);
    String texto = esEntrada ? 'Entrada' : 'Salida';
    if (esEntrada && puesto.isNotEmpty) texto = '$texto · $puesto';
    if (f.origen == 'declarado') texto = '$texto (declarada)';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.secondary.withValues(alpha: 0.12)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            esEntrada ? Icons.login : Icons.logout,
            size: 18,
            color: esEntrada
                ? AppColors.green
                : AppColors.secondary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: AppTextStyle.getOutfit400(
                  textSize: 14, textColor: AppColors.secondary),
            ),
          ),
          Text(
            f.hora,
            style: AppTextStyle.getOutfit600(
                textSize: 14, textColor: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  List<Widget> _bloqueResumen(JornadaHoy hoy) {
    final List<Widget> widgets = [
      const SizedBox(height: 22),
      _etiqueta('Resumen del día'),
    ];
    for (final c in hoy.calculo) {
      final String puesto = _puestoDeAsignacion(c.asignacionId);
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 2),
        child: Text(
          puesto.isNotEmpty ? puesto : 'Tramos',
          style: AppTextStyle.getOutfit600(
              textSize: 14, textColor: AppColors.secondary),
        ),
      ));
      for (final t in c.tramos) {
        widgets.add(_filaTramo(t));
      }
      for (final h in c.huecos) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Salida ${h.salida} · Entrada ${h.entrada}',
            style: AppTextStyle.getOutfit400(
                textSize: 12, textColor: AppColors.red),
          ),
        ));
      }
      if (c.obsPrevisto.isNotEmpty) {
        widgets.add(_nota(c.obsPrevisto));
      }
      for (final a in c.avisos) {
        widgets.add(_nota(a));
      }
    }
    return widgets;
  }

  Widget _filaTramo(JornadaTramoCalculado t) {
    final bool contado = t.trabajado || t.futuro;
    final TextStyle base = AppTextStyle.getOutfit600(
      textSize: 14,
      textColor: contado
          ? AppColors.secondary
          : AppColors.secondary.withValues(alpha: 0.5),
    );
    const TextStyle roja = TextStyle(color: AppColors.red);
    final List<InlineSpan> partes = [TextSpan(text: '${t.ini} – ${t.fin}')];
    if (t.iniReal != null) {
      partes.add(TextSpan(
          text: ' (Entrada ${t.iniReal})', style: t.iniRojo ? roja : null));
    }
    if (t.finReal != null) {
      partes.add(TextSpan(
          text: ' (Salida ${t.finReal})', style: t.finRojo ? roja : null));
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.secondary.withValues(alpha: 0.12)),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text.rich(TextSpan(style: base, children: partes))),
          if (!t.trabajado && !t.futuro)
            Text(
              'Sin registro',
              style: AppTextStyle.getOutfit400(
                  textSize: 12,
                  textColor: AppColors.secondary.withValues(alpha: 0.6)),
            ),
        ],
      ),
    );
  }

  List<Widget> _vistaSalidaPendiente(JornadaHoy hoy) {
    final String puesto = _puestoDeEmpresa(hoy.empresaAbierta);
    final String fecha = hoy.entradaAbierta ?? '';
    final TimeOfDay? hora = _horaDeclarada;
    return [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.orange.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.orange, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Falta tu salida del ${_fechaLarga(fecha)}',
                    style: AppTextStyle.getOutfit600(
                        textSize: 14, textColor: AppColors.secondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    puesto.isNotEmpty
                        ? 'Tienes una entrada abierta en $puesto.'
                        : 'Tienes una entrada abierta.',
                    style: AppTextStyle.getOutfit400(
                        textSize: 13, textColor: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      _etiqueta('Registrar la hora de salida'),
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _enviando ? null : _elegirHora,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hora != null ? _formatoHora(hora) : 'Elegir hora',
                  style: AppTextStyle.getOutfit600(
                      textSize: 16,
                      textColor: hora != null
                          ? AppColors.secondary
                          : AppColors.secondary.withValues(alpha: 0.5)),
                ),
              ),
              Icon(Icons.schedule,
                  size: 20, color: AppColors.secondary.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      _botonPrimario(
        icono: Icons.logout,
        texto: 'Declarar salida',
        onTap: _declararSalida,
      ),
      _nota(
          'Quedará registrada como declarada por ti. Hasta que la indiques no podrás fichar.'),
    ];
  }

  // ------------------------------------------------------------
  // Piezas pequeñas
  // ------------------------------------------------------------
  Widget _texto(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        texto,
        style: AppTextStyle.getOutfit400(
            textSize: 15, textColor: AppColors.secondary),
      ),
    );
  }

  Widget _etiqueta(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: AppTextStyle.getOutfit600(
            textSize: 13,
            textColor: AppColors.secondary.withValues(alpha: 0.7)),
      ),
    );
  }

  Widget _nota(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        texto,
        style: AppTextStyle.getOutfit400(
            textSize: 12,
            textColor: AppColors.secondary.withValues(alpha: 0.7)),
      ),
    );
  }

  Widget _chip(IconData icono, String texto, {required bool activo}) {
    final Color color =
        activo ? AppColors.green : AppColors.secondary.withValues(alpha: 0.7);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                texto,
                style: AppTextStyle.getOutfit600(
                    textSize: 13, textColor: color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaOpcion(JornadaAsignacion a, {required bool propuesto}) {
    final String detalle = _detalleOpcion(a);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _enviando
            ? null
            : () => _fichar('entrada', empresaId: a.empresaId),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: propuesto
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.25),
              width: propuesto ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.puesto,
                      style: AppTextStyle.getOutfit600(
                          textSize: 15, textColor: AppColors.secondary),
                    ),
                    if (detalle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        detalle,
                        style: AppTextStyle.getOutfit400(
                            textSize: 12,
                            textColor:
                                AppColors.secondary.withValues(alpha: 0.7)),
                      ),
                    ],
                  ],
                ),
              ),
              if (propuesto)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Propuesto',
                    style: AppTextStyle.getOutfit600(
                        textSize: 12, textColor: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonPrimario({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _enviando ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: _enviando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.white))
            : Icon(icono, size: 20),
        label: Text(
          texto,
          style: AppTextStyle.getOutfit600(
              textSize: 15, textColor: AppColors.white),
        ),
      ),
    );
  }

  Widget _botonSecundario({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: _enviando ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icono, size: 18),
        label: Text(
          texto,
          style: AppTextStyle.getOutfit600(
              textSize: 14, textColor: AppColors.primary),
        ),
      ),
    );
  }
}
