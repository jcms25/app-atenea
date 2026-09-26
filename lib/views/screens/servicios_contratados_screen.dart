import 'package:colegia_atenea/models/servicio_contratado_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';

class ServiciosContratadosScreen extends StatefulWidget {
  const ServiciosContratadosScreen({super.key});

  @override
  State<ServiciosContratadosScreen> createState() =>
      _ServiciosContratadosScreenState();
}

class _ServiciosContratadosScreenState
    extends State<ServiciosContratadosScreen> {
  ServiciosContratadosResponseModel? misServicios;
  bool isLoadingServicios = true;
  final Set<String> _expandedServicios = {};

  @override
  void initState() {
    super.initState();
    _loadMisServicios();
  }

  Future<void> _loadMisServicios() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final parentId = userdata?.parentWpUsrId ?? '';

      final response = await ApiClass().getServiciosContratadosMisServicios(
        token: token,
        cookie: cookie,
        parentWpUsrId: parentId,
      );

      if (response['status'] == true) {
        setState(() {
          misServicios = ServiciosContratadosResponseModel.fromJson(
              response['data'] ?? {});
          isLoadingServicios = false;
        });
      } else {
        setState(() => isLoadingServicios = false);
      }
    } catch (e) {
      setState(() => isLoadingServicios = false);
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
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 18),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios,
                      color: AppColors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Text(
                  'Servicios contratados',
                  style: AppTextStyle.getOutfit600(
                      textSize: 22, textColor: AppColors.white),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoadingServicios) {
      return const Center(child: LoadingLayout());
    }
    if (misServicios == null || misServicios!.servicios.isEmpty) {
      return Center(
        child: Text(
          'No hay servicios contratados',
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadMisServicios,
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Curso ${misServicios!.academicYear}',
              style: AppTextStyle.getOutfit400(
                  textSize: 13,
                  textColor: AppColors.secondary.withValues(alpha: 0.6)),
            ),
          ),
          ...misServicios!.servicios.map(_buildServicioCard),
        ],
      ),
    );
  }

  Widget _buildServicioCard(ServicioContratadoModel servicio) {
    final bool contratado = servicio.contratado;
    final bool expanded = _expandedServicios.contains(servicio.campo);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: contratado
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.secondary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: contratado
            ? [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Opacity(
        opacity: contratado ? 1.0 : 0.45,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: contratado
                    ? () {
                        setState(() {
                          if (expanded) {
                            _expandedServicios.remove(servicio.campo);
                          } else {
                            _expandedServicios.add(servicio.campo);
                          }
                        });
                      }
                    : null,
                child: Row(
                  children: [
                    Icon(
                      contratado
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: contratado
                          ? Colors.green
                          : AppColors.secondary.withValues(alpha: 0.4),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        servicio.nombre,
                        style: AppTextStyle.getOutfit600(
                            textSize: 15, textColor: AppColors.secondary),
                      ),
                    ),
                    if (contratado)
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.secondary.withValues(alpha: 0.6),
                        size: 22,
                      ),
                  ],
                ),
              ),
              if (contratado && expanded) ...[
                const SizedBox(height: 10),
                ...servicio.alumnos.map((alumno) => Padding(
                      padding: const EdgeInsets.only(left: 32, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${alumno.alumnoNombre} (${alumno.claseNombre})',
                                  style: AppTextStyle.getOutfit500(
                                      textSize: 13,
                                      textColor: AppColors.secondary),
                                ),
                              ),
                              if (alumno.origen != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: (alumno.origen == 'app'
                                            ? AppColors.primary
                                            : AppColors.secondary)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    alumno.origen == 'app'
                                        ? 'Vía app'
                                        : 'Vía Secretaría',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 10,
                                        textColor: alumno.origen == 'app'
                                            ? AppColors.primary
                                            : AppColors.secondary
                                                .withValues(alpha: 0.7)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          ...alumno.detalle.map((d) => Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  '- $d',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 12,
                                      textColor: AppColors.secondary
                                          .withValues(alpha: 0.6)),
                                ),
                              )),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}