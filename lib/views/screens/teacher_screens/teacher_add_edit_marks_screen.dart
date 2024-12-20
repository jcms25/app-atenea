import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/teacher/teacher_marks_list_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/teacher_view_marks_bottom_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class TeacherAddEditMarksScreen extends StatefulWidget {
  const TeacherAddEditMarksScreen({super.key});

  @override
  State<TeacherAddEditMarksScreen> createState() =>
      _TeacherAddEditMarksScreenState();
}

class _TeacherAddEditMarksScreenState extends State<TeacherAddEditMarksScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      if (studentParentTeacherController
              ?.listOfClassAssignToTeacher.isNotEmpty ??
          false) {
        studentParentTeacherController?.setCurrentSelectedClass(
            teacherClass:
                studentParentTeacherController?.listOfClassAssignToTeacher[0]);

        if (studentParentTeacherController?.currentSelectedClass != null) {
          String classId =
              studentParentTeacherController?.currentSelectedClass?.cid ?? "";
          studentParentTeacherController?.getListOfSubjects(
              classId: classId, wpId: null, roleType: RoleType.teacher);
          studentParentTeacherController?.getListOfExams(
              classId: classId, wpUserId: null, roleType: RoleType.teacher);
        }
      } else {
        studentParentTeacherController?.getListOfClassesAssignToTeacher(
            showLoader: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, res) {
          studentParentTeacherController?.setIsLoading(isLoading: false);
          studentParentTeacherController?.setListOfMarks(listOfMarksItem: []);
          studentParentTeacherController
              ?.setListOfMarksController(listOfMarksController: []);
          studentParentTeacherController
              ?.setListOfObserverController(listOfObserverController: []);
          studentParentTeacherController?.setListOfExams(listOfExams: []);
          studentParentTeacherController?.setListOfSubject(listOfSubject: []);
          studentParentTeacherController?.setViewMarkSubjectSelected(
              subjectItem: null);
          studentParentTeacherController?.setViewMarkExamSelected(
              examListItem: null);
          studentParentTeacherController
              ?.setListOfExamBasedOnSubjects(listOfExams: []);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: Text(
              'grades'.tr,
              style: AppTextStyle.getOutfit600(
                  textSize: 20, textColor: AppColors.white),
            ),
            actionIcons: [
              // Consumer<StudentParentTeacherController>(
              //   builder: (context,studentParentTeacherController,child){
              //     return IconButton(onPressed: (){
              //     }, icon: Icon(Icons.done));
              //   },
              // )
            ],
            onLeadingIconClicked: () {
              studentParentTeacherController?.setIsLoading(isLoading: false);
              studentParentTeacherController
                  ?.setListOfMarks(listOfMarksItem: []);
              studentParentTeacherController
                  ?.setListOfMarksController(listOfMarksController: []);
              studentParentTeacherController
                  ?.setListOfObserverController(listOfObserverController: []);
              studentParentTeacherController?.setListOfExams(listOfExams: []);
              studentParentTeacherController
                  ?.setListOfSubject(listOfSubject: []);
              studentParentTeacherController?.setViewMarkSubjectSelected(
                  subjectItem: null);
              studentParentTeacherController?.setViewMarkExamSelected(
                  examListItem: null);
              studentParentTeacherController
                  ?.setListOfExamBasedOnSubjects(listOfExams: []);
              Get.back();
            },
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    padding: const EdgeInsets.all(10).copyWith(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomTextField(
                                hintText: "buscar almunos",
                                filledColor: AppColors.white,
                                validateFunction: (String? value) {})),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                backgroundColor: AppColors.transparent,
                                builder: (context) {
                                  return TeacherViewMarksBottomSheet();
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(minHeight: 60),
                            child: Center(
                              child: Text(
                                "Ver datos",
                                style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(overscroll: false),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return studentParentTeacherController
                                  .listOfMarksItem.isEmpty
                              ? Center(
                                  child: Text(
                                    "No se encontraron datos",
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 16,
                                        textColor: AppColors.secondary),
                                  ),
                                )
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 20,
                                    );
                                  },
                                  itemCount: studentParentTeacherController
                                      .listOfMarksItem.length,
                                  itemBuilder: (context, index) {
                                    MarksItem marksItem =
                                        studentParentTeacherController
                                            .listOfMarksItem[index];
                                    return MarksEditViewWidget(
                                      marksItem: marksItem,
                                      marksController:
                                          studentParentTeacherController
                                              .listOfMarksController[index],
                                      observedController:
                                          studentParentTeacherController
                                              .listOfObserverController[index],
                                    );
                                  });
                        },
                      ),
                    ),
                  ))
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
        ));
  }
}

class MarksEditViewWidget extends StatelessWidget {
  final MarksItem? marksItem;
  final TextEditingController? marksController;
  final TextEditingController? observedController;

  const MarksEditViewWidget(
      {super.key,
      this.marksItem,
      this.marksController,
      this.observedController});

  @override
  Widget build(BuildContext context) {
    marksController?.text = marksItem?.mark ?? "";
    observedController?.text = marksItem?.remarks ?? "";

    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: AppColors.color10, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: Text(
                    marksItem?.studentRollNo ?? "-",
                    style: AppTextStyle.getOutfit300(
                        textSize: 14, textColor: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  marksItem?.studentName ?? "-",
                  textAlign: TextAlign.left,
                  style: AppTextStyle.getOutfit500(
                      textSize: 18, textColor: AppColors.secondary),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'grades'.tr,
            style: AppTextStyle.getOutfit400(
                textSize: 16, textColor: AppColors.secondary),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
              controller: marksController,
              validateFunction: (String? value) {}),
          const SizedBox(
            height: 10,
          ),
          Text(
            'obser'.tr,
            style: AppTextStyle.getOutfit400(
                textSize: 16, textColor: AppColors.secondary),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
              controller: observedController,
              validateFunction: (String? value) {}),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
