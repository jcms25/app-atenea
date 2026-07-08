import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_evaluation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TeacherEvaluationSelectorScreen extends StatefulWidget {
  const TeacherEvaluationSelectorScreen({super.key});

  @override
  State<TeacherEvaluationSelectorScreen> createState() =>
      _TeacherEvaluationSelectorScreenState();
}

class _TeacherEvaluationSelectorScreenState
    extends State<TeacherEvaluationSelectorScreen> {
  StudentParentTeacherController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);
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
        controller?.setListOfStudents(listOfStudents: []);
        controller?.setSelectedStudentForFollowUp(studentItem: null);
        controller?.setIsLoading(isLoading: false);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            controller?.setListOfStudents(listOfStudents: []);
            controller?.setSelectedStudentForFollowUp(studentItem: null);
            controller?.setIsLoading(isLoading: false);
            Get.back();
          },
          title: Text(
            'subMenuDrawer30'.tr,
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.white),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Selector de clase ---
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
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.05),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- Selector de alumno ---
                  Text(
                    'student'.tr,
                    style: AppTextStyle.getOutfit500(
                        textSize: 16, textColor: AppColors.secondary),
                  ),
                  const SizedBox(height: 8),
                  Consumer<StudentParentTeacherController>(
                    builder: (context, ctrl, child) {
                      return Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary.withValues(alpha: 0.05),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        child: ctrl.listOfStudents.isNotEmpty
                            ? DropdownButton<StudentItem>(
                                underline: const SizedBox.shrink(),
                                isExpanded: true,
                                value: ctrl.selectedStudentForFollowedUp,
                                hint: Text(
                                  'student'.tr,
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 16,
                                      textColor: AppColors.secondary),
                                ),
                                items: ctrl.listOfStudents.map((e) {
                                  final apellidos =
                                      (e.sLname ?? '').trim();
                                  final nombre = (e.sFname ?? '').trim();
                                  final nombreCompleto =
                                      apellidos.isEmpty
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
                                  ctrl.setSelectedStudentForFollowUp(
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
                  const SizedBox(height: 24),
                  // --- Botón Ver Boletín ---
                  Consumer<StudentParentTeacherController>(
                    builder: (context, ctrl, child) {
                      final isStudentSelected =
                          ctrl.selectedStudentForFollowedUp != null;
                      return SizedBox(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          buttonTitle: 'Ver Boletín de Evaluación',
                          onPressed: isStudentSelected
                              ? () {
                                  final student =
                                      ctrl.selectedStudentForFollowedUp;
                                  final classId =
                                      ctrl.currentSelectedClass?.cid ?? "";
                                  final apellidos =
                                      (student?.sLname ?? '').trim();
                                  final nombre =
                                      (student?.sFname ?? '').trim();
                                  final nombreCompleto =
                                      apellidos.isEmpty
                                          ? nombre
                                          : (nombre.isEmpty
                                              ? apellidos
                                              : '$apellidos, $nombre');
                                  Get.to(() => TeacherEvaluationScreen(
                                        studentName: nombreCompleto,
                                        cid: classId,
                                        wpId: student?.wpUsrId ?? "",
                                      ));
                                }
                              : () {
                                  AppConstants.showCustomToast(
                                      status: false,
                                      message:
                                          'Por favor seleccione un alumno');
                                },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Consumer<StudentParentTeacherController>(
              builder: (context, ctrl, child) {
                return Visibility(
                  visible: ctrl.isLoading,
                  child: LoadingLayout(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}