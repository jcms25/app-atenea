import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/classroom_event_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_add_classroom_event_screen.dart';

class TeacherClassroomEventsScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String classId;
  final String className;
    // true = el profesor puede registrar (muestra la ㊉); false = solo lectura (padre)
  final bool canRegister;

  const TeacherClassroomEventsScreen({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    this.canRegister = false,
  });

  @override
  State<TeacherClassroomEventsScreen> createState() =>
      _TeacherClassroomEventsScreenState();
}

class _TeacherClassroomEventsScreenState
    extends State<TeacherClassroomEventsScreen> {
  StudentParentTeacherController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      controller?.getClassroomEvents(
        studentId: widget.studentId,
        showLoader: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (ctx, res) {
        controller?.setClassroomEvents(events: [], summary: null);
        controller?.setIsLoading(isLoading: false);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            controller?.setClassroomEvents(events: [], summary: null);
            controller?.setIsLoading(isLoading: false);
            Get.back();
          },
          title: Text(
            'Seguimiento Actitudinal',
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.white),
          ),
        ),
        body: Stack(
          children: [
            Consumer<StudentParentTeacherController>(
              builder: (context, controller, child) {
                final events = controller.listOfClassroomEvents;
                final summary = controller.classroomEventsSummary;

                return Column(
                  children: [
                    // Cabecera con resumen
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: AppColors.primary,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.studentName,
                                  style: AppTextStyle.getOutfit600(
                                      textSize: 18,
                                      textColor: AppColors.white),
                                ),
                              ),
                              // La ㊉ solo se muestra si el usuario puede registrar
                              if (widget.canRegister)
                                GestureDetector(
                                  onTap: () async {
                                    await Get.to(() =>
                                        TeacherAddClassroomEventScreen(
                                          studentIds: [widget.studentId],
                                          studentName: widget.studentName,
                                          classId: widget.classId,
                                          className: widget.className,
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.white,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                      size: 26,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _summaryChip(
                                  'Total', '${summary?.total ?? 0}',
                                  AppColors.white),
                              const SizedBox(width: 10),
                              _summaryChip(
                                  'Positivas', '${summary?.positive ?? 0}',
                                  AppColors.green),
                              const SizedBox(width: 10),
                              _summaryChip(
                                  'Negativas', '${summary?.negative ?? 0}',
                                  AppColors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Lista de incidencias
                    Expanded(
                      child: events.isEmpty && !controller.isLoading
                          ? Center(
                              child: Text(
                                'No hay incidencias registradas',
                                style: AppTextStyle.getOutfit500(
                                    textSize: 16,
                                    textColor: AppColors.secondary),
                              ),
                            )
                          : ScrollConfiguration(
                              behavior: const ScrollBehavior()
                                  .copyWith(overscroll: false),
                              child: ListView.separated(
                                padding: const EdgeInsets.all(10),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  return ClassroomEventCard(
                                      event: events[index]);
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
            Consumer<StudentParentTeacherController>(
              builder: (context, controller, child) {
                return Visibility(
                  visible: controller.isLoading,
                  child: LoadingLayout(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white.withValues(alpha: 0.12),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyle.getOutfit400(
                textSize: 13, textColor: AppColors.white),
          ),
          Text(
            value,
            style: AppTextStyle.getOutfit600(
                textSize: 14, textColor: valueColor),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta individual de una incidencia actitudinal
class ClassroomEventCard extends StatelessWidget {
  final ClassroomEvent event;

  const ClassroomEventCard({super.key, required this.event});

  String _formatDate(String raw) {
    if (raw.isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.color10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: badge fecha (izq) + semáforo (dcha)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  _formatDate(event.eventDate),
                  style: AppTextStyle.getOutfit300(
                      textSize: 14, textColor: AppColors.white),
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: event.isPositive ? AppColors.green : AppColors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Título: emoji + etiqueta
          Text(
            '${event.emoji}  ${event.label}',
            style: AppTextStyle.getOutfit600(
                textSize: 17, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 16),
          // Filas de detalle
          _detailRow('Asignatura', event.subjectName),
          const SizedBox(height: 10),
          CustomDottedLineWidget(),
          const SizedBox(height: 10),
          _detailRow('Profesor', event.teacherName),
          // Comentario: solo si tiene contenido
          if (event.comment.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            CustomDottedLineWidget(),
            const SizedBox(height: 10),
            _detailRow('Comentario', event.comment),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getOutfit400(
            textSize: 16,
            textColor: AppColors.secondary.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.end,
            style: AppTextStyle.getOutfit500(
                textSize: 16, textColor: AppColors.secondary),
          ),
        ),
      ],
    );
  }
}