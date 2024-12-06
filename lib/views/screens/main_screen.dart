import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_drawer_widget.dart';
import 'package:colegia_atenea/views/screens/circular_screen.dart';
import 'package:colegia_atenea/views/screens/dashboard_screen.dart';
import 'package:colegia_atenea/views/screens/event_screen.dart';
import 'package:colegia_atenea/views/screens/message_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_class_list_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teaching_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_textstyle.dart';
import 'class_menu_screens/classes.dart';
import 'parent_student_info_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: AppConstants.mainScreenKey,
          appBar: CustomAppBarWidget(
            title: Consumer<StudentParentTeacherController>(
              builder: (context, appController, child) {
                return Text(
                    appController.currentLoggedInUserRole == RoleType.student
                        ? appController.currentBottomIndexSelected == 0
                        ? 'desk'.tr
                        : appController.currentBottomIndexSelected == 1
                        ? "message".tr
                        : appController.currentBottomIndexSelected == 2
                        ? "pTitle".tr
                        : appController.currentBottomIndexSelected == 3
                        ? "classes".tr
                        : "events".tr
                        : appController.currentLoggedInUserRole ==
                        RoleType.parent
                        ? appController.currentBottomIndexSelected == 0
                        ? 'desk'.tr
                        : appController.currentBottomIndexSelected == 1
                        ? "circular".tr
                        : appController.currentBottomIndexSelected == 2
                        ? "message".tr
                        : appController.currentBottomIndexSelected == 3
                        ? "student".tr
                        : appController.currentBottomIndexSelected ==
                        4
                        ? "classes".tr
                        : "events".tr
                        : appController.currentBottomIndexSelected == 0 ?
                    'desk'.tr
                        : appController.currentBottomIndexSelected == 1 ?
                    "message".tr
                        : appController.currentBottomIndexSelected == 2 ?
                    "classes".tr
                        : appController.currentBottomIndexSelected == 3 ?
                    "Gestión docente"
                        : "events".tr,
                    style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),);
              },
            ),
            leadingIcon: AppImages.humBurg,
            onLeadingIconClicked: () {
              AppConstants.mainScreenKey.currentState?.openDrawer();
            },
          ),
          bottomNavigationBar: Container(
            height: 80,
            decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.secondary.withOpacity(0.10),
                      blurRadius: 10
                  )
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Consumer<StudentParentTeacherController>(
              builder: (context, appController, child) {
                return BottomNavigationBar(
                    backgroundColor: AppColors.transparent,
                    currentIndex: appController.currentBottomIndexSelected,
                    showUnselectedLabels: false,
                    showSelectedLabels: false,
                    elevation: 0,
                    onTap: (index) {
                      appController.setCurrentBottomIndexSelected(index: index);
                    },
                    unselectedItemColor: AppColors.greyColor,
                    selectedItemColor: AppColors.primary,
                    type: BottomNavigationBarType.fixed,
                    items: appController.currentLoggedInUserRole ==
                        RoleType.student
                        ? AppConstants.bottomNavigationBarStudent.map((e) {
                      return BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            e.optionIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.greyColor,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          activeIcon: SvgPicture.asset(
                            e.optionIcon,
                            colorFilter: const ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                            width: 25,
                            height: 25,
                          ),
                          label: e.optionName);
                    }).toList()
                        : appController.currentLoggedInUserRole ==
                        RoleType.parent ?
                    AppConstants.bottomNavigationBarParent.map((e) {
                      return BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            e.optionIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.greyColor,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          activeIcon: SvgPicture.asset(
                            e.optionIcon,
                            colorFilter: const ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                            width: 25,
                            height: 25,
                          ),
                          label: e.optionName);
                    }).toList() :
                    AppConstants.bottomNavigationBarTeacher.map((e) {
                      return BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            e.optionIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.greyColor,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          activeIcon: SvgPicture.asset(
                            e.optionIcon,
                            colorFilter: const ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                            width: 25,
                            height: 25,
                          ),
                          label: e.optionName);
                    }).toList()
                );
              },
            ),
          ),
          drawer: const CustomDrawerWidget(),
          body: Consumer<StudentParentTeacherController>(
            builder: (context, appController, child) {
              return appController.currentLoggedInUserRole == RoleType.student
                  ? appController.currentBottomIndexSelected == 0
                  ? const DashboardScreen()
                  : appController.currentBottomIndexSelected == 1
                  ? const MessageScreen(studentOrParent: "0")
                  : appController.currentBottomIndexSelected == 2
                  ? const ParentStudentInfo()
                  : appController.currentBottomIndexSelected == 3
                  ? const ClassesScreen()
                  : const EventScreen()
                  : appController.currentLoggedInUserRole == RoleType.parent ?
                  appController.currentBottomIndexSelected == 0
                  ? const DashboardScreen()
                  : appController.currentBottomIndexSelected == 1
                  ? const CircularScreen()
                  : appController.currentBottomIndexSelected == 2
                  ? const MessageScreen(studentOrParent: "0")
                  : appController.currentBottomIndexSelected == 3
                  ? const ParentStudentInfo()
                  : appController.currentBottomIndexSelected == 4
                  ? const ClassesScreen()
                  : const EventScreen()
                  : appController.currentBottomIndexSelected == 0
                  ? const DashboardScreen()
                  : appController.currentBottomIndexSelected == 1
                  ? const MessageScreen(studentOrParent: "0")
                  : appController.currentBottomIndexSelected == 2
                  ? const TeacherClassListScreen()
                  : appController.currentBottomIndexSelected == 3
                  ? const TeachingManagementScreen()
                  : const EventScreen();
            },
          ),
        ));
  }
}
