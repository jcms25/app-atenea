import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/exam_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/exam_details_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_add_edit_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({
    super.key,
  });

  @override
  State<ExamListScreen> createState() => ExamListScreenState();
}

class ExamListScreenState extends State<ExamListScreen> {
  Map<String, dynamic>? arguments;

  StudentParentTeacherController? studentParentTeacherController;

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
          studentParentTeacherController?.getListOfExams(
              classId:
                  studentParentTeacherController?.currentSelectedClass?.cid ??
                      "",
              wpUserId: "",
              roleType: RoleType.teacher);
        } else {
          studentParentTeacherController?.getListOfClassesAssignToTeacher(
              showLoader: true, fromWhere: 8);
        }
      } else {
        studentParentTeacherController?.getListOfExams(
            classId: arguments?['classId'] ?? "",
            wpUserId: arguments?['wpUserId'] ?? "",
            roleType: arguments?['role']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, res) {
          studentParentTeacherController?.setIsLoading(isLoading: false);
          studentParentTeacherController?.setListOfExams(listOfExams: []);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBarWidget(
            title: Text(
              "tests".tr,
              style: AppTextStyle.getOutfit600(
                  textSize: 20, textColor: AppColors.white),
            ),
            onLeadingIconClicked: () {
              studentParentTeacherController?.setIsLoading(isLoading: false);
              studentParentTeacherController?.setListOfExams(listOfExams: []);
              Get.back();
            },
            actionIcons: [
              Visibility(
                  visible: arguments?['role'] == RoleType.teacher,
                  child: Expanded(
                      child: TeacherClassListDropdown(fromWhichScreen: 6)))
            ],
          ),
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: AppColors.primary),
                    padding: const EdgeInsets.all(20),
                    child: Consumer<StudentParentTeacherController>(
                      builder:
                          (context, studentParentTeacherController, child) {
                        return CustomTextField(
                          hintText: 'Buscar exámenes',
                          filledColor: AppColors.white,
                          validateFunction: (String? value) {},
                          onTextChanged:
                              studentParentTeacherController.searchInExamList,
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return studentParentTeacherController
                                  .tempListOfExams.isEmpty
                              ? Center(
                                  child: Text(
                                    "No se encontraron exámenes",
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        // textColor: AppColors.secondary
                                        //     .withOpacity(0.5)
                                        textColor: AppColors.secondary.withValues(alpha: 0.5)
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 20,
                                    );
                                  },
                                  itemCount: studentParentTeacherController
                                      .tempListOfExams.length,
                                  itemBuilder: (context, index) {
                                    ExamListItem examListItem =
                                        studentParentTeacherController
                                            .tempListOfExams[index];
                                    return ExamItemWidget(
                                        examListItem: examListItem);
                                  });
                        },
                      ),
                    ),
                  )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return Visibility(
                      visible: studentParentTeacherController.isLoading,
                      child: LoadingLayout());
                },
              )
            ],
          ),
          floatingActionButton: Consumer<StudentParentTeacherController>(
            builder: (context, studentParentTeacherController, child) {
              return Visibility(
                  visible: studentParentTeacherController.currentLoggedInUserRole == RoleType.teacher,
                  child: FloatingActionButton(
                onPressed: () {
                  Get.to(() => TeacherAddEditExamScreen(),
                      arguments: {"reason": "add-exam"});
                },
                elevation: 0,
                child: Icon(Icons.add),
              ));
            },
          ),
        ));
  }
}

class ExamItemWidget extends StatelessWidget {
  final ExamListItem examListItem;

  const ExamItemWidget({super.key, required this.examListItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: AppColors.primary.withOpacity(0.05)
          color: AppColors.primary.withValues(alpha: 0.05)
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              Get.to(() => ExamDetailScreen(
                    id: examListItem.eid ?? "",
                    sID: examListItem.subjectId ?? "",
                    professorName: examListItem.professorName ?? "",
                    subjectName: examListItem.subName ?? "-   ",
                  ));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  constraints: BoxConstraints(minHeight: 60),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${DateTime.parse(examListItem.eSDate ?? "").day}",
                        style: AppTextStyle.getOutfit900(
                            textSize: 32, textColor: AppColors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${AppConstants.getMonthInSpan(DateTime.parse(examListItem.eSDate ?? "").month).length > 5 ? AppConstants.getMonthInSpan(DateTime.parse(examListItem.eSDate ?? "").month).substring(0, 3) : AppConstants.getMonthInSpan(DateTime.parse(examListItem.eSDate ?? "").month)}\t${DateTime.parse(examListItem.eSDate ?? "").year}",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.getOutfit300(
                            textSize: 14, textColor: AppColors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
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
                      examListItem.eName ?? "-",
                      style: AppTextStyle.getOutfit600(
                          textSize: 20, textColor: AppColors.secondary),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      examListItem.subName ?? "-",
                      style: AppTextStyle.getOutfit400(
                          textSize: 18, textColor: AppColors.secondary),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      examListItem.time ?? "-",
                      style: AppTextStyle.getOutfit400(
                          textSize: 18, textColor: AppColors.secondary),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )),
              ],
            ),
          )),
          const SizedBox(
            width: 10,
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context, studentParentController, child) {
              return Visibility(
                  visible: studentParentController.currentLoggedInUserRole ==
                          RoleType.teacher &&
                      examListItem.createdBy ==
                          studentParentController.userdata?.wpUsrId,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => TeacherAddEditExamScreen(),
                          arguments: {
                          "reason": "edit-exam",
                          "exam-data" : examListItem
                          });
                    },
                    child: SvgPicture.asset(
                      AppImages.edit,
                      colorFilter:
                          ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                      width: 20,
                      height: 20,
                    ),
                  ));
            },
          )
        ],
      ),
    );
  }
}
