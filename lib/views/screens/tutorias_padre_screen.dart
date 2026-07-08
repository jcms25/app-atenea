import 'package:colegia_atenea/models/tutoria_model.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/tutoria_aceptar_mensaje_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/tutoria_proponer_mensaje_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/tutoria_historial_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/tutoria_firmas_pendientes_widget.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TutoriasPadreScreen extends StatefulWidget {
  final int initialTabIndex;

  const TutoriasPadreScreen({super.key, this.initialTabIndex = 0});

  @override
  State<TutoriasPadreScreen> createState() => _TutoriasPadreScreenState();
}

class _TutoriasPadreScreenState extends State<TutoriasPadreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<TutoriaModel> activas = [];
  List<TutoriaModel> historico = [];
  bool isLoadingActivas = true;
  bool isLoadingHistorico = true;

  // --- Estado del formulario "Solicitar" ---
  int _firmasPendientesCount = 0;

  String? _hijoSeleccionadoId;
  List<TutoriaProfesorSelectorModel> _profesores = [];
  bool _isLoadingProfesores = false;
  TutoriaProfesorSelectorModel? _profesorSeleccionado;
  final TextEditingController _motivoController = TextEditingController();
  bool _isEnviandoSolicitud = false;

  // Orden de pestañas: 0=Mis Tutorías, 1=Solicitar, 2=Pendientes de Firma, 3=Histórico
  static const int _kTabHistorico = 3;

  String get _parentWpUsrId => AppSharedPreferences.getUserData()?.parentWpUsrId ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 1) _loadActivas();
      if (_tabController.index == _kTabHistorico && isLoadingHistorico) {
        _loadHistorico();
      }
    });
    _loadActivas();
    _cargarFirmasPendientesCount();
  }

  Future<void> _cargarFirmasPendientesCount() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final cookie = AppSharedPreferences.getUserData()?.cookies ?? '';

      final response = await ApiClass().getTutoriasFirmaPendientes(
        token: token,
        cookie: cookie,
        wpUsrId: _parentWpUsrId,
      );

      if (mounted && response['status'] == true) {
        final List data = response['pendientes'] ?? [];
        setState(() => _firmasPendientesCount = data.length);
      }
    } catch (e) {
      // Silencioso: el widget de Pendientes de Firma recalculará el contador al visitarse
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _loadActivas() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getTutoriasPadreActivas(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (response['status'] == true) {
        final List data = response['tutorias'] ?? [];
        setState(() {
          activas = TutoriaModel.listFromJson(data);
          isLoadingActivas = false;
        });
      } else {
        setState(() => isLoadingActivas = false);
      }
    } catch (e) {
      setState(() => isLoadingActivas = false);
    }
  }

  Future<void> _loadHistorico() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getTutoriasPadreHistorico(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
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

  void _reloadAll() {
    setState(() {
      isLoadingActivas = true;
      isLoadingHistorico = true;
    });
    _loadActivas();
    if (_tabController.index == _kTabHistorico) _loadHistorico();
  }

  Future<void> _aceptar(TutoriaModel item) async {
    final mensaje = await showTutoriaAceptarMensajeSheet(context);
    if (mensaje == null) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final userdata = AppSharedPreferences.getUserData();
    final cookie = userdata?.cookies ?? '';
    final parentId = userdata?.parentWpUsrId ?? '';

    final response = await ApiClass().aceptarTutoria(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      actorWpUsrId: parentId,
      actorRol: 'padre',
      mensaje: mensaje.isNotEmpty ? mensaje : null,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) _reloadAll();
    }
  }

  Future<void> _cancelar(TutoriaModel item) async {
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
    final userdata = AppSharedPreferences.getUserData();
    final cookie = userdata?.cookies ?? '';
    final parentId = userdata?.parentWpUsrId ?? '';

    final response = await ApiClass().cancelarTutoria(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      actorWpUsrId: parentId,
      actorRol: 'padre',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) _reloadAll();
    }
  }

  Future<void> _cargarProfesores(String hijoId) async {
    setState(() {
      _isLoadingProfesores = true;
      _profesores = [];
      _profesorSeleccionado = null;
    });
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';

      final response = await ApiClass().getTutoriasPadreProfesores(
        token: token,
        cookie: cookie,
        studentId: hijoId,
      );

      if (response['status'] == true) {
        final List data = response['profesores'] ?? [];
        setState(() {
          _profesores = TutoriaProfesorSelectorModel.listFromJson(data);
          _isLoadingProfesores = false;
        });
      } else {
        setState(() => _isLoadingProfesores = false);
      }
    } catch (e) {
      setState(() => _isLoadingProfesores = false);
    }
  }

  Future<void> _enviarSolicitud() async {
    if (_hijoSeleccionadoId == null || _profesorSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un hijo/a y un profesor/a')),
      );
      return;
    }
    if (_motivoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El motivo es obligatorio')),
      );
      return;
    }
    if (_profesorSeleccionado!.proximaFechaDisponible == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este profesor/a no tiene horario de atención configurado')),
      );
      return;
    }

    setState(() => _isEnviandoSolicitud = true);

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final userdata = AppSharedPreferences.getUserData();
    final cookie = userdata?.cookies ?? '';
    final parentId = userdata?.parentWpUsrId ?? '';

    final response = await ApiClass().solicitarTutoriaPadre(
      token: token,
      cookie: cookie,
      parentWpUsrId: parentId,
      studentId: _hijoSeleccionadoId!,
      teacherWpUsrId: _profesorSeleccionado!.wpUsrId.toString(),
      fechaPropuesta: _profesorSeleccionado!.proximaFechaDisponible!,
      motivoSolicitud: _motivoController.text.trim(),
    );

    setState(() => _isEnviandoSolicitud = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) {
        setState(() {
          _hijoSeleccionadoId = null;
          _profesores = [];
          _profesorSeleccionado = null;
          _motivoController.clear();
        });
        _tabController.animateTo(1);
        _reloadAll();
      }
    }
  }

  Future<void> _proponerNuevaFecha(TutoriaModel item) async {
    final mensaje = await showTutoriaProponerMensajeSheet(context);
    if (mensaje == null) return;

    final token = AppSharedPreferences.getBasicAthToken() ?? '';
    final userdata = AppSharedPreferences.getUserData();
    final cookie = userdata?.cookies ?? '';
    final parentId = userdata?.parentWpUsrId ?? '';

    final response = await ApiClass().proponerFechaTutoriaPadre(
      token: token,
      cookie: cookie,
      tutoriaId: item.id.toString(),
      parentWpUsrId: parentId,
      mensaje: mensaje,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['Message'] ?? 'Operación realizada')),
      );
      if (response['status'] == true) _reloadAll();
    }
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
                  labelStyle: AppTextStyle.getOutfit600(
                      textSize: 14, textColor: AppColors.white),
                  unselectedLabelStyle: AppTextStyle.getOutfit400(
                      textSize: 14, textColor: AppColors.white),
                  tabs: [
                    const Tab(text: 'Solicitar'),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Mis Tutorías'),
                          if (!isLoadingActivas && activas.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${activas.length}',
                                style: AppTextStyle.getOutfit700(
                                    textSize: 11, textColor: AppColors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Pendientes de Firma'),
                          if (_firmasPendientesCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$_firmasPendientesCount',
                                style: AppTextStyle.getOutfit700(textSize: 11, textColor: AppColors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
                _buildActivasTab(),
                TutoriaFirmasPendientesWidget(
                  wpUsrId: _parentWpUsrId,
                  onCountChanged: (count) {
                    if (mounted) setState(() => _firmasPendientesCount = count);
                  },
                ),
                _buildHistoricoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivasTab() {
    if (isLoadingActivas) {
      return const Center(child: LoadingLayout());
    }
    if (activas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available_outlined,
                size: 64, color: AppColors.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              'No tienes tutorías activas',
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: AppColors.secondary),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadActivas,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: activas.length,
        itemBuilder: (context, index) {
          return _buildTutoriaCard(activas[index], esHistorico: false);
        },
      ),
    );
  }

  Widget _buildSolicitarTab() {
    final userdata = AppSharedPreferences.getUserData();
    final List hijos = userdata?.studentData ?? [];

    if (hijos.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron hijos/as asociados',
          style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hijo/a', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Selecciona un hijo/a'),
                value: _hijoSeleccionadoId,
                items: hijos.map<DropdownMenuItem<String>>((h) {
                  final nombre = '${h.sFname ?? ''} ${h.sMname ?? ''} ${h.sLname ?? ''}'.replaceAll('  ', ' ').trim();
                  return DropdownMenuItem<String>(
                    value: h.wpUsrId,
                    child: Text(nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _hijoSeleccionadoId = value;
                  });
                  _cargarProfesores(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_hijoSeleccionadoId != null) ...[
            Text('Profesor/a', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
            const SizedBox(height: 8),
            if (_isLoadingProfesores)
              const Center(child: Padding(padding: EdgeInsets.all(12), child: LoadingLayout()))
            else if (_profesores.isEmpty)
              Text(
                'No se encontraron profesores para este alumno/a',
                style: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary.withValues(alpha: 0.6)),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: const Text('Selecciona un profesor/a'),
                    value: _profesorSeleccionado?.wpUsrId,
                    items: _profesores.map((p) {
                      return DropdownMenuItem<int>(
                        value: p.wpUsrId,
                        child: Text(p.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _profesorSeleccionado = _profesores.firstWhere((p) => p.wpUsrId == value);
                      });
                    },
                  ),
                ),
              ),
            if (_profesorSeleccionado != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     'Próxima fecha de atención a la familia',
                      style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profesorSeleccionado!.proximaFechaDisponible != null
                          ? _formatFecha(_profesorSeleccionado!.proximaFechaDisponible!)
                          : 'Horario de atención no configurado',
                      style: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text('Motivo', style: AppTextStyle.getOutfit600(textSize: 14, textColor: AppColors.secondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _motivoController,
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
                onPressed: _isEnviandoSolicitud ? null : _enviarSolicitud,
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

  Widget _buildHistoricoTab() {
    if (isLoadingHistorico) {
      return const Center(child: LoadingLayout());
    }
    if (historico.isEmpty) {
      return Center(
        child: Text(
          'No hay tutorías en el histórico',
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: historico.length,
      itemBuilder: (context, index) {
        return _buildTutoriaCard(historico[index], esHistorico: true);
      },
    );
  }

  Map<String, dynamic> _estadoInfo(String estado) {
    switch (estado) {
      case 'pendiente':
        return {'label': '⏳ Pendiente', 'color': Colors.orange};
      case 'aceptada':
        return {'label': '✔ Aceptada', 'color': Colors.green};
      case 'aplazada':
        return {'label': '📅 Aplazada', 'color': Colors.blue};
      case 'rechazada':
        return {'label': '🔄 Nueva propuesta solicitada', 'color': Colors.deepOrange};
      case 'cancelada':
        return {'label': '✖ Cancelada', 'color': Colors.grey};
      case 'celebrada':
        return {'label': '✔ Firmada', 'color': Colors.green};
      default:
        return {'label': estado, 'color': Colors.grey};
    }
  }

  Widget _buildTutoriaCard(TutoriaModel item, {required bool esHistorico}) {
    final estadoInfo = _estadoInfo(item.estado);
    final Color statusColor = estadoInfo['color'];
    final String statusLabel = estadoInfo['label'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
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
                  child: Text(
                    item.alumnoNombre,
                    style: AppTextStyle.getOutfit600(
                        textSize: 15, textColor: AppColors.secondary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextStyle.getOutfit600(textSize: 11, textColor: statusColor),
                  ),
                ),
              ],
            ),
           // Pestaña: Mis Tutorías / Registro Histórico (Padre)
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Profesor/a: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: item.profesorNombre, style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Solicitada por: ', style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
                TextSpan(text: item.tipoSolicitud == 'padre' ? 'Usted' : 'Profesor/a', style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: esHistorico && item.estado == 'celebrada' ? 'Fecha celebrada: ' : 'Fecha propuesta: ',
                  style: AppTextStyle.getOutfit600(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8)),
                ),
                TextSpan(
                  text: esHistorico && item.estado == 'celebrada'
                      ? _formatFecha(item.fechaAceptada ?? item.fechaPropuesta)
                      : _formatFecha(item.fechaPropuesta),
                  style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6)),
                ),
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
            if (esHistorico && item.estado == 'celebrada' && item.asistentes.isNotEmpty) ...[
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
            if (esHistorico && item.estado == 'celebrada' && item.asuntosTratados.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Asuntos:',
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(item.asuntosTratados,
                  style: AppTextStyle.getOutfit400(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
            ],
            if (esHistorico && item.estado == 'celebrada' && item.observaciones.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Observaciones:',
                  style: AppTextStyle.getOutfit600(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.8))),
              const SizedBox(height: 2),
              Text(item.observaciones,
                  style: AppTextStyle.getOutfit400(
                      textSize: 12, textColor: AppColors.secondary.withValues(alpha: 0.6))),
            ],
            if (!esHistorico) _buildAcciones(item),
            if (esHistorico && item.estado == 'celebrada') ...[
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
            ],
            const Divider(height: 20),
            TutoriaHistorialWidget(
              tutoriaId: item.id,
              currentUserRol: 'padre',
            ),
          ],
        ),
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

  Widget _buildAcciones(TutoriaModel item) {
    final List<Widget> botones = [];

    if (item.estado == 'pendiente' && item.tipoSolicitud == 'profesor') {
      botones.add(_actionButton('Aceptar', Colors.green, () => _aceptar(item)));
      botones.add(_actionButton('Proponer nueva fecha', AppColors.primary, () => _proponerNuevaFecha(item)));
    } else if (item.estado == 'pendiente' && item.tipoSolicitud == 'padre') {
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelar(item)));
    } else if (item.estado == 'aplazada') {
      botones.add(_actionButton('Aceptar', Colors.green, () => _aceptar(item)));
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelar(item)));
    } else if (item.estado == 'rechazada' && item.tipoSolicitud == 'profesor') {
      botones.add(_actionButton('Cancelar', Colors.red, () => _cancelar(item)));
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

  String _formatFecha(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final parts = dateStr.split(' ');
      final dateParts = parts[0].split('-');
      final horaParts = parts.length > 1 ? parts[1].substring(0, 5) : '';
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}${horaParts.isNotEmpty ? ' $horaParts' : ''}';
    } catch (_) {
      return dateStr;
    }
  }
}
