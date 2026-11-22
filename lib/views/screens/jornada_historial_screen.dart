import 'package:colegia_atenea/models/jornada_historial_model.dart';
import 'package:colegia_atenea/models/jornada_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

class JornadaHistorialScreen extends StatefulWidget {
  const JornadaHistorialScreen({super.key});

  @override
  State<JornadaHistorialScreen> createState() => _JornadaHistorialScreenState();
}

class _JornadaHistorialScreenState extends State<JornadaHistorialScreen> {
  static const List<String> _dias = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];
  static const List<String> _mesesCortos = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
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
  late DateTime _mes;
  JornadaHistorial? _datos;
  bool _cargando = true;
  String? _error;
  int _cargaId = 0;
  String? _abierto;

  @override
  void initState() {
    super.initState();
    final DateTime ahora = DateTime.now();
    _mes = DateTime(ahora.year, ahora.month);
    _cargar();
  }

  String _token() => AppSharedPreferences.getBasicAthToken() ?? '';
  String _cookie() {
    if (AppSharedPreferences.getUserLoggedInRole() == 'assistant') {
      return AppSharedPreferences.getAssistantLoggedInData()?.cookie ?? '';
    }
    return AppSharedPreferences.getUserData()?.cookies ?? '';
  }

  String _claveMes(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  bool get _esMesActual {
    final DateTime ahora = DateTime.now();
    return _mes.year == ahora.year && _mes.month == ahora.month;
  }

  String get _hoy {
    final DateTime ahora = DateTime.now();
    return '${_claveMes(ahora)}-${ahora.day.toString().padLeft(2, '0')}';
  }

  Future<void> _cargar({bool mostrarCarga = true}) async {
    final int id = ++_cargaId;
    if (mostrarCarga) setState(() => _cargando = true);
    try {
      final response = await _api.getJornadaHistorial(
        token: _token(),
        cookie: _cookie(),
        mes: _claveMes(_mes),
      );
      if (!mounted || id != _cargaId) return;
      if (response['status'] == true) {
        setState(() {
          _datos = JornadaHistorial.fromJson(response);
          _error = null;
          _cargando = false;
        });
      } else {
        setState(() {
          _error = response['Message']?.toString() ??
              'No se pudo cargar el histórico';
          _cargando = false;
        });
      }
    } catch (e) {
      if (!mounted || id != _cargaId) return;
      setState(() {
        _error = 'No se pudo cargar el histórico';
        _cargando = false;
      });
    }
  }

  void _cambiarMes(int delta) {
    setState(() {
      _mes = DateTime(_mes.year, _mes.month + delta);
      _abierto = null;
      _datos = null;
      _error = null;
    });
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color10,
      body: Column(
        children: [
          _cabecera(),
          Expanded(child: _cuerpo()),
        ],
      ),
    );
  }

  Widget _cabecera() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 14),
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
                  'Histórico de jornada',
                  style: AppTextStyle.getOutfit600(
                      textSize: 20, textColor: AppColors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _cambiarMes(-1),
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.white, size: 26),
              ),
              SizedBox(
                width: 170,
                child: Text(
                  '${_meses[_mes.month - 1]} ${_mes.year}',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.getOutfit500(
                      textSize: 16, textColor: AppColors.white),
                ),
              ),
              IconButton(
                onPressed: _esMesActual ? null : () => _cambiarMes(1),
                icon: Icon(Icons.chevron_right,
                    color: AppColors.white
                        .withValues(alpha: _esMesActual ? 0.35 : 1),
                    size: 26),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando && _datos == null) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return _mensajeCentrado(_error!, reintentar: true);
    }
    final List<JornadaHistorialDia> dias = _datos?.dias ?? [];
    if (dias.isEmpty) {
      return _mensajeCentrado('No hay registros este mes');
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _cargar(mostrarCarga: false),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          for (final d in dias) _filaDia(d),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Center(
              child: Text(
                'Solo se muestran los días con registros',
                style: AppTextStyle.getOutfit400(
                    textSize: 12,
                    textColor: AppColors.secondary.withValues(alpha: 0.6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mensajeCentrado(String texto, {bool reintentar = false}) {
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
            if (reintentar)
              TextButton(
                onPressed: _cargar,
                child: Text('Reintentar',
                    style: AppTextStyle.getOutfit500(
                        textSize: 15, textColor: AppColors.primary)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _filaDia(JornadaHistorialDia dia) {
    final bool abierto = _abierto == dia.fecha;
    final DateTime f = DateTime.parse(dia.fecha);
    final Color gris = AppColors.secondary.withValues(alpha: 0.6);
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _abierto = abierto ? null : dia.fecha),
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 62,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_dias[f.weekday - 1]} ${f.day}',
                        style: AppTextStyle.getOutfit600(
                            textSize: 14, textColor: AppColors.secondary),
                      ),
                      Text(
                        _mesesCortos[f.month - 1],
                        style: AppTextStyle.getOutfit400(
                            textSize: 11, textColor: gris),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dia.rango,
                        style: AppTextStyle.getOutfit400(
                            textSize: 14, textColor: AppColors.secondary),
                      ),
                      Text(
                        dia.resumen,
                        style: AppTextStyle.getOutfit400(
                            textSize: 11, textColor: gris),
                      ),
                    ],
                  ),
                ),
                if (dia.entradaSinSalida && dia.fecha != _hoy)
                  const Tooltip(
                    message: 'Quedó una entrada sin salida',
                    child: Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.warning_amber_rounded,
                          size: 18, color: AppColors.red),
                    ),
                  ),
                if (dia.hayDeclarada)
                  Tooltip(
                    message: 'Hay una salida declarada',
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.edit_outlined, size: 18, color: gris),
                    ),
                  ),
                if (dia.hayVerificacion)
                  const Tooltip(
                    message: 'El Consejo de Administración dio fe',
                    child: Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.verified_user_outlined,
                          size: 18, color: AppColors.green),
                    ),
                  ),
                Icon(
                  abierto
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: gris,
                ),
              ],
            ),
          ),
        ),
        Divider(
            height: 0.5,
            thickness: 0.5,
            color: AppColors.secondary.withValues(alpha: 0.12)),
        if (abierto)
          Container(
            width: double.infinity,
            color: AppColors.color10,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                for (final b in dia.bloques)
                  _tarjetaBloque(b, cerrado: dia.fecha != _hoy),
              ],
            ),
          ),
      ],
    );
  }

  /// Color suave de cada agrupamiento, para distinguir los tramos de un vistazo.
  Color _colorAgrupamiento(String? agrupamiento) {
    final String n = (agrupamiento ?? '').toLowerCase();
    if (n.isEmpty) return AppColors.white;
    if (n.contains('profesor')) return AppColors.blueLight;
    if (n.contains('empresa')) return AppColors.orange.withValues(alpha: 0.28);
    if (n.contains('consejo')) {
      return AppColors.darkPurple.withValues(alpha: 0.10);
    }
    final List<Color> otros = [
      AppColors.greenLight,
      AppColors.primary.withValues(alpha: 0.08),
      AppColors.secondary.withValues(alpha: 0.08),
    ];
    final int suma = n.codeUnits.fold(0, (a, b) => a + b);
    return otros[suma % otros.length];
  }

  Widget _nota(String texto, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        texto,
        style: AppTextStyle.getOutfit400(textSize: 11, textColor: color),
      ),
    );
  }

  Widget _cajaVerificacion(JornadaVerificacion v) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(Icons.verified_user_outlined,
                    size: 15, color: AppColors.green),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  v.titulo,
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${v.verificador} · ${v.cuando}',
            style: AppTextStyle.getOutfit400(
                textSize: 12, textColor: AppColors.secondary),
          ),
          Text(
            'Motivo: ${v.motivo}',
            style: AppTextStyle.getOutfit400(
                textSize: 12, textColor: AppColors.secondary),
          ),
          Text(
            'Código ${v.codigo}',
            style: AppTextStyle.getOutfit400(
                textSize: 11,
                textColor: AppColors.secondary.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  /// Texto de la entrada o la salida de un tramo: la hora real solo viene
  /// cuando se aleja 10 minutos o más de la prevista.
  TextSpan _extremo({
    required String nombre,
    required String? real,
    required bool rojo,
    required String textoSiNoRojo,
    required String textoSiRojo,
    String? sinFichar,
  }) {
    final Color gris = AppColors.secondary.withValues(alpha: 0.6);
    if (real == null && sinFichar != null) {
      return TextSpan(
        text: '$nombre $sinFichar',
        style: AppTextStyle.getOutfit500(textSize: 12, textColor: AppColors.red),
      );
    }
    if (real == null) {
      return TextSpan(
        text: '$nombre en hora',
        style: AppTextStyle.getOutfit400(textSize: 12, textColor: gris),
      );
    }
    return TextSpan(
      text: '$nombre $real (${rojo ? textoSiRojo : textoSiNoRojo})',
      style: AppTextStyle.getOutfit500(
          textSize: 12,
          textColor: rojo ? AppColors.red : AppColors.secondary),
    );
  }

  Widget _filaTramo(JornadaTramoCalculado t, {required bool sinSalida}) {
    final Color gris = AppColors.secondary.withValues(alpha: 0.6);
    final String horario = t.pendiente ? '${t.ini} – …' : '${t.ini} – ${t.fin}';
    final String resultado = t.trabajado
        ? 'Trabajado'
        : (t.futuro ? 'Por venir' : 'Sin registro');
    final Color colorResultado = t.trabajado
        ? AppColors.green
        : (t.futuro ? gris : AppColors.red);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  horario,
                  style: AppTextStyle.getOutfit600(
                      textSize: 15, textColor: AppColors.secondary),
                ),
              ),
              Text(
                resultado,
                style: AppTextStyle.getOutfit500(
                    textSize: 12, textColor: colorResultado),
              ),
            ],
          ),
          if (t.extra != null && t.extra!.isNotEmpty)
            _nota('Tramo adicional · ${t.extra}', gris),
          if (t.trabajado)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text.rich(
                TextSpan(
                  children: [
                    _extremo(
                      nombre: 'Entrada',
                      real: t.iniReal,
                      rojo: t.iniRojo,
                      textoSiNoRojo: 'antes',
                      textoSiRojo: 'tarde',
                    ),
                    TextSpan(
                      text: '  ·  ',
                      style: AppTextStyle.getOutfit400(
                          textSize: 12, textColor: gris),
                    ),
                    _extremo(
                      nombre: 'Salida',
                      real: t.finReal,
                      rojo: t.finRojo,
                      textoSiNoRojo: 'después',
                      textoSiRojo: 'anticipada',
                      sinFichar: sinSalida ? 'sin fichar' : null,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _lineaFichajes(JornadaHistorialBloque b) {
    final Color gris = AppColors.secondary.withValues(alpha: 0.6);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 14,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Fichajes',
            style: AppTextStyle.getOutfit400(textSize: 11, textColor: gris),
          ),
          for (final f in b.fichajes)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(f.tipo == 'entrada' ? Icons.login : Icons.logout,
                    size: 14, color: AppColors.secondary),
                const SizedBox(width: 3),
                Text(
                  f.hora,
                  style: AppTextStyle.getOutfit500(
                      textSize: 13, textColor: AppColors.secondary),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _notasFichajes(JornadaHistorialBloque b) {
    final Color gris = AppColors.secondary.withValues(alpha: 0.6);
    final List<Widget> notas = [];
    for (final f in b.fichajes) {
      final String nombre = f.tipo == 'entrada' ? 'Entrada' : 'Salida';
      if (f.registrado != null) {
        notas.add(_nota('$nombre declarada el ${f.registrado}', gris));
      }
      if (f.verificacion != null && f.horaFichada != f.hora) {
        notas.add(_nota('$nombre fichada a las ${f.horaFichada}', gris));
      }
    }
    return notas;
  }

  Widget _tarjetaBloque(JornadaHistorialBloque b, {required bool cerrado}) {
    final Color gris = AppColors.secondary.withValues(alpha: 0.6);
    final String agrupamiento =
        b.agrupamiento.isNotEmpty ? b.agrupamiento : 'Sin agrupamiento';
    final bool mostrarPuesto = b.puesto.isNotEmpty &&
        b.puesto.toLowerCase() != b.agrupamiento.toLowerCase();
    int ultimoTrabajado = -1;
    for (int i = 0; i < b.tramos.length; i++) {
      if (b.tramos[i].trabajado) ultimoTrabajado = i;
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: _colorAgrupamiento(b.agrupamiento),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            agrupamiento,
            style: AppTextStyle.getOutfit500(
                textSize: 14, textColor: AppColors.secondary),
          ),
          if (mostrarPuesto)
            Text(
              b.puesto,
              style: AppTextStyle.getOutfit400(textSize: 12, textColor: gris),
            ),
          for (int i = 0; i < b.tramos.length; i++)
            _filaTramo(
              b.tramos[i],
              sinSalida: cerrado && b.entradaSinSalida && i == ultimoTrabajado,
            ),
          if (b.fichajes.isNotEmpty) _lineaFichajes(b),
          ..._notasFichajes(b),
          for (final v in b.verificaciones) _cajaVerificacion(v),
        ],
      ),
    );
  }
}
