import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/beca_resolucion_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BecaResolucionScreen extends StatefulWidget {
  const BecaResolucionScreen({super.key});

  @override
  State<BecaResolucionScreen> createState() => _BecaResolucionScreenState();
}

class _BecaResolucionScreenState extends State<BecaResolucionScreen> {
  StudentParentTeacherController? controller;

  @override
  void initState() {
    super.initState();
    // Datos frescos en cada apertura de la pantalla.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      controller?.fetchBecaResolucion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: () => Get.back(),
        title: Text(
          'Resolución',
          style:
              AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.white),
        ),
      ),
      body: Stack(
        children: [
          Consumer<StudentParentTeacherController>(
            builder: (context, controller, child) {
              final BecaResolucionResponse? resolucion =
                  controller.becaResolucion;

              // Mientras carga, no pintamos contenido (el loader va encima).
              if (controller.isBecaResolucionLoading) {
                return const SizedBox.shrink();
              }

              // Sin datos o sin resoluciones.
              if (resolucion == null || resolucion.data.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No hay resolución de beca disponible.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getOutfit400(
                          textSize: 16, textColor: AppColors.secondary),
                    ),
                  ),
                );
              }

              // Ordenar por classCode DESC: Secundaria → Primaria → Infantil.
              final List<BecaResolucion> dataOrdenada =
                  List<BecaResolucion>.from(resolucion.data)
                    ..sort((a, b) => b.classCode.compareTo(a.classCode));

              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resolucion.anioAcademico.isNotEmpty) ...[
                          Text(
                            'Año Académico ${resolucion.anioAcademico}',
                            style: AppTextStyle.getOutfit500(
                                textSize: 14,
                                textColor: AppColors.secondary),
                          ),
                          const SizedBox(height: 16),
                        ],
                        ...dataOrdenada
                            .map((beca) => _buildBecaCard(beca)),                            
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context, controller, child) {
              return Visibility(
                visible: controller.isBecaResolucionLoading,
                child: LoadingLayout(),
              );
            },
          ),
        ],
      ),
    );
  }

  // Tarjeta de resolución de un hijo. Verde si concedida, roja si denegada.
  Widget _buildBecaCard(BecaResolucion beca) {
    final Color fondo =
        beca.concedida ? const Color(0xFFE6F4EA) : const Color(0xFFFCE8E6);
    final Color borde =
        beca.concedida ? const Color(0xFF34A853) : const Color(0xFFEA4335);
    final Color colorMotivo = borde;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: borde, width: 5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            beca.className.isNotEmpty
                ? '${beca.alumnoNombre} (${beca.className})'
                : beca.alumnoNombre,
            textAlign: TextAlign.center,
            style: AppTextStyle.getOutfit500(
                textSize: 15, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          Text(
            'El estado de su solicitud de beca es:',
            textAlign: TextAlign.center,
            style: AppTextStyle.getOutfit500(
                textSize: 14, textColor: const Color(0xFF1A73E8)),
          ),
          const SizedBox(height: 14),
          Text(
            beca.titulo,
            textAlign: TextAlign.center,
            style: AppTextStyle.getOutfit700(
                textSize: 20, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          Text(
            'Motivo: ${beca.texto}',
            textAlign: TextAlign.center,
            style:
                AppTextStyle.getOutfit400(textSize: 15, textColor: colorMotivo),
          ),
        ],
      ),
    );
  }
}