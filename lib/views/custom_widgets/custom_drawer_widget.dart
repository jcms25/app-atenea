import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/log_out_dialogue.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/student_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/subject_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/teacher_list_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_parent_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/app_images.dart';
import '../screens/class_menu_screens/timetable_screen.dart';

class CustomDrawerWidget extends StatelessWidget {
  final StudentParentTeacherController studentParentTeacherController;

  const CustomDrawerWidget(
      {super.key, required this.studentParentTeacherController});

  @override
  Widget build(BuildContext context) {
    RoleType? currentUserRole =
        studentParentTeacherController.currentLoggedInUserRole;
    String? profileImage = currentUserRole == RoleType.student
        ? studentParentTeacherController.loginModel?.userdata?.stuImage ?? ""
        : currentUserRole == RoleType.parent
            ? studentParentTeacherController
                    .loginModel?.userdata?.parentImage ??
                ""
            : studentParentTeacherController
                    .loginModel?.userdata?.teacherImage ??
                "";
    List<DrawerMenuOption> drawerListOption = _buildDrawerMenuOption(
        appController: studentParentTeacherController,
        roleType: currentUserRole);

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.70,
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 65,
                      width: 65,
                      child: profileImage.isEmpty
                          ? const CircleAvatar(
                              backgroundImage: AssetImage(AppImages.people),
                            )
                          : CircleAvatar(
                              radius: 16.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(65.0),
                                child: Image.network(
                                  profileImage,
                                  fit: BoxFit.cover,
                                  height: 65,
                                  width: 65,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "hello".tr,
                          style: AppTextStyle.getOutfit300(
                              textSize: 16, textColor: AppColors.white),
                        ),
                        AutoSizeText(
                            maxLines: 1,
                            currentUserRole == RoleType.student
                                ? studentParentTeacherController
                                        .loginModel?.userdata?.sFname ??
                                    "-"
                                : currentUserRole == RoleType.parent
                                    ? studentParentTeacherController
                                            .loginModel?.userdata?.pFname ??
                                        "-"
                                    : studentParentTeacherController
                                            .loginModel?.userdata?.firstName ??
                                        "",
                            style: AppTextStyle.getOutfit600(
                                textSize: 20, textColor: AppColors.white))
                      ],
                    )),
                    // const Spacer(),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(AppImages.whiteAppLogo, width: 50, height: 50)
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: drawerListOption.length,
              itemBuilder: (context, index) {
                return _buildListOfDrawerOption(drawerListOption[index]);
              },
            ),
          ),
          CustomButtonWidget(
              buttonTitle: "logout".tr,
              suffixIcon: AppImages.loginArrow,
              margin: 10,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return LogOutDialogue(
                          currentLoggedInUserRole:
                              studentParentTeacherController
                                          .currentLoggedInUserRole ==
                                      RoleType.assistant
                                  ? 0
                                  : 1);
                    });
              })
        ],
      ),
    );
  }

  List<DrawerMenuOption> _buildDrawerMenuOption(
      {required StudentParentTeacherController? appController,
      required RoleType? roleType}) {
    List<DrawerMenuOption> drawerMenuOptionList = [];
    if (roleType == RoleType.student) {
      for (var e in AppConstants.drawerListStudent) {
        DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
        if (drawerMenuOption.name == 'drawerOption3'.tr) {
          drawerMenuOption.subMenu ??= [
            DrawerMenuOption(
                name: appController?.loginModel?.userdata?.className ?? "",
                subMenu: buildSubMenu(
                    classId: appController?.loginModel?.userdata?.classId ?? "",
                    studentId:
                        appController?.loginModel?.userdata?.wpUsrId ?? "",
                    className:
                        appController?.loginModel?.userdata?.className ?? "",
                    studentName:
                        appController?.loginModel?.userdata?.sFname ?? "",
                    roleType: RoleType.student))
          ];
        }

        if (drawerMenuOption.name == 'drawerOption10'.tr) {
          drawerMenuOption.subMenu ??= buildSubMenu(
              classId: "",
              studentId: "",
              className: "",
              studentName: "",
              roleType: roleType,
              teacherDrawerMenuName: 'drawerOption10'.tr);
        }

        drawerMenuOptionList.add(drawerMenuOption);
      }
    } else if (roleType == RoleType.teacher) {
      for (var e in AppConstants.drawerListTeacher) {
        DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
        if (drawerMenuOption.name == 'drawerOption8'.tr ||
            drawerMenuOption.name == 'drawerOption9'.tr ||
            drawerMenuOption.name == 'drawerOption10'.tr) {
          if (drawerMenuOption.subMenu == null) {
            if (drawerMenuOption.name == 'drawerOption8'.tr) {
              //classes sub menu build
              drawerMenuOption.subMenu = buildSubMenu(
                  classId: "",
                  studentId: "",
                  className: "",
                  studentName: "",
                  roleType: RoleType.teacher,
                  teacherDrawerMenuName: 'drawerOption8'.tr);
            } else if (drawerMenuOption.name == 'drawerOption9'.tr) {
              //teaching management sub menu build
              drawerMenuOption.subMenu = buildSubMenu(
                  classId: "",
                  studentId: "",
                  className: "",
                  studentName: "",
                  roleType: RoleType.teacher,
                  teacherDrawerMenuName: 'drawerOption9'.tr);
            } else {
              //dinning sub menu build
              drawerMenuOption.subMenu = buildSubMenu(
                  classId: "",
                  studentId: "",
                  className: "",
                  studentName: "",
                  roleType: RoleType.teacher,
                  teacherDrawerMenuName: 'drawerOption10'.tr);
            }
          }
        }
        drawerMenuOptionList.add(drawerMenuOption);
      }
    } else {
      for (var e in AppConstants.drawerListParent) {
        DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
        if (drawerMenuOption.name == 'drawerOption7'.tr) {
          if (drawerMenuOption.subMenu == null) {
            List<DrawerMenuOption> tempList = [];
            List<StudentData> studentData =
                appController?.loginModel?.userdata?.studentData ?? [];
            for (var student in studentData) {
              tempList.add(DrawerMenuOption(
                name:
                    "${student.sFname}\t${student.sLname}\t(${student.className})",
                icon: AppImages.people,
                subMenu: student.showAssistant == "0"
                    ? buildSubMenu(
                        classId: student.classId ?? "",
                        studentId: student.wpUsrId ?? "",
                        className: student.className ?? "",
                        studentName: student.sFname ?? "",
                        roleType: RoleType.parent)
                    : buildSubMenu(
                        classId: '',
                        studentId: '',
                        isShowAssistant: "1",
                        className: '',
                        studentName: '',
                        roleType: null),
              ));
            }
            drawerMenuOption.subMenu = tempList;
          }
        }
        if (drawerMenuOption.name == 'drawerOption10'.tr) {
          drawerMenuOption.subMenu ??= buildSubMenu(
              classId: "",
              studentId: "",
              className: "",
              studentName: "",
              roleType: roleType,
              teacherDrawerMenuName: 'drawerOption10'.tr);
        }
        drawerMenuOptionList.add(drawerMenuOption);
      }
    }
    return drawerMenuOptionList;
  }

  List<DrawerMenuOption> buildSubMenu(
      {required String classId,
      required String studentId,
      required String className,
      required String studentName,
      required RoleType? roleType,
      String? teacherDrawerMenuName,
      String? isShowAssistant}) {
    List<DrawerMenuOption> subMenu = [];
    if (isShowAssistant != null) {
      DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson({
        "name": "menu1".tr,
      });
      subMenu.add(drawerMenuOption);

      DrawerMenuOption drawerMenuOption1 = DrawerMenuOption.fromJson({
        "name": "menu2".tr,
      });
      drawerMenuOption1.wpUserId = studentId;
      subMenu.add(drawerMenuOption1);
    } else if (roleType != null && roleType == RoleType.teacher) {
      if (teacherDrawerMenuName == 'drawerOption8'.tr) {
        for (var e in AppConstants.classSubMenuListTeacher) {
          DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
          drawerMenuOption.classId = classId;
          drawerMenuOption.wpUserId = studentId;
          drawerMenuOption.className = className;
          drawerMenuOption.studentName = studentName;
          subMenu.add(drawerMenuOption);
        }
      } else if (teacherDrawerMenuName == 'drawerOption9'.tr) {
        for (var e in AppConstants.teachingSubMenuListTeacher) {
          DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
          drawerMenuOption.classId = classId;
          drawerMenuOption.wpUserId = studentId;
          drawerMenuOption.className = className;
          drawerMenuOption.studentName = studentName;
          subMenu.add(drawerMenuOption);
        }
      } else {
        for (var e in AppConstants.dinningSubMenuListTeacher) {
          DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
          drawerMenuOption.classId = classId;
          drawerMenuOption.wpUserId = studentId;
          drawerMenuOption.className = className;
          drawerMenuOption.studentName = studentName;
          subMenu.add(drawerMenuOption);
        }
      }
    } else {
      if (teacherDrawerMenuName == 'drawerOption10'.tr) {
        for (var e in AppConstants.dinningSubMenuListTeacher) {
          if (e['name'] == 'subMenuDrawer11'.tr &&
              roleType == RoleType.student) {
            continue;
          } else {
            DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
            drawerMenuOption.classId = classId;
            drawerMenuOption.wpUserId = studentId;
            drawerMenuOption.className = className;
            drawerMenuOption.studentName = studentName;
            subMenu.add(drawerMenuOption);
          }
        }
      } else {
        List<Map<String, dynamic>> subMenuList = AppConstants.subMenuList;
        for (var e in subMenuList) {
          if (e['name'] == "Envíos del Profesor" &&
              roleType == RoleType.student) {
            continue;
          } else {
            DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
            drawerMenuOption.classId = classId;
            drawerMenuOption.wpUserId = studentId;
            drawerMenuOption.className = className;
            drawerMenuOption.studentName = studentName;
            subMenu.add(drawerMenuOption);
          }
        }
      }
    }
    return subMenu;
  }

  Widget _buildListOfDrawerOption(DrawerMenuOption drawerMenuOption) {
    if (drawerMenuOption.subMenu == null) {
      return Consumer<StudentParentTeacherController>(
          builder: (context, studentParentTeacherController, child) {
        return ListTile(
          leading: drawerMenuOption.icon == null
              ? const SizedBox.shrink()
              : SvgPicture.asset(
                  drawerMenuOption.icon!,
                  colorFilter: const ColorFilter.mode(
                      AppColors.secondary, BlendMode.srcIn),
                  width: 25,
                  height: 25,
                ),
          onTap: () {
            onDrawerItemClick(
                drawerMenuOption: drawerMenuOption,
                roleType:
                    studentParentTeacherController.currentLoggedInUserRole);
          },
          title: Text(
            drawerMenuOption.name ?? "-",
            style: AppTextStyle.getOutfit500(
                textSize: 18, textColor: AppColors.secondary),
          ),
        );
      });
    } else {
      return ExpansionTile(
        leading: drawerMenuOption.icon == null
            ? const SizedBox.shrink()
            : SvgPicture.asset(
                drawerMenuOption.icon ?? "",
                width: 25,
                height: 25,
                colorFilter: const ColorFilter.mode(
                    AppColors.secondary, BlendMode.srcIn),
              ),
        collapsedIconColor: AppColors.secondary,
        iconColor: AppColors.secondary,
        title: Text(
          drawerMenuOption.name ?? "",
          style: AppTextStyle.getOutfit500(
              textSize: 18, textColor: AppColors.secondary),
        ),
        children:
            drawerMenuOption.subMenu?.map(_buildListOfDrawerOption).toList() ??
                [],
      );
    }
  }

  //on click of drawer menu option
  void onDrawerItemClick(
      {required DrawerMenuOption drawerMenuOption,
      required RoleType? roleType}) {
    switch (drawerMenuOption.name ?? "") {
      case "Escritorio":
        break;
      case "Padres":
        Get.to(() => TeacherParentListScreen());
        break;
      case "Clase":
        break;
      case "Eventos":
        break;
      case "Circulares":
        break;
      case "Comunicaciones":
        break;
      case "Alumnos":
        Get.to(() => StudentListScreen(),
            arguments: roleType == RoleType.teacher
                ? {"role": RoleType.teacher}
                : {
                    "role": roleType,
                    "wpUserId": drawerMenuOption.wpUserId,
                    "classId": drawerMenuOption.classId,
                    "className": drawerMenuOption.className,
                    "studentName": drawerMenuOption.studentName
                  });
        break;
      case "Clases":
        break;
      case "Gestión docente":
        break;
      case "Comedor":
        break;
      case "Horario":
        Get.to(() => TimeTableScreen(),
            arguments: roleType == RoleType.teacher
                ? {"role": RoleType.teacher}
                : {
                    "role": roleType,
                    "wpUserId": drawerMenuOption.wpUserId,
                    "classId": drawerMenuOption.classId,
                    "className": drawerMenuOption.className,
                    "studentName": drawerMenuOption.studentName
                  });
        break;
      case "Profesores":
        Get.to(() => TeacherListScreen(),
            arguments: roleType == RoleType.teacher
                ? {"role": RoleType.teacher}
                : {
                    "role": roleType,
                    "wpUserId": drawerMenuOption.wpUserId,
                    "classId": drawerMenuOption.classId,
                    "className": drawerMenuOption.className,
                    "studentName": drawerMenuOption.studentName
                  });
        break;
      case "Asignaturas":
        Get.to(() => SubjectListScreen(),
            arguments: roleType == RoleType.teacher
                ? {"role": RoleType.teacher}
                : {
                    "role": roleType,
                    "wpUserId": drawerMenuOption.wpUserId,
                    "classId": drawerMenuOption.classId,
                    "className": drawerMenuOption.className,
                    "studentName": drawerMenuOption.studentName
                  });
        break;
      case "Exámenes/Trabajos":
        break;
      case "Notas":
        break;
      case "Evaluaciones":
        break;
      case "Ausencias":
        break;
      case "Transporte":
        break;
      case "Menu":
        break;
      case "Gestionar Servicio":
        break;
      case "Mi Horario":
        break;
      case "Seguimiento":
      default:
        break;
    }
  }
}

class DrawerMenuOption {
  //studentData means when parent login in which parent get data of student.
  //userData is data when student login and data of that student.

  String? name;
  String? icon;
  List<DrawerMenuOption>? subMenu;
  String? wpUserId;
  String? classId;
  String? className;
  String? studentName;

  DrawerMenuOption(
      {required this.name,
      this.icon,
      this.subMenu,
      this.wpUserId,
      this.classId,
      this.className,
      this.studentName});

  DrawerMenuOption.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {
      subMenu!.clear();
      json['subMenu'].forEach((v) {
        subMenu!.add(DrawerMenuOption.fromJson(v));
      });
    }
  }
}
