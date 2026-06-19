import 'package:colegia_atenea/models/autorizacion_model.dart';
import 'package:colegia_atenea/services/api.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/autorizacion_tutor_enviar_screen.dart';
import 'package:flutter/material.dart';

class AutorizacionesTutorScreen extends StatefulWidget {
  const AutorizacionesTutorScreen({super.key});

  @override
  State<AutorizacionesTutorScreen> createState() =>
      _AutorizacionesTutorScreenState();
}

class _AutorizacionesTutorScreenState extends State<AutorizacionesTutorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoadingRegistro = true;
  AutorizacionTutorRegistroModel? registro;

  bool isLoadingClase = true;
  List<AutorizacionTutorClaseModel> clasesTutoria = [];
  AutorizacionTutorClaseModel? claseSeleccionada;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRegistro();
    _loadClase();
  }

  Future<void> _loadClase() async {
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final teacherId = userdata?.wpUsrId ?? '';

      final response = await Api.httpRequest(
        requestType: RequestType.get,
        endPoint: "${Api.autorizacionesTutorClaseEndPoint}?teacher_wp_usr_id=$teacherId",
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': 'Basic $token',
          'Cookie': cookie,
        },
      );

      if (response['status'] == true) {
        final List dataList = response['data'] ?? [];
        setState(() {
          clasesTutoria = AutorizacionTutorClaseModel.listFromJson(dataList);
          claseSeleccionada = clasesTutoria.isNotEmpty ? clasesTutoria.first : null;
          isLoadingClase = false;
        });
      } else {
        setState(() => isLoadingClase = false);
      }
    } catch (e) {
      setState(() => isLoadingClase = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  AutorizacionTutorClaseModel? claseRegistroSeleccionada;

  Future<void> _loadRegistro({AutorizacionTutorClaseModel? clase}) async {
    setState(() => isLoadingRegistro = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final cookie = userdata?.cookies ?? '';
      final teacherId = userdata?.wpUsrId ?? '';

      final claseActual = clase ?? claseRegistroSeleccionada;
      String endPoint = "${Api.autorizacionesTutorRegistroEndPoint}?teacher_wp_usr_id=$teacherId";
      if (claseActual != null) {
        endPoint += "&cid=${claseActual.cid}";
      }

      final response = await Api.httpRequest(
        requestType: RequestType.get,
        endPoint: endPoint,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': 'Basic $token',
          'Cookie': cookie,
        },
      );

      if (response['status'] == true) {
        setState(() {
          registro = AutorizacionTutorRegistroModel.fromJson(response['data']);
          isLoadingRegistro = false;
        });
      } else {
        setState(() => isLoadingRegistro = false);
      }
    } catch (e) {
      setState(() => isLoadingRegistro = false);
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
                      Expanded(
                        child: Text(
                          'Autorizaciones${registro != null ? " · ${registro!.cName}" : ""}',
                          style: AppTextStyle.getOutfit600(
                              textSize: 18, textColor: AppColors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                      textSize: 15, textColor: AppColors.white),
                  unselectedLabelStyle: AppTextStyle.getOutfit400(
                      textSize: 15, textColor: AppColors.white),
                  tabs: const [
                    Tab(text: 'Enviar'),
                    Tab(text: 'Registro'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEnviarTab(),
                _buildRegistroTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnviarTab() {
    if (isLoadingClase) {
      return const Center(child: LoadingLayout());
    }
    if (clasesTutoria.isEmpty) {
      return Center(
        child: Text(
          'No se pudo cargar la información de la clase',
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.send_outlined,
              size: 56, color: AppColors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'Envía una autorización a tu grupo de tutoría',
            textAlign: TextAlign.center,
            style: AppTextStyle.getOutfit600(
                textSize: 16, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 16),
          // Selector de clase si hay más de una
          if (clasesTutoria.length > 1) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AutorizacionTutorClaseModel>(
                  isExpanded: true,
                  value: claseSeleccionada,
                  items: clasesTutoria
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c.cName,
                              style: AppTextStyle.getOutfit400(
                                  textSize: 14,
                                  textColor: AppColors.secondary),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => claseSeleccionada = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (claseSeleccionada != null)
            Text(
              '${claseSeleccionada!.cName} · ${claseSeleccionada!.alumnos.length} alumnos',
              style: AppTextStyle.getOutfit400(
                  textSize: 13,
                  textColor: AppColors.secondary.withValues(alpha: 0.6)),
            ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: claseSeleccionada == null
                ? null
                : () async {
                    final enviado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AutorizacionTutorEnviarScreen(
                            claseTutoria: claseSeleccionada!),
                      ),
                    );
                    if (enviado == true) {
                      setState(() => isLoadingRegistro = true);
                      _loadRegistro();
                    }
                  },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: claseSeleccionada == null
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Nueva autorización',
                style: AppTextStyle.getOutfit600(
                    textSize: 15, textColor: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistroTab() {
    return Column(
      children: [
        // Selector de clase si hay más de una
        if (!isLoadingClase && clasesTutoria.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AutorizacionTutorClaseModel>(
                  isExpanded: true,
                  value: claseRegistroSeleccionada,
                  hint: Text('Selecciona un grupo...',
                      style: AppTextStyle.getOutfit400(
                          textSize: 14,
                          textColor:
                              AppColors.secondary.withValues(alpha: 0.5))),
                  items: clasesTutoria
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.cName,
                                style: AppTextStyle.getOutfit400(
                                    textSize: 14,
                                    textColor: AppColors.secondary)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => claseRegistroSeleccionada = value);
                    _loadRegistro(clase: value);
                  },
                ),
              ),
            ),
          ),
        Expanded(
          child: isLoadingRegistro
              ? const Center(child: LoadingLayout())
              : (registro == null || registro!.autorizaciones.isEmpty)
                  ? Center(
                      child: Text(
                        'No hay autorizaciones enviadas a esta clase',
                        style: AppTextStyle.getOutfit400(
                            textSize: 16, textColor: AppColors.secondary),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _loadRegistro(),
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: registro!.autorizaciones.length,
                        itemBuilder: (context, index) {
                          final item = registro!.autorizaciones[index];
                          return _buildRegistroCard(item);
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildRegistroCard(AutorizacionRegistroItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        title: Text(
          item.titulo,
          style: AppTextStyle.getOutfit600(
              textSize: 15, textColor: AppColors.secondary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              _buildResumenChip(
                  '${item.resumenAutorizado}', Colors.green, Icons.check_circle),
              const SizedBox(width: 6),
              _buildResumenChip(
                  '${item.resumenNoAutorizado}', Colors.red, Icons.cancel),
              const SizedBox(width: 6),
              _buildResumenChip(
                  '${item.resumenPendiente}', Colors.orange, Icons.hourglass_empty),
              const Spacer(),
              if (item.origen == 'admin')
                Text(
                  'Equipo directivo',
                  style: AppTextStyle.getOutfit400(
                      textSize: 11,
                      textColor: AppColors.secondary.withValues(alpha: 0.5)),
                ),
            ],
          ),
        ),
        children: item.alumnos.map((alumno) => _buildAlumnoRow(alumno)).toList(),
      ),
    );
  }

  Widget _buildResumenChip(String count, Color color, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 2),
        Text(
          count,
          style: AppTextStyle.getOutfit600(textSize: 12, textColor: color),
        ),
      ],
    );
  }

  Widget _buildAlumnoRow(AutorizacionRegistroAlumnoModel alumno) {
    final Color color;
    final IconData icon;
    switch (alumno.respuesta) {
      case 'autorizado':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'no_autorizado':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.orange;
        icon = Icons.hourglass_empty;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              alumno.nombreCompleto,
              style: AppTextStyle.getOutfit400(
                  textSize: 13, textColor: AppColors.secondary),
            ),
          ),
          if (alumno.firmaNombre.isNotEmpty)
            Text(
              alumno.firmaNombre,
              style: AppTextStyle.getOutfit400(
                  textSize: 11,
                  textColor: AppColors.secondary.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }
}