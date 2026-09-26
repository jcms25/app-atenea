import 'package:colegia_atenea/models/servicio_contratado_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/solicitud_form_screen.dart';
import 'package:colegia_atenea/views/screens/solicitud_detalle_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolicitudesScreen extends StatefulWidget {
  // 0 = Solicitar, 1 = Mis solicitudes (el deep link de notificaciones abre la 1)
  final int initialTabIndex;

  const SolicitudesScreen({super.key, this.initialTabIndex = 0});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<FormularioSolicitudModel> formularios = [];
  List<SolicitudHistorialModel> misSolicitudes = [];
  bool isLoadingFormularios = true;
  bool isLoadingHistorial = true;

  // Orden de pestañas: 0 = Solicitar, 1 = Mis solicitudes
  static const int _kTabMisSolicitudes = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadFormularios(), _loadHistorial()]);
  }

  Future<void> _loadFormularios() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';

      final response = await ApiClass().getSolicitudesFormularios(
        token: token,
        cookie: cookie,
      );

      if (!mounted) return;
      if (response['status'] == true) {
        final List data = response['data']?['formularios'] ?? [];
        setState(() {
          formularios = data
              .map((e) => FormularioSolicitudModel.fromJson(e))
              .toList();
          isLoadingFormularios = false;
        });
      } else {
        setState(() => isLoadingFormularios = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingFormularios = false);
    }
  }

  Future<void> _loadHistorial() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getSolicitudesMisSolicitudes(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (!mounted) return;
      if (response['status'] == true) {
        final List data = response['data'] ?? [];
        setState(() {
          misSolicitudes = data
              .map((e) => SolicitudHistorialModel.fromJson(e))
              .toList();
          isLoadingHistorial = false;
        });
      } else {
        setState(() => isLoadingHistorial = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingHistorial = false);
    }
  }

  IconData _iconForSlug(String slug) {
    switch (slug) {
      case 'comedor':
        return Icons.restaurant_outlined;
      case 'aula_matinal':
        return Icons.wb_sunny_outlined;
      case 'gabinete':
        return Icons.psychology_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }

  Color _colorForEstado(String estado) {
    switch (estado) {
      case 'activa':
        return Colors.green;
      case 'enviada':
        return Colors.orange;
      case 'cancelada':
        return Colors.grey;
      default:
        return AppColors.secondary;
    }
  }

  String _labelForEstado(String estado) {
    switch (estado) {
      case 'activa':
        return 'Activa';
      case 'enviada':
        return 'Enviada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return estado;
    }
  }

  String _labelForTipo(String? tipo) {
    switch (tipo) {
      case 'mensual':
        return 'Mensual';
      case 'dias_sueltos':
        return 'Días sueltos';
      default:
        return '';
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final parts = dateStr.split(' ');
      final dateParts = parts[0].split('-');
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
    } catch (_) {
      return dateStr;
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
                        'Solicitudes',
                        style: AppTextStyle.getOutfit600(
                            textSize: 22, textColor: AppColors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.white,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
                  labelStyle: AppTextStyle.getOutfit600(
                      textSize: 14, textColor: AppColors.white),
                  unselectedLabelStyle: AppTextStyle.getOutfit400(
                      textSize: 14, textColor: AppColors.white),
                  tabs: const [
                    Tab(text: 'Solicitar'),
                    Tab(text: 'Mis solicitudes'),
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
                _buildMisSolicitudesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitarTab() {
    return RefreshIndicator(
      onRefresh: _loadFormularios,
      color: AppColors.primary,
      child: isLoadingFormularios
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: LoadingLayout()),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
              itemCount: formularios.length,
              itemBuilder: (context, index) =>
                  _buildFormularioCard(formularios[index]),
            ),
    );
  }

  Widget _buildMisSolicitudesTab() {
    Widget contenido;
    if (isLoadingHistorial) {
      contenido = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: LoadingLayout()),
          ),
        ],
      );
    } else if (misSolicitudes.isEmpty) {
      contenido = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No has realizado ninguna solicitud',
                style: AppTextStyle.getOutfit400(
                    textSize: 15,
                    textColor: AppColors.secondary.withValues(alpha: 0.6)),
              ),
            ),
          ),
        ],
      );
    } else {
      contenido = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
        itemCount: misSolicitudes.length,
        itemBuilder: (context, index) =>
            _buildHistorialCard(misSolicitudes[index]),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistorial,
      color: AppColors.primary,
      child: contenido,
    );
  }

  Widget _buildFormularioCard(FormularioSolicitudModel formulario) {
    return GestureDetector(
      onTap: () async {
          final enviado = await Get.to(() =>
            SolicitudFormScreen(
              formulario: formulario,
              solicitudesExistentes: misSolicitudes,
            ));
        if (enviado == true) {
          setState(() => isLoadingHistorial = true);
          _loadHistorial();
          _tabController.animateTo(_kTabMisSolicitudes);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2), width: 1),
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
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_iconForSlug(formulario.slug),
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formulario.nombre,
                      style: AppTextStyle.getOutfit600(
                          textSize: 15, textColor: AppColors.secondary),
                    ),
                    if (formulario.descripcion.isNotEmpty)
                      Text(
                        formulario.descripcion,
                        style: AppTextStyle.getOutfit400(
                            textSize: 12,
                            textColor:
                                AppColors.secondary.withValues(alpha: 0.6)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorialCard(SolicitudHistorialModel solicitud) {
    final Color estadoColor = _colorForEstado(solicitud.estado);
    final String estadoLabel = _labelForEstado(solicitud.estado);
    final String tipoLabel = _labelForTipo(solicitud.tipoServicio);

    return GestureDetector(
      onTap: () => Get.to(() => SolicitudDetalleScreen(solicitud: solicitud)),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: estadoColor.withValues(alpha: 0.3), width: 1),
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
        child: Row(
          children: [
            Icon(_iconForSlug(solicitud.formularioSlug),
                color: estadoColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solicitud.formularioNombre,
                    style: AppTextStyle.getOutfit600(
                        textSize: 15, textColor: AppColors.secondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${solicitud.alumnoNombre} (${solicitud.claseNombre})',
                    style: AppTextStyle.getOutfit400(
                        textSize: 13,
                        textColor:
                            AppColors.secondary.withValues(alpha: 0.7)),
                  ),
                  if (tipoLabel.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      tipoLabel,
                      style: AppTextStyle.getOutfit400(
                          textSize: 12,
                          textColor:
                              AppColors.secondary.withValues(alpha: 0.5)),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(solicitud.fechaSolicitud),
                    style: AppTextStyle.getOutfit400(
                        textSize: 12,
                        textColor:
                            AppColors.secondary.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: estadoColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                estadoLabel,
                style: AppTextStyle.getOutfit600(
                    textSize: 11, textColor: estadoColor),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
