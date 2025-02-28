import 'package:colegia_atenea/models/exam_list_model.dart';
import 'package:colegia_atenea/models/subject_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../controllers/student_parent_teacher_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_textstyle.dart';
import '../custom_button_widget.dart';
import '../teacher_class_list_dropdown.dart';

class TeacherViewMarksBottomSheet extends StatelessWidget {
  const TeacherViewMarksBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'classes'.tr,
                      style: AppTextStyle.getOutfit500(
                          textSize: 18, textColor: AppColors.secondary),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 60,
                      child: TeacherClassListDropdown(
                        fromWhereStudentListCalled: false,
                        fromWhichScreen: 8,
                        // backgroundColor: AppColors.secondary.withOpacity(0.06),
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.06),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'subjects'.tr,
                      style: AppTextStyle.getOutfit500(
                          textSize: 18, textColor: AppColors.secondary),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<StudentParentTeacherController>(builder:
                        (context, studentParentTeacherController, child) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: AppColors.secondary.withOpacity(0.06)
                            color: AppColors.secondary.withValues(alpha: 0.06)
                        ),
                        padding: const EdgeInsets.only(left: 10),
                        child: studentParentTeacherController
                                .listOfSubject.isNotEmpty
                            ? DropdownButton<SubjectItem>(
                                underline: SizedBox.shrink(),
                                isExpanded: true,
                                value: studentParentTeacherController
                                    .viewMarkSubjectSelected,
                                hint: Text(
                                  "Seleccionar asignaturas",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 16,
                                      // textColor:
                                      //     AppColors.secondary.withOpacity(0.6)
                                    textColor: AppColors.secondary.withValues(alpha: 0.6)
                                  ),
                                ),
                                items: studentParentTeacherController
                                    .listOfSubject
                                    .map((e) {
                                  return DropdownMenuItem<SubjectItem>(
                                      value: e,
                                      child: Text(
                                        "${e.subName}",
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 18,
                                            textColor: AppColors.secondary),
                                      ));
                                }).toList(),
                                onChanged: (SubjectItem? subjectItem) {
                                  studentParentTeacherController
                                      .setViewMarkSubjectSelected(
                                          subjectItem: subjectItem);
                                })
                            : SizedBox.shrink(),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<StudentParentTeacherController>(
                      builder:
                          (context, studentParentTeacherController, child) {
                        return Visibility(
                            visible: studentParentTeacherController
                                    .viewMarkSubjectSelected !=
                                null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'tests'.tr,
                                  style: AppTextStyle.getOutfit500(
                                      textSize: 18,
                                      textColor: AppColors.secondary),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: AppColors.secondary
                                      //     .withOpacity(0.06)
                                      color: AppColors.secondary.withValues(alpha: 0.06)
                                  ),
                                  padding: const EdgeInsets.only(left: 10),
                                  child: studentParentTeacherController
                                          .listOfExamBasedOnSubjects.isNotEmpty
                                      ? DropdownButton<ExamListItem>(
                                          underline: SizedBox.shrink(),
                                          isExpanded: true,
                                          value: studentParentTeacherController
                                              .viewMarkSelectedExam,
                                          hint: Text(
                                            "Seleccionar examen",
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 16,
                                                // textColor: AppColors.secondary
                                                //     .withOpacity(0.6)
                                              textColor: AppColors.secondary.withValues(alpha: 0.6)
                                            ),
                                          ),
                                          items: studentParentTeacherController
                                              .listOfExamBasedOnSubjects
                                              .map((e) {
                                            return DropdownMenuItem<
                                                    ExamListItem>(
                                                value: e,
                                                child: Text(
                                                  "${e.eName}",
                                                  style:
                                                      AppTextStyle.getOutfit400(
                                                          textSize: 18,
                                                          textColor: AppColors
                                                              .secondary),
                                                ));
                                          }).toList(),
                                          onChanged:
                                              (ExamListItem? examListItem) {
                                            studentParentTeacherController
                                                .setViewMarkExamSelected(
                                                    examListItem: examListItem);
                                          })
                                      : SizedBox.shrink(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ));
                      },
                    ),
                    Row(
                      children: [
                        Expanded(child: Consumer<StudentParentTeacherController>(
                          builder:
                              (context, studentParentTeacherController, child) {
                            return SizedBox(
                              child: CustomButtonWidget(
                                  buttonTitle: 'Agregar/Editar',
                                  onPressed: studentParentTeacherController
                                      .listOfSubject.isNotEmpty &&
                                      studentParentTeacherController
                                          .viewMarkSubjectSelected !=
                                          null
                                      ? () async {
                                    if (studentParentTeacherController
                                        .viewMarkSelectedExam !=
                                        null) {
                                      Get.back();
                                      studentParentTeacherController.setViewOrAddEditMarks(viewOrAddEditMarks: 1);
                                      await studentParentTeacherController
                                          .getListOfMarks(
                                          classId:
                                          studentParentTeacherController
                                              .currentSelectedClass
                                              ?.cid ??
                                              "",
                                          subjectId:
                                          studentParentTeacherController
                                              .viewMarkSubjectSelected
                                              ?.id ??
                                              "",
                                          examId:
                                          studentParentTeacherController
                                              .viewMarkSelectedExam
                                              ?.eid ??
                                              "")
                                          .then((response) {

                                      });
                                    } else {
                                      AppConstants.showCustomToast(
                                          status: false,
                                          message:
                                          "Por favor seleccione examen");
                                    }
                                  }
                                      : () {
                                    if (studentParentTeacherController
                                        .selectedStudentForFollowedUp ==
                                        null) {
                                      AppConstants.showCustomToast(
                                          status: false,
                                          message:
                                          'Por favor seleccione estudiante');
                                    }
                                  }),
                            );
                          },
                        )),
                        const SizedBox(width: 20,),
                        Expanded(child: Consumer<StudentParentTeacherController>(
                          builder:
                              (context, studentParentTeacherController, child) {
                            return SizedBox(
                              child: CustomButtonWidget(
                                  buttonTitle: 'Ver datos',
                                  onPressed: studentParentTeacherController
                                      .listOfSubject.isNotEmpty &&
                                      studentParentTeacherController
                                          .viewMarkSubjectSelected !=
                                          null
                                      ? () async {
                                    if (studentParentTeacherController
                                        .viewMarkSelectedExam !=
                                        null) {
                                      Get.back();
                                      studentParentTeacherController.setViewOrAddEditMarks(viewOrAddEditMarks: 0);
                                      await studentParentTeacherController
                                          .getListOfMarks(
                                          classId:
                                          studentParentTeacherController
                                              .currentSelectedClass
                                              ?.cid ??
                                              "",
                                          subjectId:
                                          studentParentTeacherController
                                              .viewMarkSubjectSelected
                                              ?.id ??
                                              "",
                                          examId:
                                          studentParentTeacherController
                                              .viewMarkSelectedExam
                                              ?.eid ??
                                              "")
                                          .then((response) {});
                                    } else {
                                      AppConstants.showCustomToast(
                                          status: false,
                                          message:
                                          "Por favor seleccione examen");
                                    }
                                  }
                                      : () {
                                    if (studentParentTeacherController
                                        .selectedStudentForFollowedUp ==
                                        null) {
                                      AppConstants.showCustomToast(
                                          status: false,
                                          message:
                                          'Por favor seleccione estudiante');
                                    }
                                  }),
                            );
                          },
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }
}
