import 'dart:async';
import 'dart:convert';
import 'package:colegia_atenea/models/tutoria_model.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/tutoria_aceptar_mensaje_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/tutoria_asistentes_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/tutoria_proponer_fecha_sheet.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/tutoria_historial_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/tutoria_firmas_pendientes_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TutoriasProfesorScreen extends StatefulWidget {
  final int initialTabIndex;
  final int initialActaSubTabIndex;

  const TutoriasProfesorScreen({super.key, this.initialTabIndex = 0, this.initialActaSubTabIndex = 0});

  @override
  State<TutoriasProfesorScreen> createState() => _TutoriasProfesorScreenState();
}

class _TutoriasProfesorScreenState extends State<TutoriasProfesorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<TutoriaModel> pendientes = [];
  bool isLoadingPendientes = true;

  List<TutoriaModel> agenda = [];
  bool isLoadingAgenda = true;

  List<TutoriaModel> pendientesActa = [];
  bool isLoadingActa = true;

  List<TutoriaModel> historico = [];
  bool isLoadingHistorico = true;

  // --- Estado del formulario "Solicitar" ---
  List<TutoriaClaseSelectorModel> _clases = [];
  bool _isLoadingClases = true;
  int? _claseSeleccionadaCid;
  TutoriaAlumnoSelectorModel? _alumnoSeleccionado;
  final Set<int> _familiaSeleccionada = {};
  DateTime? _fechaHoraSeleccionada;
  String? _mensajeFechaHora;
  final TextEditingController _motivoSolicitarController = TextEditingController();
  bool _isEnviandoSolicitud = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: widget.initialTabIndex);
    _loadPendientes();
    _loadClases();
    _loadAgenda();
    _loadPendientesActa();
    _loadHistorico();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 2) _loadAgenda();
      if (_tabController.index == 3) _loadPendientesActa();
    });
  }

  Future<void> _loadHistorico() async {
    setState(() => isLoadingHistorico = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasProfesorHistorico(
        token: token,
        cookie: cookie,
        teacherWpUsrId: _teacherId,
      );

      if (response['status'] == true) {
        final List data = response['tutorias'] ?? [];
        setState(() {
          historico = TutoriaModel.listFromJson(data);
          isLoadingHistorico = false;
        });
      } else {
        setState(() => isLoadingHistorico = false);
      }
    } catch (e) {
      setState(() => isLoadingHistorico = false);
    }
  }

  Future<void> _loadPendientesActa() async {
    setState(() => isLoadingActa = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasProfesorActaPendientes(
        token: token,
        cookie: cookie,
        teacherWpUsrId: _teacherId,
      );

      if (response['status'] == true) {
        final List data = response['tutorias'] ?? [];
        setState(() {
          pendientesActa = TutoriaModel.listFromJson(data);
          isLoadingActa = false;
        });
      } else {
        setState(() => isLoadingActa = false);
      }
    } catch (e) {
      setState(() => isLoadingActa = false);
    }
  }

  Future<void> _loadAgenda() async {
    setState(() => isLoadingAgenda = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasProfesorAgenda(
        token: token,
        cookie: cookie,
        teacherWpUsrId: _teacherId,
      );

      if (response['status'] == true) {
        final List data = response['tutorias'] ?? [];
        setState(() {
          agenda = TutoriaModel.listFromJson(data);
          isLoadingAgenda = false;
        });
      } else {
        setState(() => isLoadingAgenda = false);
      }
    } catch (e) {
      setState(() => isLoadingAgenda = false);
    }
  }

  Future<void> _loadClases() async {
    setState(() => _isLoadingClases = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasProfesorAlumnos(
        token: token,
        cookie: cookie,
        teacherWpUsrId: _teacherId,
      );

      if (response['status'] == true) {
        final List data = response['clases'] ?? [];
        setState(() {
          _clases = TutoriaClaseSelectorModel.listFromJson(data);
          _isLoadingClases = false;
        });
      } else {
        setState(() => _isLoadingClases = false);
      }
    } catch (e) {
      setState(() => _isLoadingClases = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _motivoSolicitarController.dispose();
    super.dispose();
  }

  String get _teacherId => AppSharedPreferences.getUserData()?.wpUsrId ?? '';

  Future<void> _loadPendientes() async {
    setState(() => isLoadingPendientes = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasProfesorPendientes(
        token: token,
        cookie: cookie,
        teacherWpUsrId: _teacherId,
      );

      if (response['status'] == true) {
        final List data = response['tutorias'] ?? [];
        setState(() {
          pendientes = TutoriaModel.listFromJson(data);
          isLoadingPendientes = false;
        });
      } else {
        setState(() => isLoadingPendientes = false);
      }
    } catch (e) {
      setState(() => isLoadingPendientes = false);
    }
  }

  Future<void> _elegirFechaHora() async {
    final resultado = await showTutoriaProponerFechaSheet(
      context,
      title: 'Fecha y hora de la tutoría',
    );
    if (resultado == null) return;
    setState(() {
      _fechaHoraSeleccionada = DateTime.parse(resultado['fecha_propuesta']!);
      _mensajeFechaHora = resultado['mensaje']?.isNotEmpty == true ? resultado['mensaje'] : null;
    });
  }

  Future<void> _enviarSolicitudProfesor() async {
    if (_alumnoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un alumno/a')),
      );
      return;
    }
    if (_familiaSeleccionada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un familiar')),
      );
      return;
    }
    if (_fechaHoraSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha y hora')),
      );
      return;
    }
    if (_motivoSolicitarController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El motivo es obligatorio')),
      );
      return;
    }

    setState(() => _isEnviandoSolicitud = true);

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';
    final fechaFormateada =
        '${_fechaHoraSeleccionada!.toIso8601String().substring(0, 10)} '
        '${_fechaHoraSeleccionada!.hour.toString().padLeft(2, '0')}:'
        '${_fechaHoraSeleccionada!.minute.toString().padLeft(2, '0')}:00';

    final response = await ApiClass().solicitarTutoriaProfesor(
      token: token,
      cookie: cookie,
      teacherWpUsrId: _teacherId,
      studentId: _alumnoSeleccionado!.wpUsrId.toString(),
      fechaPropuesta: fechaFormateada,
      motivoSolicitud: _motivoSolicitarController.text.trim(),
      padresIdsJson: jsonEncode(_familiaSeleccionada.toList()),
      mensajeFechaHora: _mensajeFechaHora,
    );

    setState(() => _isEnviandoSolicitud = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) {
        setState(() {
          _claseSeleccionadaCid = null;
          _alumnoSeleccionado = null;
          _familiaSeleccionada.clear();
          _fechaHoraSeleccionada = null;
          _mensajeFechaHora = null;
          _motivoSolicitarController.clear();
        });
        _tabController.animateTo(1);
        await _loadPendientes();
      }
    }
  }

  Future<void> _aceptarPendiente(TutoriaModel item) async {
    final mensaje = await showTutoriaAceptarMensajeSheet(context);
    if (mensaje == null) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().aceptarTutoria(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      actorWpUsrId: _teacherId,
      actorRol: 'profesor',
      mensaje: mensaje.isNotEmpty ? mensaje : null,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) {
        await Future.wait([
          _loadPendientes(),
          _loadAgenda(),
          _loadPendientesActa(),
        ]);
      }
    }
  }

  Future<void> _cancelarPendiente(TutoriaModel item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar tutoría'),
        content: const Text('¿Seguro que quieres cancelar esta tutoría?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (confirmar != true) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().cancelarTutoria(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      actorWpUsrId: _teacherId,
      actorRol: 'profesor',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) await _loadPendientes();
    }
  }

  Future<void> _aplazarPendiente(TutoriaModel item) async {
    final resultado = await showTutoriaProponerFechaSheet(
      context,
      title: 'Aplazar tutoría',
    );
    if (resultado == null) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().aplazarTutoriaProfesor(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      teacherWpUsrId: _teacherId,
      fechaPropuesta: resultado['fecha_propuesta']!,
      motivo: resultado['mensaje']?.isNotEmpty == true ? resultado['mensaje'] : null,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) await _loadPendientes();
    }
  }

  Future<void> _nuevaPropuestaPendiente(TutoriaModel item) async {
    final resultado = await showTutoriaProponerFechaSheet(
      context,
      title: 'Proponer nueva fecha',
    );
    if (resultado == null) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().nuevaPropuestaTutoriaProfesor(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      teacherWpUsrId: _teacherId,
      fechaPropuesta: resultado['fecha_propuesta']!,
      mensaje: resultado['mensaje']?.isNotEmpty == true ? resultado['mensaje'] : null,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) await _loadPendientes();
    }
  }

  Map<String, dynamic> _estadoInfo(String estado) {
    switch (estado) {
      case 'pendiente':
        return {'label': '⏳ Pendiente', 'color': Colors.orange};
      case 'aplazada':
        return {'label': '📅 Aplazada', 'color': Colors.blue};
      case 'rechazada':
        return {'label': '🔄 Nueva fecha propuesta por familia', 'color': Colors.deepOrange};
      default:
        return {'label': estado, 'color': Colors.grey};
    }
  }

  String _formatFecha(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final parts = dateStr.split(' ');
      final dateParts = parts[0].split('-');
      final hora = parts.length > 1 ? parts[1].substring(0, 5) : '';
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}${hora.isNotEmpty ? ' $hora' : ''}';
    } catch (_) {
      return dateStr;
    }
  }

  String _familiaNombre(TutoriaModel item) {
    final p1 = item.padreNombre;
    final p2 = item.padre2Nombre;
    if (p1.isNotEmpty && p2.isNotEmpty) return '$p1 / $p2';
    if (p1.isNotEmpty) return p1;
    if (p2.isNotEmpty) return p2;
    return 'Familia';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
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
                        'Tutorías',
                        style: AppTextStyle.getOutfit600(
                            textSize: 22, textColor: AppColors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppColors.white,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
                  labelStyle: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.white),
                  unselectedLabelStyle: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.white),
                  tabs: [
                    const Tab(text: 'Solicitar'),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Pendientes'),
                          if (!isLoadingPendientes && pendientes.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('${pendientes.length}',
                                  style: AppTextStyle.getOutfit700(textSize: 11, textColor: AppColors.white)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Agenda'),
                          if (!isLoadingAgenda && agenda.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('${agenda.length}',
                                  style: AppTextStyle.getOutfit700(textSize: 11, textColor: AppColors.white)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Tab(text: 'Registrar Actas'),
                    const Tab(text: 'Histórico'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSolicitarTab(),
                _buildPendientesTab(),
                _buildAgendaTab(),
                _RegistrarActasSection(
                  teacherId: _teacherId,
                  pendientesActa: pendientesActa,
                  isLoadingActa: isLoadingActa,
                  onReloadPendientesActa: _loadPendientesActa,
                  onHistoricoActualizado: _loadHistorico,
                  onAgendaActualizada: _loadAgenda,
                  initialSubTabIndex: widget.initialActaSubTabIndex,
                  formatFecha: _formatFecha,
                  familiaNombre: _familiaNombre,
                ),
                _buildHistoricoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendientesTab() {
    if (isLoadingPendientes) {
      return const Center(child: LoadingLayout());
    }
    if (pendientes.isEmpty) {
      return Center(
        child: Text(
          'No tienes tutorías pendientes de confirmar',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadPendientes,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: pendientes.length,
        itemBuilder: (context, index) => _buildPendienteCard(pendientes[index]),
      ),
    );
  }

  Widget _buildPendienteCard(TutoriaModel item) {
    final estadoInfo = _estadoInfo(item.estado);
    final Color statusColor = estadoInfo['color'];
    final String statusLabel = estadoInfo['label'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.alumnoNombre,
                      style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.secondary)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusLabel,
                      style: AppTextStyle.getOutfit600(textSize: 11, textColor: statusColor)),
                ),
              ],
            ),
            // Pestaña: Pendientes de Confirmar (Profesor)
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Familia: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: _familiaNombre(item), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Solicitada por: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: item.tipoSolicitud == 'profesor' ? 'Usted' : 'Familia', style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Fecha propuesta: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: _formatFecha(item.fechaPropuesta), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            if (item.motivoSolicitud.isNotEmpty) ...[
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Motivo: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                  TextSpan(text: item.motivoSolicitud, style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
                ]),
              ),
            ],
            if (item.motivoRechazo.isNotEmpty) ...[
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Propuesta de la familia: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: Colors.deepOrange)),
                  TextSpan(text: item.motivoRechazo, style: AppTextStyle.getOutfit400(textSize: 12, textColor: Colors.deepOrange.withValues(alpha: 0.8))),
                ]),
              ),
            ],
            _buildAccionesPendiente(item),
            const Divider(height: 20),
            TutoriaHistorialWidget(tutoriaId: item.id, currentUserRol: 'profesor'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccionesPendiente(TutoriaModel item) {
    final List<Widget> botones = [];

    if (item.estado == 'pendiente' && item.tipoSolicitud == 'padre') {
      botones.add(_actionButton('Aceptar', Colors.green, () => _aceptarPendiente(item)));
      botones.add(_actionButton('Aplazar', AppColors.primary, () => _aplazarPendiente(item)));
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelarPendiente(item)));
    } else if (item.estado == 'pendiente' && item.tipoSolicitud == 'profesor') {
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelarPendiente(item)));
    } else if (item.estado == 'aplazada') {
      botones.add(_actionButton('Aplazar de nuevo', AppColors.primary, () => _aplazarPendiente(item)));
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelarPendiente(item)));
    } else if (item.estado == 'rechazada') {
      botones.add(_actionButton('Nueva propuesta', AppColors.primary, () => _nuevaPropuestaPendiente(item)));
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelarPendiente(item)));
    }

    if (botones.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(spacing: 8, runSpacing: 8, children: botones),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      child: Text(
        label,
        style: AppTextStyle.getOutfit600(textSize: 12, textColor: color),
      ),
    );
  }

  Widget _buildSolicitarTab() {
    if (_isLoadingClases) {
      return const Center(child: LoadingLayout());
    }
    if (_clases.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron clases asignadas',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }

    final claseActual = _claseSeleccionadaCid != null
        ? _clases.firstWhere((c) => c.cid == _claseSeleccionadaCid, orElse: () => _clases.first)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clase', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Selecciona una clase'),
                value: _claseSeleccionadaCid,
                items: _clases.map((c) {
                  return DropdownMenuItem<int>(value: c.cid, child: Text(c.cName));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _claseSeleccionadaCid = value;
                    _alumnoSeleccionado = null;
                    _familiaSeleccionada.clear();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (claseActual != null) ...[
            Text('Alumno/a', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: const Text('Selecciona un alumno/a'),
                  value: _alumnoSeleccionado?.wpUsrId,
                  items: claseActual.alumnos.map((a) {
                    return DropdownMenuItem<int>(value: a.wpUsrId, child: Text(a.label));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _alumnoSeleccionado = claseActual.alumnos.firstWhere((a) => a.wpUsrId == value);
                      _familiaSeleccionada
                        ..clear()
                        ..addAll(_alumnoSeleccionado!.familia.map((f) => f.wpUsrId));
                    });
                  },
                ),
              ),
            ),
          ],
          if (_alumnoSeleccionado != null) ...[
            const SizedBox(height: 20),
            Text('Familia a convocar', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
            const SizedBox(height: 8),
            ..._alumnoSeleccionado!.familia.map((f) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(f.nombre, style: AppTextStyle.getOutfit400(textSize: 14, textColor: AppColors.secondary)),
                value: _familiaSeleccionada.contains(f.wpUsrId),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _familiaSeleccionada.add(f.wpUsrId);
                    } else {
                      _familiaSeleccionada.remove(f.wpUsrId);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 12),
            Text(
              'Nota: se notificará a ambos progenitores si existen (la selección solo afecta a esta vista).',
              style: AppTextStyle.getOutfit400(
                  textSize: 11, textColor: AppColors.secondary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            Text('Fecha y hora', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _elegirFechaHora,
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(
                _fechaHoraSeleccionada != null
                    ? _formatFecha(
                        '${_fechaHoraSeleccionada!.toIso8601String().substring(0, 10)} '
                        '${_fechaHoraSeleccionada!.hour.toString().padLeft(2, '0')}:'
                        '${_fechaHoraSeleccionada!.minute.toString().padLeft(2, '0')}:00')
                    : 'Seleccionar fecha y hora',
              ),
            ),
            const SizedBox(height: 20),
            Text('Motivo', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _motivoSolicitarController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe brevemente el motivo de la tutoría',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isEnviandoSolicitud ? null : _enviarSolicitudProfesor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isEnviandoSolicitud
                    ? const SizedBox(
                        height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                    : Text('Enviar solicitud',
                        style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgendaTab() {
    if (isLoadingAgenda) {
      return const Center(child: LoadingLayout());
    }
    if (agenda.isEmpty) {
      return Center(
        child: Text(
          'No tienes tutorías próximas confirmadas',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadAgenda,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: agenda.length,
        itemBuilder: (context, index) => _buildAgendaCard(agenda[index]),
      ),
    );
  }

  Widget _buildAgendaCard(TutoriaModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.alumnoNombre,
                      style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.secondary)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('✔ Aceptada',
                      style: AppTextStyle.getOutfit600(textSize: 11, textColor: Colors.green)),
                ),
              ],
            ),
            // Pestaña: Agenda (Profesor)
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Familia: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: _familiaNombre(item), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Solicitada por: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: item.tipoSolicitud == 'profesor' ? 'Usted' : 'Familia', style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            Text('Fecha: ${_formatFecha(item.fechaPropuesta)}',
                style: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.primary)),
            if (item.motivoSolicitud.isNotEmpty) ...[
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Motivo: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                  TextSpan(text: item.motivoSolicitud, style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
                ]),
              ),
            ],
            const Divider(height: 20),
            TutoriaHistorialWidget(tutoriaId: item.id, currentUserRol: 'profesor'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoTab() {
    if (isLoadingHistorico) {
      return const Center(child: LoadingLayout());
    }
    if (historico.isEmpty) {
      return Center(
        child: Text(
          'No hay tutorías en el histórico',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadHistorico,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: historico.length,
        itemBuilder: (context, index) => _buildHistoricoCard(historico[index]),
      ),
    );
  }

  Future<void> _descargarPdf(TutoriaModel item) async {
    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().getTutoriaActaPdf(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
    );

    if (!mounted) return;

    if (response['status'] == true && response['PDFLink'] != null) {
      await launchUrl(Uri.parse(response['PDFLink']));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'No se pudo generar el PDF')),
      );
    }
  }

  Future<void> _eliminarTutoria(TutoriaModel item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tutoría'),
        content: const Text(
            'Esta acción es irreversible y borrará permanentemente el registro y su historial. ¿Deseas continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().eliminarTutoria(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      teacherWpUsrId: _teacherId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) _loadHistorico();
    }
  }

  Widget _buildHistoricoCard(TutoriaModel item) {
    final estadoInfo = _estadoInfo(item.estado);
    final Color statusColor = item.estado == 'celebrada' ? Colors.green : (estadoInfo['color'] as Color);
    final String statusLabel = item.estado == 'celebrada' ? '✔ Firmada' : (estadoInfo['label'] as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.alumnoNombre,
                      style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.secondary)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusLabel,
                      style: AppTextStyle.getOutfit600(textSize: 11, textColor: statusColor)),
                ),
              ],
            ),
            // Pestaña Histórico (Profesor)
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Familia: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: _familiaNombre(item), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Fecha: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: _formatFecha(item.fechaPropuesta), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Solicitada por: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: item.tipoSolicitud == 'padre' ? 'Familia' : 'Usted', style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            if (item.motivoSolicitud.isNotEmpty) ...[
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Motivo: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                  TextSpan(text: item.motivoSolicitud, style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
                ]),
              ),
            ],
            if (item.estado == 'celebrada' && item.asistentes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Asistentes:',
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(
                TutoriaAsistentesSeleccionModel.fromJsonString(item.asistentes).toDisplayText(),
                style: AppTextStyle.getOutfit400(
                    textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6)),
              ),
            ],
            if (item.estado == 'celebrada' && item.asuntosTratados.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Asuntos:',
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(item.asuntosTratados,
                  style: AppTextStyle.getOutfit400(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
            ],
            if (item.estado == 'celebrada' && item.observaciones.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Observaciones:',
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(item.observaciones,
                  style: AppTextStyle.getOutfit400(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
            ],
            if (item.estado == 'celebrada') ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _descargarPdf(item),
                  icon: const Icon(Icons.picture_as_pdf, size: 16),
                  label: Text('Descarga PDF',
                      style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => _eliminarTutoria(item),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: Text('Eliminar',
                      style: AppTextStyle.getOutfit600(textSize: 12, textColor: Colors.red)),
                ),
              ),
            ],
            const Divider(height: 20),
            TutoriaHistorialWidget(tutoriaId: item.id, currentUserRol: 'profesor'),
          ],
        ),
      ),
    );
  }
}

/// Sección "Registrar Actas" del profesor, con 3 pestañas internas:
/// Para su Envío (actas aceptadas aún sin enviar a firmar), Firmar
/// (las propias firmas pendientes del profesor como asistente más) y
/// En Proceso de Firma (seguimiento de solo lectura de todas las actas
/// ya enviadas a firmar, mientras no estén completas).
class _RegistrarActasSection extends StatefulWidget {
  final String teacherId;
  final List<TutoriaModel> pendientesActa;
  final bool isLoadingActa;
  final Future<void> Function() onReloadPendientesActa;
  final Future<void> Function() onHistoricoActualizado;
  final Future<void> Function() onAgendaActualizada;
  final int initialSubTabIndex;
  final String Function(String) formatFecha;
  final String Function(TutoriaModel) familiaNombre;

  const _RegistrarActasSection({
    required this.teacherId,
    required this.pendientesActa,
    required this.isLoadingActa,
    required this.onReloadPendientesActa,
    required this.onHistoricoActualizado,
    required this.onAgendaActualizada,
    this.initialSubTabIndex = 0,
    required this.formatFecha,
    required this.familiaNombre,
  });

  @override
  State<_RegistrarActasSection> createState() => _RegistrarActasSectionState();
}

class _RegistrarActasSectionState extends State<_RegistrarActasSection>
    with SingleTickerProviderStateMixin {
  late TabController _innerTabController;

  List<TutoriaModel> _enProceso = [];
  bool _isLoadingEnProceso = true;
  int _firmarCount = 0;

@override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 3, vsync: this, initialIndex: widget.initialSubTabIndex);
    _cargarEnProceso();
    _cargarFirmarCount();
  }

  Future<void> _cargarFirmarCount() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasFirmaPendientes(
        token: token,
        cookie: cookie,
        wpUsrId: widget.teacherId,
      );

      if (mounted && response['status'] == true) {
        final List data = response['pendientes'] ?? [];
        setState(() => _firmarCount = data.length);
      }
    } catch (e) {
      // Silencioso: el widget "Firmar" recalculará el contador al visitarse
    }
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  Future<void> _cargarEnProceso() async {
    setState(() => _isLoadingEnProceso = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasProfesorEnProcesoFirma(
        token: token,
        cookie: cookie,
        teacherWpUsrId: widget.teacherId,
      );

      if (mounted && response['status'] == true) {
        final List data = response['tutorias'] ?? [];
        setState(() {
          _enProceso = TutoriaModel.listFromJson(data);
          _isLoadingEnProceso = false;
        });
      } else if (mounted) {
        setState(() => _isLoadingEnProceso = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingEnProceso = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          child: TabBar(
            controller: _innerTabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.secondary.withValues(alpha: 0.5),
            indicatorColor: AppColors.primary,
            labelStyle: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.primary),
            unselectedLabelStyle: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary),
            tabs: [
              _buildTabConBadge('Para su Envío', widget.pendientesActa.length),
              _buildTabConBadge('Firmar', _firmarCount),
              _buildTabConBadge('En Proceso de Firma', _enProceso.length),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              _buildParaSuEnvio(),
              TutoriaFirmasPendientesWidget(
                wpUsrId: widget.teacherId,
                onCountChanged: (count) {
                  if (mounted) setState(() => _firmarCount = count);
                },
              ),
              _buildEnProceso(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabConBadge(String texto, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(texto),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: AppTextStyle.getOutfit700(textSize: 11, textColor: AppColors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParaSuEnvio() {
    if (widget.isLoadingActa) {
      return const Center(child: LoadingLayout());
    }
    if (widget.pendientesActa.isEmpty) {
      return Center(
        child: Text(
          'No tienes actas pendientes de registrar',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: widget.onReloadPendientesActa,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.pendientesActa.length,
        itemBuilder: (context, index) => _ActaFormCard(
          tutoria: widget.pendientesActa[index],
          teacherId: widget.teacherId,
          formatFecha: widget.formatFecha,
          familiaNombre: widget.familiaNombre,
          onGuardado: () {
            widget.onReloadPendientesActa();
            _cargarEnProceso();
          },
        ),
      ),
    );
  }

  Widget _buildEnProceso() {
    if (_isLoadingEnProceso) {
      return const Center(child: LoadingLayout());
    }
    if (_enProceso.isEmpty) {
      return Center(
        child: Text(
          'No hay actas en proceso de firma',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargarEnProceso,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _enProceso.length,
        itemBuilder: (context, index) => _EnProcesoFirmaCard(
          tutoria: _enProceso[index],
          teacherId: widget.teacherId,
          formatFecha: widget.formatFecha,
          familiaNombre: widget.familiaNombre,
          onFinalizado: () {
            _cargarEnProceso();
            widget.onHistoricoActualizado();
            widget.onAgendaActualizada();
          },
        ),
      ),
    );
  }
}

/// Tarjeta de solo lectura para "En Proceso de Firma": muestra el
/// contenido del acta ya guardado y el progreso de firmas de cada
/// asistente, sin ninguna acción disponible desde aquí.
class _EnProcesoFirmaCard extends StatefulWidget {
  final TutoriaModel tutoria;
  final String teacherId;
  final String Function(String) formatFecha;
  final String Function(TutoriaModel) familiaNombre;
  final VoidCallback onFinalizado;

  const _EnProcesoFirmaCard({
    required this.tutoria,
    required this.teacherId,
    required this.formatFecha,
    required this.familiaNombre,
    required this.onFinalizado,
  });

  @override
  State<_EnProcesoFirmaCard> createState() => _EnProcesoFirmaCardState();
}

class _EnProcesoFirmaCardState extends State<_EnProcesoFirmaCard> {
  bool _isLoading = true;
  TutoriaEstadoFirmasModel? _estado;
  Timer? _pollTimer;
  bool _isFinalizando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _cargar() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasEstadoFirmas(
        token: token,
        cookie: cookie,
        tutoriaId: widget.tutoria.id.toString(),
      );

      if (mounted && response['status'] == true) {
        final estado = TutoriaEstadoFirmasModel.fromJson(response);
        setState(() {
          _estado = estado;
          _isLoading = false;
        });
        if (!estado.completo) {
          _pollTimer ??= Timer.periodic(const Duration(seconds: 8), (_) => _cargar());
        } else {
          _pollTimer?.cancel();
          _pollTimer = null;
        }
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _finalizarActa() async {
    setState(() => _isFinalizando = true);

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().finalizarActaTutoria(
      token: token,
      cookie: cookie,
      tutoriaId: widget.tutoria.id.toString(),
      teacherWpUsrId: widget.teacherId,
    );

    if (mounted) {
      setState(() => _isFinalizando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) {
        widget.onFinalizado();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.tutoria;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.alumnoNombre,
                style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.secondary)),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Familia: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: widget.familiaNombre(item), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Fecha: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: widget.formatFecha(item.fechaPropuesta), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            if (item.asuntosTratados.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Asuntos:',
                  style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(item.asuntosTratados,
                  style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
            ],
            if (item.observaciones.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Observaciones:',
                  style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(item.observaciones,
                  style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
            ],
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
            else if (_estado != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Firmas: ${_estado!.firmadas} de ${_estado!.totalAFirmar}',
                        style: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.primary)),
                    const SizedBox(height: 6),
                    ..._estado!.firmas.where((f) => f.tipoRegistro == 'firma').map((f) {
                      final firmado = f.estado == 'firmado';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Icon(firmado ? Icons.check_circle : Icons.hourglass_empty,
                                size: 14, color: firmado ? Colors.green : Colors.orange),
                            const SizedBox(width: 6),
                            Text(f.nombre, style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (_estado!.completo) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFinalizando ? null : _finalizarActa,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: _isFinalizando
                        ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                        : Text('Finalizar Acta',
                            style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.white)),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ActaFormCard extends StatefulWidget {
  final TutoriaModel tutoria;
  final String teacherId;
  final String Function(String) formatFecha;
  final String Function(TutoriaModel) familiaNombre;
  final VoidCallback onGuardado;

  const _ActaFormCard({
    required this.tutoria,
    required this.teacherId,
    required this.formatFecha,
    required this.familiaNombre,
    required this.onGuardado,
  });

  @override
  State<_ActaFormCard> createState() => _ActaFormCardState();
}

class _ActaFormCardState extends State<_ActaFormCard> {
  final TextEditingController _asuntosController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _anotacionesController = TextEditingController();
  TutoriaAsistentesSeleccionModel _asistentes = TutoriaAsistentesSeleccionModel();
  bool _isEnviandoFirma = false;

  @override
  void initState() {
    super.initState();
    _asuntosController.text = widget.tutoria.asuntosTratados;
    _observacionesController.text = widget.tutoria.observaciones;
    _anotacionesController.text = widget.tutoria.anotacionesProfesor;
  }

  @override
  void dispose() {
    _asuntosController.dispose();
    _observacionesController.dispose();
    _anotacionesController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarAsistentes() async {
    final resultado = await showTutoriaAsistentesSheet(
      context,
      tutoriaId: widget.tutoria.id.toString(),
      seleccionInicial: _asistentes,
    );
    if (resultado != null) {
      setState(() => _asistentes = resultado);
    }
  }

  Future<void> _enviarAFirmar() async {
    if (_asuntosController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los asuntos tratados son obligatorios')),
      );
      return;
    }
    if (_asistentes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar al menos un asistente')),
      );
      return;
    }

    setState(() => _isEnviandoFirma = true);

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

    final response = await ApiClass().enviarActaAFirmar(
      token: token,
      cookie: cookie,
      tutoriaId: widget.tutoria.id.toString(),
      teacherWpUsrId: widget.teacherId,
      asistentesJson: jsonEncode(_asistentes.toJson()),
      asuntosTratados: _asuntosController.text.trim(),
      observaciones: _observacionesController.text.trim(),
      anotacionesProfesor: _anotacionesController.text.trim(),
    );

    if (mounted) {
      setState(() => _isEnviandoFirma = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) {
        widget.onGuardado();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.tutoria;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.alumnoNombre,
                style: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.secondary)),
            const SizedBox(height: 4),
            // Pestaña: Registrar Acta (Profesor)
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Familia: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: widget.familiaNombre(item), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Fecha: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: widget.formatFecha(item.fechaPropuesta), style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Solicitada por: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: item.tipoSolicitud == 'padre' ? 'Familia' : 'Usted', style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            if (item.motivoSolicitud.isNotEmpty) ...[
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Motivo: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                  TextSpan(text: item.motivoSolicitud, style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
                ]),
              ),
            ],
            const SizedBox(height: 12),
            Text('Asistentes *', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
            const SizedBox(height: 6),
            if (_asistentes.isEmpty)
              OutlinedButton.icon(
                onPressed: _seleccionarAsistentes,
                icon: const Icon(Icons.people_outline, size: 18),
                label: const Text('Seleccionar asistentes'),
              )
            else
              InkWell(
                onTap: _seleccionarAsistentes,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_asistentes.toDisplayText(),
                          style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary)),
                      const SizedBox(height: 4),
                      Text('Toca para editar', style: AppTextStyle.getOutfit400(textSize: 11, textColor: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: _asuntosController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Asuntos tratados *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _observacionesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observaciones (visible a la familia)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anotacionesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Anotaciones privadas (solo usted las verá)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isEnviandoFirma ? null : _enviarAFirmar,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: _isEnviandoFirma
                    ? const SizedBox(
                        height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                    : Text('Enviar a Firmar',
                        style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
