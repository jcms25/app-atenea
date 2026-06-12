import 'package:colegia_atenea/models/autorizacion_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/autorizacion_detail_screen.dart';
import 'package:colegia_atenea/views/screens/autorizacion_historial_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutorizacionesScreen extends StatefulWidget {
  const AutorizacionesScreen({super.key});

  @override
  State<AutorizacionesScreen> createState() => _AutorizacionesScreenState();
}

class _AutorizacionesScreenState extends State<AutorizacionesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<AutorizacionModel> pendientes = [];
  List<AutorizacionHistorialModel> historial = [];
  bool isLoadingPendientes = true;
  bool isLoadingHistorial = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1 && isLoadingHistorial) {
        _loadHistorial();
      }
    });
    _loadPendientes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPendientes() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getAutorizacionesPendientes(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (response['status'] == true) {
        final List data = response['data'] ?? [];
        setState(() {
          pendientes = data.map((e) => AutorizacionModel.fromJson(e)).toList();
          isLoadingPendientes = false;
        });
      } else {
        setState(() => isLoadingPendientes = false);
      }
    } catch (e) {
      setState(() => isLoadingPendientes = false);
    }
  }

  Future<void> _loadHistorial() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getAutorizacionesHistorial(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (response['status'] == true) {
        final List data = response['data'] ?? [];
        setState(() {
          historial = data
              .map((e) => AutorizacionHistorialModel.fromJson(e))
              .toList();
          isLoadingHistorial = false;
        });
      } else {
        setState(() => isLoadingHistorial = false);
      }
    } catch (e) {
      setState(() => isLoadingHistorial = false);
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
                        'Autorizaciones',
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
                  labelStyle: AppTextStyle.getOutfit600(textSize: 15, textColor: AppColors.white),
                  unselectedLabelStyle: AppTextStyle.getOutfit400(textSize: 15, textColor: AppColors.white),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Pendientes'),
                          if (!isLoadingPendientes && pendientes.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${pendientes.length}',
                                style: AppTextStyle.getOutfit700(
                                    textSize: 11, textColor: AppColors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Tab(text: 'Historial'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendientesTab(),
                _buildHistorialTab(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64, color: AppColors.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              'No hay autorizaciones pendientes',
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: AppColors.secondary),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadPendientes,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: pendientes.length,
        itemBuilder: (context, index) {
          final item = pendientes[index];
          return _buildPendienteCard(item);
        },
      ),
    );
  }

  Widget _buildPendienteCard(AutorizacionModel item) {
    return GestureDetector(
      onTap: () async {
        final firmado = await Get.to(() =>
            AutorizacionDetailScreen(autorizacion: item));
        if (firmado == true) {
          setState(() => isLoadingPendientes = true);
          _loadPendientes();
          // Forzar recarga del historial en la próxima visita
          setState(() => isLoadingHistorial = true);
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
                child: const Icon(Icons.assignment_outlined,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.titulo,
                      style: AppTextStyle.getOutfit600(
                          textSize: 15, textColor: AppColors.secondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.alumnoNombre,
                      style: AppTextStyle.getOutfit400(
                          textSize: 13,
                          textColor: AppColors.secondary.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.fechaCreacion),
                      style: AppTextStyle.getOutfit400(
                          textSize: 12,
                          textColor: AppColors.secondary.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pendiente',
                  style: AppTextStyle.getOutfit600(
                      textSize: 11, textColor: Colors.orange.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorialTab() {
    if (isLoadingHistorial) {
      return const Center(child: LoadingLayout());
    }
    if (historial.isEmpty) {
      return Center(
        child: Text(
          'No hay autorizaciones en el historial',
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: historial.length,
      itemBuilder: (context, index) {
        final item = historial[index];
        return _buildHistorialCard(item);
      },
    );
  }

  Widget _buildHistorialCard(AutorizacionHistorialModel item) {
    final bool autorizado = item.respuesta == 'autorizado';
    final Color statusColor = autorizado ? Colors.green : Colors.red;
    final String statusText = autorizado ? 'Autorizado' : 'No autorizado';
    final IconData statusIcon =
        autorizado ? Icons.check_circle : Icons.cancel;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AutorizacionHistorialDetailScreen(autorizacion: item),
        ),
      ),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: statusColor.withValues(alpha: 0.3), width: 1),
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
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titulo,
                    style: AppTextStyle.getOutfit600(
                        textSize: 15, textColor: AppColors.secondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.alumnoNombre,
                    style: AppTextStyle.getOutfit400(
                        textSize: 13,
                        textColor:
                            AppColors.secondary.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.fechaRespuesta),
                    style: AppTextStyle.getOutfit400(
                        textSize: 12,
                        textColor:
                            AppColors.secondary.withValues(alpha: 0.5)),
                  ),
                  if (item.firmaNombre.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Firmado por: ${item.firmaNombre}',
                      style: AppTextStyle.getOutfit400(
                          textSize: 12,
                          textColor:
                              AppColors.secondary.withValues(alpha: 0.5)),
                    ),
                  ],
                  if (item.segundoFirmanteNombre.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '2º firmante: ${item.segundoFirmanteNombre}',
                      style: AppTextStyle.getOutfit400(
                          textSize: 12,
                          textColor:
                              AppColors.secondary.withValues(alpha: 0.5)),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: AppTextStyle.getOutfit600(
                    textSize: 11, textColor: statusColor),
              ),
            ),
          ],
        ),
      ),
    ),
    );
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
}