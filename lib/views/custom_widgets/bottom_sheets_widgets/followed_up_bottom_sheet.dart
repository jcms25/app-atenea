import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class FollowedUpBottomSheet extends StatelessWidget {
  const FollowedUpBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Stack(
        children: [
          ScrollConfiguration(
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
                        fromWhichScreen: 1,
                        backgroundColor: AppColors.secondary.withOpacity(0.06),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'student'.tr,
                          style: AppTextStyle.getOutfit500(
                              textSize: 18, textColor: AppColors.secondary),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<StudentParentTeacherController>(
                            builder: (context, studentParentTeacherController, child) {
                              return Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.secondary.withOpacity(0.06)),
                                padding: const EdgeInsets.only(left: 10),
                                child: studentParentTeacherController
                                    .listOfStudents.isNotEmpty
                                    ? DropdownButton<StudentItem>(
                                    underline: SizedBox.shrink(),
                                    isExpanded: true,
                                    value: studentParentTeacherController
                                        .selectedStudentForFollowedUp,
                                    items: studentParentTeacherController.listOfStudents
                                        .map((e) {
                                      return DropdownMenuItem<StudentItem>(
                                          value: e,
                                          child: Text(
                                            "${e.sLname}\t${e.sFname}",
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 18,
                                                textColor: AppColors.secondary),
                                          ));
                                    }).toList(),
                                    onChanged: (StudentItem? studentItem) {
                                      studentParentTeacherController
                                          .setSelectedStudentForFollowUp(
                                          studentItem: studentItem);
                                    })
                                    : SizedBox.shrink(),
                              );
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Consumer<StudentParentTeacherController>(
                        builder: (context, studentParentTeacherController, child) {
                          return SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.30,
                            child: CustomButtonWidget(
                                buttonTitle: 'Ver datos',
                                onPressed: studentParentTeacherController
                                    .listOfStudents.isNotEmpty ||
                                    studentParentTeacherController
                                        .selectedStudentForFollowedUp !=
                                        null
                                    ? () {
                                  studentParentTeacherController
                                      .getListOfFollowedUp(
                                      studentId:
                                      studentParentTeacherController
                                          .selectedStudentForFollowedUp
                                          ?.wpUsrId ??
                                          "",
                                      classId:
                                      studentParentTeacherController
                                          .currentSelectedClass
                                          ?.cid ??
                                          "");
                                  Get.back();
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
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
