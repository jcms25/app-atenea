import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/log_out_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/app_images.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentParentTeacherController>(
        builder: (context, appController, child) {
      RoleType? currentUserRole = appController.currentLoggedInUserRole;
      String? profileImage = currentUserRole == RoleType.student
          ? appController.loginModel?.userdata?.stuImage ?? ""
          : currentUserRole == RoleType.parent ? appController.loginModel?.userdata?.parentImage ?? "" : appController.loginModel?.userdata?.teacherImage ?? "";

      List<DrawerMenuOption> drawerListOption = _buildDrawerMenuOption(
          appController: appController, roleType: currentUserRole);

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
                      const SizedBox(width: 10,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "hello".tr,
                            style: AppTextStyle.getOutfit300(
                                textSize: 16, textColor: AppColors.white),
                          ),
                          Text(
                              currentUserRole == RoleType.student
                                  ? appController
                                  .loginModel?.userdata?.sFname ??
                                  "-"
                                  : currentUserRole == RoleType.parent ?
                                 appController
                                  .loginModel?.userdata?.pFname ??
                                  "-" : appController.loginModel?.userdata?.firstName ?? "",
                              style: AppTextStyle.getOutfit600(
                                  textSize: 20,
                                  textColor: AppColors.white))
                        ],
                      )),
                      // const Spacer(),
                      const SizedBox(width: 10,),
                      Image.asset(AppImages.whiteAppLogo, width: 50, height: 50)
                    ],
                  )
                ],
              ),
            ),
            // Expanded(
            //     child: Column(
            //   children: [
            //     ...appController.currentLoggedInUserRole == RoleType.student
            //         ? AppConstants.drawerListStudent.map((e) {
            //             return Text(
            //               e['name'] ?? "",
            //               style: AppTextStyle.getOutline400(
            //                   textSize: 16, textColor: AppColors.black),
            //             );
            //           }).toList()
            //         : AppConstants.drawerListStudent.map((e) {
            //             return Text(e['name'] ?? "",
            //                 style: AppTextStyle.getOutline400(
            //                     textSize: 16, textColor: AppColors.black));
            //           }).toList()
            //   ],
            // )),
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
            Consumer<StudentParentTeacherController>(
              builder: (context,studentParentTeacherController,child){
                return  CustomButtonWidget(buttonTitle: "logout".tr,
                    suffixIcon: AppImages.loginArrow,
                    margin: 10,
                    onPressed: (){
                      showDialog(context: context, builder: (context){
                        return LogOutDialogue(currentLoggedInUserRole: studentParentTeacherController.currentLoggedInUserRole == RoleType.assistant ? 0 : 1);
                      });
                    }
                    );
              },
            )
          ],
        ),
      );
    });
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
      drawerMenuOption1.studentWpId = studentId;
      subMenu.add(drawerMenuOption1);
    } else {
      List<Map<String, dynamic>> subMenuList = AppConstants.subMenuList;
      for (var e in subMenuList) {
        if (e['name'] == "Envíos del Profesor" &&
            roleType == RoleType.student) {
          continue;
        } else {
          DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
          drawerMenuOption.classId = classId;
          drawerMenuOption.studentWpId = studentId;
          drawerMenuOption.className = className;
          drawerMenuOption.studentName = studentName;
          subMenu.add(drawerMenuOption);
        }
      }
    }
    return subMenu;
  }

  Widget _buildListOfDrawerOption(DrawerMenuOption drawerMenuOption) {
    if (drawerMenuOption.subMenu == null) {
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
        onTap: () {},
        title: Text(
          drawerMenuOption.name ?? "-",
          style: AppTextStyle.getOutfit500(
              textSize: 18, textColor: AppColors.secondary),
        ),
      );
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
}

class DrawerMenuOption {
  //studentData means when parent login in which parent get data of student.
  //userData is data when student login and data of that student.

  String? name;
  String? icon;
  List<DrawerMenuOption>? subMenu;
  String? studentWpId;
  String? classId;
  String? className;
  String? studentName;

  DrawerMenuOption(
      {required this.name,
      this.icon,
      this.subMenu,
      this.studentWpId,
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
