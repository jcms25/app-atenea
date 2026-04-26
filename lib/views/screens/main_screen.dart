import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_drawer_widget.dart';
import 'package:colegia_atenea/views/screens/circular_screen.dart';
import 'package:colegia_atenea/views/screens/dashboard_screen.dart';
import 'package:colegia_atenea/views/screens/event_screen.dart';
import 'package:colegia_atenea/views/screens/message_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_class_menu_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teaching_management_screen.dart';
import '../../main.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_textstyle.dart';
import 'class_menu_screens/classes.dart';
import 'class_menu_screens/exam_list_screen.dart';
import 'class_menu_screens/class_menu_details_screen/exam_details_screen.dart';
import 'class_menu_screens/grade_screen.dart';
import 'parent_student_info_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((response) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);

      if (studentParentTeacherController?.currentLoggedInUserRole ==
          RoleType.teacher) {
        studentParentTeacherController?.getListOfClassesAssignToTeacher(
            showLoader: false);
      }
    });

    // Escuchar cambios en pendingDeepLink en tiempo real
    ever(pendingDeepLink, (String destination) {
      if (destination.isEmpty) return;
      final String eid = pendingEid.value;
      final String classId = pendingClassId.value;
      pendingDeepLink.value = '';
      pendingEid.value = '';
      pendingClassId.value = '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleDeepLink(destination, eid: eid, classId: classId);
      });
    });
  }

  void _handleDeepLink(String destination, {String? eid, String? classId}) {
    if (studentParentTeacherController == null) return;

    final RoleType role =
        studentParentTeacherController!.currentLoggedInUserRole ?? RoleType.student;

    // Si hay eid, navegar directamente al detalle del examen
    if (destination == "exams" && eid != null && eid.isNotEmpty) {
      Get.to(() => ExamDetailScreen(id: eid));
      return;
    }

    // Si hay classId, navegar a las notas del alumno en esa clase
    if (destination == "grades" && classId != null && classId.isNotEmpty) {
      final userdata = AppSharedPreferences.getUserData();
      final List<StudentData> hijos = (userdata?.studentData ?? [])
          .where((s) => s.classId == classId)
          .toList();
      if (hijos.length == 1) {
        Get.to(() => GradeScreen(hijos[0].classId ?? "", hijos[0].wpUsrId ?? ""));
        return;
      } else if (hijos.length > 1) {
        studentParentTeacherController!.setCurrentBottomIndexSelected(index: 3);
        return;
      }
    }

    // Índices menú inferior por rol:
    // Alumno  : 0=Escritorio, 1=Comunicaciones, 2=Padres,    3=Clases,          4=Eventos
    // Padre   : 0=Escritorio, 1=Circulares,     2=Comunic.,  3=Alumnos, 4=Clases, 5=Eventos
    // Profesor: 0=Escritorio, 1=Comunicaciones, 2=Clases,    3=Gestión docente,  4=Eventos
    int tabIndex = 0;

    if (destination == "events") {
      tabIndex = role == RoleType.parent ? 5 : 4;
    } else if (destination == "circular") {
      tabIndex = role == RoleType.parent ? 1 : 0;
    } else if (destination == "messages") {
      tabIndex = role == RoleType.parent ? 2 : 1;
      studentParentTeacherController!.setCurrentSelectedMessageType(
          currentSelectedMessageListType: "Recibidas");
    } else if (destination == "exams" || destination == "grades") {
      tabIndex = 3; // Clases/Alumnos/Gestión docente en todos los roles
    }

    studentParentTeacherController!.setCurrentBottomIndexSelected(index: tabIndex);
  }

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
                  : appController.currentLoggedInUserRole == RoleType.parent
                      ? appController.currentBottomIndexSelected == 0
                          ? 'desk'.tr
                          : appController.currentBottomIndexSelected == 1
                              ? "circular".tr
                              : appController.currentBottomIndexSelected == 2
                                  ? "message".tr
                                  : appController
                                              .currentBottomIndexSelected ==
                                          3
                                      ? "student".tr
                                      : appController
                                                  .currentBottomIndexSelected ==
                                              4
                                          ? "classes".tr
                                          : "events".tr
                      : appController.currentBottomIndexSelected == 0
                          ? 'desk'.tr
                          : appController.currentBottomIndexSelected == 1
                              ? "message".tr
                              : appController.currentBottomIndexSelected == 2
                                  ? "classes".tr
                                  : appController.currentBottomIndexSelected ==
                                          3
                                      ? "Gestión docente"
                                      : "events".tr,
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            );
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
                  color: AppColors.secondary.withValues(alpha: 0.10),
                  blurRadius: 10)
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Consumer<StudentParentTeacherController>(
          builder: (context, appController, child) {
            return BottomNavigationBar(
                backgroundColor: AppColors.transparent,
                currentIndex: appController.currentBottomIndexSelected,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                elevation: 0,
                onTap: (index) {
                  appController.setIsLoading(isLoading: false);
                  appController.setCurrentBottomIndexSelected(index: index);
                },
                unselectedItemColor: AppColors.greyColor,
                selectedItemColor: AppColors.primary,
                type: BottomNavigationBarType.fixed,
                items:
                    appController.currentLoggedInUserRole == RoleType.student
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
                                RoleType.parent
                            ? AppConstants.bottomNavigationBarParent.map((e) {
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
                            : AppConstants.bottomNavigationBarTeacher.map((e) {
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
                              }).toList());
          },
        ),
      ),
      drawer: Consumer<StudentParentTeacherController>(
        builder: (context, studentParentTeacherController, child) {
          return CustomDrawerWidget(
              studentParentTeacherController: studentParentTeacherController);
        },
      ),
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
              : appController.currentLoggedInUserRole == RoleType.parent
                  ? appController.currentBottomIndexSelected == 0
                      ? const DashboardScreen()
                      : appController.currentBottomIndexSelected == 1
                          ? const CircularScreen()
                          : appController.currentBottomIndexSelected == 2
                              ? const MessageScreen(studentOrParent: "0")
                              : appController.currentBottomIndexSelected == 3
                                  ? const ParentStudentInfo()
                                  : appController.currentBottomIndexSelected ==
                                          4
                                      ? const ClassesScreen()
                                      : const EventScreen()
                  : appController.currentBottomIndexSelected == 0
                      ? const DashboardScreen()
                      : appController.currentBottomIndexSelected == 1
                          ? const MessageScreen(studentOrParent: "0")
                          : appController.currentBottomIndexSelected == 2
                              ? const TeacherClassMenuScreen()
                              : appController.currentBottomIndexSelected == 3
                                  ? const TeachingManagementScreen()
                                  : const EventScreen();
        },
      ),
    ));
  }
}
