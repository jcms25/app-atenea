import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_report_message_list_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/evaluation_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/grade_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/send_message_to_assistant_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/student_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/subject_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/teacher_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/exam_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/timetable_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/transportation_screen.dart';
import 'package:colegia_atenea/views/screens/child_communication_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassMenuScreen extends StatelessWidget {
  final Userdata? userdata;
  final StudentData? studentData;

  const ClassMenuScreen({super.key, this.userdata, this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              Get.back();
            },
            title: Text(
              userdata != null
                  ? userdata!.className ?? ""
                  : studentData?.className ?? "",
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            )),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              userdata != null ||
                      studentData != null && studentData?.showAssistant == "0"
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Visibility(
                              visible: studentData != null,
                              child: ClassMenuWidget(
                                  menuName: "Envíos del Profesor",
                                  leadingIcon: Icons.email_outlined,
                                  onPressed: () {
                                    Get.to(() => ChildCommunicationListScreen(
                                        studentWpUserId:
                                            studentData?.wpUsrId ?? ""));
                                  })),
                          ClassMenuWidget(
                              menuName: "timetable".tr,
                              leadingIcon: Icons.calendar_month,
                              onPressed: () {
                                Get.to(() => TimeTableScreen(),
                                arguments: {
                                  "role" : userdata != null ? RoleType.student : RoleType.parent,
                                  "wpUserId" : studentData != null
                                      ? studentData?.wpUsrId ?? ""
                                      : userdata?.wpUsrId ?? "",
                                  "classId" : studentData != null
                                      ? studentData?.classId ?? ""
                                      : userdata?.classId ?? "",
                                  "className": studentData != null
                                      ? studentData?.className ?? ""
                                      : userdata?.className ?? "",
                                 "studentName": studentData != null
                                      ? studentData?.sFname ?? ""
                                      : userdata?.sFname ?? ""
                                }
                                );
                              }),
                          ClassMenuWidget(
                              menuName: "teachers".tr,
                              leadingIcon: Icons.person_add_sharp,
                              onPressed: () {
                                Get.to(() => TeacherListScreen(),
                                arguments: {
                                  "role" : userdata != null ? RoleType.student : RoleType.parent,
                                  "wpUserId" : studentData != null
                                      ? studentData?.wpUsrId ?? ""
                                      : userdata?.wpUsrId ?? "",
                                  "classId" : studentData != null
                                      ? studentData?.classId ?? ""
                                      : userdata?.classId ?? "",
                                  "className": studentData != null
                                      ? studentData?.className ?? ""
                                      : userdata?.className ?? ""
                                }
                                );
                              }),
                          ClassMenuWidget(
                              menuName: "student".tr,
                              leadingIcon: Icons.person,
                              onPressed: () {
                                Get.to(() => StudentListScreen(),
                                arguments: {
                                  "role" : userdata != null ? RoleType.student : RoleType.parent,
                                  "wpUserId" : studentData != null
                                      ? studentData?.wpUsrId ?? ""
                                      : userdata?.wpUsrId ?? "",
                                  "classId" : studentData != null
                                      ? studentData?.classId ?? ""
                                      : userdata?.classId ?? "",
                                  "className": studentData != null
                                      ? studentData?.className ?? ""
                                      : userdata?.className ?? "",}
                                );
                              }),
                          ClassMenuWidget(
                              menuName: "subjects".tr,
                              leadingIcon: Icons.library_books,
                              onPressed: () {
                                Get.to(() => SubjectListScreen(),
                                arguments: {
                                  "role" : userdata != null ? RoleType.student : RoleType.parent,
                                  "wpUserId" : studentData != null
                                      ? studentData?.wpUsrId ?? ""
                                      : userdata?.wpUsrId ?? "",
                                  "classId" : studentData != null
                                      ? studentData?.classId ?? ""
                                      : userdata?.classId ?? "",
                                  "className": studentData != null
                                      ? studentData?.className ?? ""
                                      : userdata?.className ?? "",
                                  "studentName": studentData != null
                                      ? studentData?.sFname ?? ""
                                      : userdata?.sFname ?? ""
                                });
                              }),
                          ClassMenuWidget(
                              menuName: "tests".tr,
                              leadingIcon: Icons.textsms_sharp,
                              onPressed: () {
                                Get.to(() => ExamListScreen(),
                                arguments: {
                                  "role" : userdata != null ? RoleType.student : RoleType.parent,
                                  "wpUserId" : studentData != null
                                      ? studentData?.wpUsrId ?? ""
                                      : userdata?.wpUsrId ?? "",
                                  "classId" : studentData != null
                                      ? studentData?.classId ?? ""
                                      : userdata?.classId ?? "",
                                }
                                );
                              }),
                          ClassMenuWidget(
                              menuName: "grades".tr,
                              leadingIcon: Icons.margin,
                              onPressed: () {
                                Get.to(() => GradeScreen(
                                    studentData != null
                                        ? studentData?.classId ?? ""
                                        : userdata?.classId ?? "",
                                    studentData != null
                                        ? studentData?.wpUsrId ?? ""
                                        : userdata?.wpUsrId ?? ""));
                              }),
                          ClassMenuWidget(
                              menuName: "evaluation".tr,
                              leadingIcon: Icons.edit_calendar,
                              onPressed: () {
                                Get.to(() => EvaluationScreen(
                                      cid : studentData != null
                                          ? studentData?.classId ?? ""
                                          : userdata?.classId ?? "",
                                      wpId : studentData != null
                                          ? studentData?.wpUsrId ?? ""
                                          : userdata?.wpUsrId ?? "",
                                      studentName: studentData != null
                                          ? studentData?.sFname ?? ""
                                          : userdata?.sFname ?? "",
                                    ));
                              }),
                          ClassMenuWidget(
                              menuName: "trans".tr,
                              leadingIcon: Icons.train,
                              onPressed: () {
                                Get.to(() => const TransportationScreen());
                              }),
                        ],
                      ))
                  : Column(
                      children: [
                        ClassMenuWidget(
                            menuName: 'menu1'.tr,
                            leadingIcon: Icons.email,
                            onPressed: () {
                              Get.to(() =>
                                  const ReportListScreen(showInParent: "1"));
                            }),
                        ClassMenuWidget(
                            menuName: 'menu2'.tr,
                            leadingIcon: Icons.send,
                            onPressed: () {
                              Get.to(() => SendMessageToAssistant(
                                  studentId: studentData?.wpUsrId ?? ""));
                            }),
                      ],
                    )
            ],
          ))
        ]));
  }
}

class ClassMenuWidget extends StatelessWidget {
  final String menuName;
  final IconData leadingIcon;
  final VoidCallback onPressed;

  const ClassMenuWidget(
      {super.key,
      required this.menuName,
      required this.leadingIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPressed,
        title: Text(
          menuName,
          style: AppTextStyle.getOutfit500(
              textSize: 16, textColor: AppColors.secondary),
        ),
        leading: Icon(
          leadingIcon,
          size: 30,
          color: AppColors.secondary,
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: AppColors.secondary,
          size: 30,
        ));
  }
}
