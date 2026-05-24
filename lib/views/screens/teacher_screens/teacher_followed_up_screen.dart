import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/followed_up_model.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_academic_results_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_classroom_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_colors.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_select_students_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_add_classroom_event_screen.dart';

/// Pantalla 1 — Selección de clase y alumno para el Seguimiento.
/// Desde aquí se accede al Seguimiento Académico o al Actitudinal.
class TeacherFollowedUpScreen extends StatefulWidget {
  const TeacherFollowedUpScreen({super.key});

  @override
  State<TeacherFollowedUpScreen> createState() =>
      _TeacherFollowedUpScreenState();
}

class _TeacherFollowedUpScreenState extends State<TeacherFollowedUpScreen> {
  StudentParentTeacherController? controller;

  // false = modo Consultar | true = modo Registrar incidencia
  bool _modoRegistrar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);

      // Si el módulo Actitudinal está desactivado, forzar modo Consultar
      if (!(controller?.isClassroomEventsEnabled ?? false)) {
        _modoRegistrar = false;
      }

      if (controller?.listOfClassAssignToTeacher.isNotEmpty ?? false) {
        controller?.setCurrentSelectedClass(
            teacherClass: controller?.listOfClassAssignToTeacher[0]);
        controller?.getListOfStudents(
            classId: controller?.listOfClassAssignToTeacher[0].cid ?? "",
            roleType: RoleType.teacher);
      } else {
        controller?.getListOfClassesAssignToTeacher(showLoader: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (ctx, res) {
        controller?.setListOfStudentFollowedUp(listOfStudentFollowedUp: []);
        controller?.setListOfStudents(listOfStudents: []);
        controller?.setSelectedStudentForFollowUp(studentItem: null);
        controller?.setIsLoading(isLoading: false);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            controller?.setListOfStudentFollowedUp(listOfStudentFollowedUp: []);
            controller?.setListOfStudents(listOfStudents: []);
            controller?.setSelectedStudentForFollowUp(studentItem: null);
            controller?.setIsLoading(isLoading: false);
            Get.back();
          },
          title: Text(
            'subMenuDrawer13'.tr,
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.white),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Cuerpo con los selectores (fondo claro)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Selector de modo: Consultar / Registrar ---
                      // Solo visible si el módulo Actitudinal está activado
                      Consumer<StudentParentTeacherController>(
                        builder: (context, controller, child) {
                          if (!controller.isClassroomEventsEnabled) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              _buildModeSelector(),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                      // --- Clase ---
                      Text(
                        'classes'.tr,
                        style: AppTextStyle.getOutfit500(
                            textSize: 16, textColor: AppColors.secondary),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 55,
                        child: TeacherClassListDropdown(
                          fromWhereStudentListCalled: false,
                          fromWhichScreen: 1,
                          height: 55,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // --- Alumno (solo en modo Consultar) ---
                      if (!_modoRegistrar) ...[
                      Text(
                        'student'.tr,
                        style: AppTextStyle.getOutfit500(
                            textSize: 16, textColor: AppColors.secondary),
                      ),
                      const SizedBox(height: 8),
                      Consumer<StudentParentTeacherController>(
                        builder: (context, controller, child) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primary.withValues(alpha: 0.05),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: controller.listOfStudents.isNotEmpty
                                ? DropdownButton<StudentItem>(
                                    underline: const SizedBox.shrink(),
                                    isExpanded: true,
                                    value:
                                        controller.selectedStudentForFollowedUp,
                                    hint: Text(
                                      'student'.tr,
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          textColor: AppColors.secondary),
                                    ),
                                    items: controller.listOfStudents.map((e) {
                                      final apellidos = (e.sLname ?? '').trim();
                                      final nombre = (e.sFname ?? '').trim();
                                      final nombreCompleto = apellidos.isEmpty
                                          ? nombre
                                          : (nombre.isEmpty
                                              ? apellidos
                                              : '$apellidos, $nombre');
                                      return DropdownMenuItem<StudentItem>(
                                        value: e,
                                        child: Text(
                                          nombreCompleto,
                                          style: AppTextStyle.getOutfit400(
                                              textSize: 16,
                                              textColor: AppColors.secondary),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (StudentItem? studentItem) {
                                      controller.setSelectedStudentForFollowUp(
                                          studentItem: studentItem);
                                    },
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'student'.tr,
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          textColor: AppColors.secondary
                                              .withValues(alpha: 0.5)),
                                    ),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // --- Botones Académico / Actitudinal ---
                      Consumer<StudentParentTeacherController>(
                        builder: (context, controller, child) {
                          bool isStudentSelected =
                              controller.selectedStudentForFollowedUp != null;

                          void showSelectStudentToast() {
                            AppConstants.showCustomToast(
                                status: false,
                                message: 'Por favor seleccione estudiante');
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Botón Académico
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.32,
                                child: CustomButtonWidget(
                                  buttonTitle: 'Académico',
                                  onPressed: isStudentSelected
                                      ? () {
                                          final student = controller
                                              .selectedStudentForFollowedUp;
                                          controller.getListOfFollowedUp(
                                            studentId: student?.wpUsrId ?? "",
                                            classId: controller
                                                    .currentSelectedClass
                                                    ?.cid ??
                                                "",
                                          );
                                          Get.to(() =>
                                              TeacherAcademicResultsScreen(
                                                studentName:
                                                    "${student?.sLname ?? ''} ${student?.sFname ?? ''}"
                                                        .trim(),
                                              ));
                                        }
                                      : showSelectStudentToast,
                                ),
                              ),
                              // Botón Actitudinal (solo si el switch está activado)
                              if (controller.isClassroomEventsEnabled) ...[
                                const SizedBox(width: 12),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.32,
                                  child: CustomButtonWidget(
                                    buttonTitle: 'Actitudinal',
                                    onPressed: isStudentSelected
                                        ? () {
                                            final student = controller
                                                .selectedStudentForFollowedUp;
                                            Get.to(() =>
                                                TeacherClassroomEventsScreen(
                                                  studentId:
                                                      student?.wpUsrId ?? "",
                                                  studentName:
                                                      "${student?.sLname ?? ''} ${student?.sFname ?? ''}"
                                                          .trim(),
                                                  classId: controller
                                                          .currentSelectedClass
                                                          ?.cid ??
                                                      "",
                                                  className: controller
                                                          .currentSelectedClass
                                                          ?.cName ??
                                                      "",
                                                  canRegister: true,
                                                ));
                                          }
                                        : showSelectStudentToast,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      ], // fin del modo Consultar
                      // Botón Registrar incidencia (solo en modo Registrar)
                      if (_modoRegistrar)
                      Consumer<StudentParentTeacherController>(
                        builder: (context, controller, child) {
                          if (!controller.isClassroomEventsEnabled) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButtonWidget(
                                  buttonTitle: 'Registrar incidencia',
                                  onPressed: () async {
                                    if (controller.listOfStudents.isEmpty) {
                                      AppConstants.showCustomToast(
                                          status: false,
                                          message:
                                              'No hay alumnos en esta clase');
                                      return;
                                    }
                                    final result = await Get.to(() =>
                                        TeacherSelectStudentsScreen(
                                          students:
                                              controller.listOfStudents,
                                          classId: controller
                                                  .currentSelectedClass
                                                  ?.cid ??
                                              "",
                                          className: controller
                                                  .currentSelectedClass
                                                  ?.cName ??
                                              "",
                                        ));
                                    // result = lista de alumnos seleccionados
                                    if (result is List<StudentItem> &&
                                        result.isNotEmpty) {
                                      final ids = result
                                          .map((s) => s.wpUsrId ?? '')
                                          .where((id) => id.isNotEmpty)
                                          .toList();
                                      final nombres = result.map((s) {
                                        final apellidos =
                                            (s.sLname ?? '').trim();
                                        final nombre = (s.sFname ?? '').trim();
                                        if (apellidos.isEmpty) return nombre;
                                        if (nombre.isEmpty) return apellidos;
                                        return '$apellidos, $nombre';
                                      }).toList();
                                      final nombreUnico = result.length == 1
                                          ? nombres.first
                                          : '';
                                      Get.to(() =>
                                          TeacherAddClassroomEventScreen(
                                            studentIds: ids,
                                            studentName: nombreUnico,
                                            studentNames: nombres,
                                            classId: controller
                                                    .currentSelectedClass
                                                    ?.cid ??
                                                "",
                                            className: controller
                                                    .currentSelectedClass
                                                    ?.cName ??
                                                "",
                                          ));
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
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

  /// Selector de dos botones alternos: Consultar / Registrar incidencia
  Widget _buildModeSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _modeButton(label: 'Consultar', isActive: !_modoRegistrar, onTap: () {
            setState(() => _modoRegistrar = false);
          }),
          _modeButton(
              label: 'Registrar incidencia',
              isActive: _modoRegistrar,
              onTap: () {
            setState(() => _modoRegistrar = true);
          }),
        ],
      ),
    );
  }

  Widget _modeButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.getOutfit500(
              textSize: 14,
              textColor: isActive ? AppColors.white : AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

class FollowedUpWidget extends StatelessWidget {
  final FollowedUpItemDetail? followedUpItemDetail;

  const FollowedUpWidget({super.key, required this.followedUpItemDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColors.color10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary),
            padding: const EdgeInsets.all(10),
            child: Text(
              (followedUpItemDetail?.date != null &&
                      followedUpItemDetail?.date?.isNotEmpty == true &&
                      followedUpItemDetail?.date != "-")
                  ? DateFormat("dd-MM-yyyy")
                      .format(DateTime.parse(followedUpItemDetail!.date!))
                  : "-",
              style: AppTextStyle.getOutfit300(
                  textSize: 14, textColor: AppColors.white),
            ),
          ),
          const SizedBox(height: 20),
          CustomFollowedUpRow(
              label: "subject".tr,
              value: followedUpItemDetail?.subjectName ?? "-"),
          const SizedBox(height: 10),
          CustomDottedLineWidget(),
          const SizedBox(height: 10),
          CustomFollowedUpRow(
              label: "examname".tr,
              value: followedUpItemDetail?.examName ?? "-"),
          const SizedBox(height: 10),
          CustomDottedLineWidget(),
          const SizedBox(height: 10),
          CustomFollowedUpRow(
              label: "grade".tr, value: followedUpItemDetail?.mark ?? "-"),
          // Observaciones: solo si tiene contenido
          if ((followedUpItemDetail?.remarks ?? "").trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            CustomDottedLineWidget(),
            const SizedBox(height: 10),
            CustomFollowedUpRow(
                label: "obser".tr,
                value: followedUpItemDetail?.remarks ?? "-"),
          ],
        ],
      ),
    );
  }
}

class CustomFollowedUpRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomFollowedUpRow(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getOutfit400(
              textSize: 16,
              textColor: AppColors.secondary.withValues(alpha: 0.5)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value.isEmpty ? "-" : value,
            textAlign: TextAlign.end,
            style: AppTextStyle.getOutfit500(
                textSize: 16, textColor: AppColors.secondary),
          ),
        ),
      ],
    );
  }
}