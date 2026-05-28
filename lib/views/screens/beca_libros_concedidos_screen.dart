import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/beca_libros_alumno_model.dart';
import 'package:colegia_atenea/models/beca_resolucion_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LibrosConcedidosScreen extends StatefulWidget {
  const LibrosConcedidosScreen({super.key});

  @override
  State<LibrosConcedidosScreen> createState() => _LibrosConcedidosScreenState();
}

class _LibrosConcedidosScreenState extends State<LibrosConcedidosScreen> {
  StudentParentTeacherController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      _cargarDatos();
    });
  }

  // Primero resuelve qué hijos tienen beca concedida, luego sus libros.
  Future<void> _cargarDatos() async {
    await controller?.fetchBecaResolucion();
    final resolucion = controller?.becaResolucion;
    final List<int> idsConcedidos = (resolucion?.data ?? [])
        .where((b) => b.concedida)
        .map((b) => b.alumnoId)
        .toList();
    await controller?.fetchBecaLibrosAlumnos(studentIds: idsConcedidos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: () => Get.back(),
        title: Text(
          'Libros concedidos',
          style: AppTextStyle.getOutfit500(
              textSize: 20, textColor: AppColors.white),
        ),
      ),
      body: Stack(
        children: [
          Consumer<StudentParentTeacherController>(
            builder: (context, controller, child) {
              if (controller.isBecaResolucionLoading ||
                  controller.isBecaLibrosLoading) {
                return const SizedBox.shrink();
              }

              final BecaResolucionResponse? resolucion =
                  controller.becaResolucion;
              // Solo hijos concedidos, ordenados por classCode DESC.
              final List<BecaResolucion> concedidos = (resolucion?.data ?? [])
                  .where((b) => b.concedida)
                  .toList()
                ..sort((a, b) => b.classCode.compareTo(a.classCode));

              if (concedidos.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No hay libros concedidos disponibles.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getOutfit400(
                          textSize: 16, textColor: AppColors.secondary),
                    ),
                  ),
                );
              }

              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((resolucion?.anioAcademico ?? '').isNotEmpty) ...[
                          Text(
                            'Año Académico ${resolucion!.anioAcademico}',
                            style: AppTextStyle.getOutfit500(
                                textSize: 14, textColor: AppColors.secondary),
                          ),
                          const SizedBox(height: 16),
                        ],
                        ...concedidos.map((hijo) => _buildBloqueHijo(
                            hijo, controller.becaLibrosPorAlumno)),
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
                visible: controller.isBecaResolucionLoading ||
                    controller.isBecaLibrosLoading,
                child: LoadingLayout(),
              );
            },
          ),
        ],
      ),
    );
  }

  // Bloque de un hijo: su nombre + la lista de sus libros concedidos.
  Widget _buildBloqueHijo(
      BecaResolucion hijo, Map<int, List<BecaLibro>> librosPorAlumno) {
    final List<BecaLibro> libros = librosPorAlumno[hijo.alumnoId] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A73E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            hijo.className.isNotEmpty
                ? '${hijo.alumnoNombre} (${hijo.className})'
                : hijo.alumnoNombre,
            style: AppTextStyle.getOutfit600(
                textSize: 16, textColor: AppColors.white),
          ),
        ),
        if (libros.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 4),
            child: Text(
              'Sin libros asociados.',
              style: AppTextStyle.getOutfit400(
                  textSize: 14, textColor: AppColors.secondary),
            ),
          )
        else
          ...libros.map((libro) => _buildLibroCard(libro)),
        const SizedBox(height: 16),
      ],
    );
  }

  // Tarjeta de un libro.
  Widget _buildLibroCard(BecaLibro libro) {
    final Color colorModo =
        libro.isUsado ? const Color(0xFFEA8600) : const Color(0xFF34A853);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            libro.asignatura,
            style: AppTextStyle.getOutfit600(
                textSize: 13, textColor: const Color(0xFF1A73E8)),
          ),
          const SizedBox(height: 4),
          Text(
            libro.titulo,
            style: AppTextStyle.getOutfit500(
                textSize: 14, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'ISBN: ${libro.isbn}',
                style: AppTextStyle.getOutfit400(
                    textSize: 12, textColor: AppColors.secondary),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: colorModo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  libro.modo,
                  style: AppTextStyle.getOutfit500(
                      textSize: 11, textColor: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}