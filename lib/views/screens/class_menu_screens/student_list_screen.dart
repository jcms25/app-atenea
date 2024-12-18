import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/student_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentScreenChild();
}

class _StudentScreenChild extends State<StudentListScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  Map<String, dynamic>? arguments;

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      if (arguments?['role'] == RoleType.teacher) {
        if (studentParentTeacherController
                ?.listOfClassAssignToTeacher.isNotEmpty ??
            false) {
          studentParentTeacherController?.setCurrentSelectedClass(
              teacherClass: studentParentTeacherController
                  ?.listOfClassAssignToTeacher[0]);
          studentParentTeacherController?.getListOfStudents(
              classId:
                  studentParentTeacherController?.currentSelectedClass?.cid ??
                      "",
              roleType: arguments?['role'],
              sortedAccordingToLastName: true);
        }
      } else {
        studentParentTeacherController?.getListOfStudents(
            classId: arguments?['role'] == RoleType.teacher
                ? studentParentTeacherController?.currentSelectedClass?.cid ??
                    ""
                : arguments?['classId'] ?? "",
            roleType: arguments?['role'],
            sortedAccordingToLastName: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (result, ctx) {
          studentParentTeacherController?.setListOfStudents(listOfStudents: []);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBarWidget(
              title: Text(
                  arguments?['role'] == RoleType.teacher
                      ? "student".tr
                      : "${"student".tr} de ${arguments?['className']}",
                  style: AppTextStyle.getOutfit500(
                      textSize: 20, textColor: AppColors.white)),
              onLeadingIconClicked: () {
                studentParentTeacherController
                    ?.setListOfStudents(listOfStudents: []);
                Get.back();
              },
              actionIcons: [
                Visibility(
                    visible: arguments?['role'] == RoleType.teacher,
                    child: Expanded(
                        child: TeacherClassListDropdown(fromWhichScreen: 1)))
              ],
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: AppColors.primary),
                        child: Container(
                          // height: 50,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Consumer<StudentParentTeacherController>(
                            builder: (context, studentParentTeacherController,
                                child) {
                              return TextField(
                                autofocus: false,
                                decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.search,
                                        color: AppColors.searchIcon,
                                      ),
                                      onPressed: () {},
                                    ),
                                    hintText: 'searchInList'.tr,
                                    hintStyle: AppTextStyle.getOutfit400(
                                        textSize: 16,
                                        textColor: AppColors.secondary
                                            .withOpacity(0.5)),
                                    border: InputBorder.none),
                                cursorHeight: 25,
                                cursorColor: AppColors.primary,
                                //style: txtValueStyle,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: studentParentTeacherController
                                    .searchInStudentList,
                              );
                            },
                          ),
                        )),
                    Expanded(
                        child: ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
                            child: Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return studentParentTeacherController
                                        .tempListOfStudents.isNotEmpty
                                    ? ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            studentParentTeacherController
                                                .tempListOfStudents.length,
                                        itemBuilder: (context, position) {
                                          StudentItem student =
                                              studentParentTeacherController
                                                  .tempListOfStudents[position];
                                          return StudentItemWidget(
                                              studentItem: student);
                                        })
                                    : Center(
                                        child: Text(
                                          'noStudentFound'.tr,
                                          style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),
                                        ),
                                      );
                              },
                            )))
                  ],
                ),
                Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                  return Visibility(
                      visible: studentParentTeacherController.isLoading,
                      child: const LoadingLayout());
                })
              ],
            )));
  }
}

class StudentItemWidget extends StatelessWidget {
  final StudentItem studentItem;

  const StudentItemWidget({super.key, required this.studentItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => StudentDetails(
              sid: studentItem.wpUsrId ?? "",
              pValue: '',
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            // height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(studentItem.stuImage!),
                  backgroundColor: AppColors.primary,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(studentItem.sFname ?? "",
                          style: AppTextStyle.getOutfit600(
                              textSize: 20, textColor: AppColors.secondary)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(studentItem.sLname ?? "",
                          style: AppTextStyle.getOutfit400(
                              textSize: 14, textColor: AppColors.secondary)),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.message,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(studentItem.stuEmail ?? "",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 14,
                                      textColor: AppColors.secondary))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
