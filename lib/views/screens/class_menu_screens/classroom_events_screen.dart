import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_classroom_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// Pantalla del histórico Actitudinal de un alumno — vista del padre.
/// Solo lectura: el padre consulta las incidencias de su hijo.
class ClassroomEventsScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const ClassroomEventsScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<ClassroomEventsScreen> createState() => _ClassroomEventsScreenState();
}

class _ClassroomEventsScreenState extends State<ClassroomEventsScreen> {
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
                          Text(
                            widget.studentName,
                            style: AppTextStyle.getOutfit600(
                                textSize: 18, textColor: AppColors.white),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _summaryChip('Total', '${summary?.total ?? 0}',
                                  AppColors.white),
                              const SizedBox(width: 10),
                              _summaryChip('Positivas',
                                  '${summary?.positive ?? 0}', AppColors.green),
                              const SizedBox(width: 10),
                              _summaryChip('Negativas',
                                  '${summary?.negative ?? 0}', AppColors.red),
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