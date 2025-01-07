import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/classmenu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
              Userdata? userdata =
                  studentParentTeacherController.userdata;
              return studentParentTeacherController.currentLoggedInUserRole ==
                      RoleType.student
                  ? ClassWidget(
                      onPressed: () {
                        Get.to(() => ClassMenuScreen(
                              userdata: userdata,
                            ));
                      },
                      roleType: RoleType.student,
                      userdata: userdata)
                  : Column(
                      children: [
                        ...userdata?.studentData?.map((e) {
                              return ClassWidget(
                                onPressed: () {
                                  Get.to(() => ClassMenuScreen(
                                        studentData: e,
                                      ));
                                },
                                studentData: e,
                                roleType: RoleType.parent,
                              );
                            }).toList() ??
                            []
                      ],
                    );
            })
          ],
        ));
  }
}

class ClassWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final StudentData? studentData;
  final Userdata? userdata;
  final RoleType roleType;

  const ClassWidget(
      {super.key,
      required this.onPressed,
      this.studentData,
      this.userdata,
      required this.roleType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.06),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.all(15),
        child: (Row(
          children: [
            Container(
              width: 70,
              constraints: const BoxConstraints(
                minHeight: 70,
              ),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Center(
                child: Text(
                  roleType == RoleType.student
                      ? userdata?.className ?? ""
                      : studentData?.className ?? "",
                  style: AppTextStyle.getOutfit400(
                      textSize: 14, textColor: AppColors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  roleType == RoleType.student
                      ? userdata?.sFname ?? ""
                      : studentData?.sFname ?? "",
                  style: AppTextStyle.getOutfit600(
                      textSize: 18, textColor: AppColors.secondary),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
