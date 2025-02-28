import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/teacher/teacher_marks_list_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/teacher_view_add_edit_marks_bottom_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';

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
          studentParentTeacherController?.setViewOrAddEditMarks(
              viewOrAddEditMarks: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: Text(
              'grades'.tr,
              style: AppTextStyle.getOutfit600(
                  textSize: 20, textColor: AppColors.white),
            ),
            actionIcons: [
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return Visibility(
                      visible:
                          studentParentTeacherController.viewOrAddEditMarks ==
                              1,
                      child: GestureDetector(
                        onTap: () async {
                          if (studentParentTeacherController
                              .listOfMarksItem.isNotEmpty) {
                            await studentParentTeacherController.addEditMarks(
                                classId: studentParentTeacherController
                                        .currentSelectedClass?.cid ??
                                    "",
                                subjectId: studentParentTeacherController
                                        .viewMarkSubjectSelected?.id ??
                                    "",
                                examId: studentParentTeacherController
                                        .viewMarkSelectedExam?.eid ??
                                    "");
                          } else {
                            AppConstants.showCustomToast(
                                status: false, message: "Sin datos");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Actualizar',
                              style: AppTextStyle.getOutfit500(
                                  textSize: 16, textColor: AppColors.white),
                            ),
                          ),
                        ),
                      ));
                },
              )
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
              studentParentTeacherController?.setViewOrAddEditMarks(
                  viewOrAddEditMarks: null);

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
                    ),
                    padding: const EdgeInsets.all(10).copyWith(bottom: 20),
                    child: Row(
                      children: [
                        // Expanded(
                        //     child: CustomTextField(
                        //         hintText: "buscar almunos",
                        //         filledColor: AppColors.white,
                        //         validateFunction: (String? value) {})),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        Expanded(
                            child: GestureDetector(
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
                                "Gestionar",
                                style: AppTextStyle.getOutfit400(
                                    textSize: 16, textColor: AppColors.white),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                      return Visibility(
                          visible: studentParentTeacherController
                                      .viewOrAddEditMarks !=
                                  null &&
                              studentParentTeacherController
                                      .viewOrAddEditMarks ==
                                  1,
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "${studentParentTeacherController.currentSelectedClass?.cName ?? ""}-${studentParentTeacherController.viewMarkSubjectSelected?.subName ?? ""}-${studentParentTeacherController.viewMarkSelectedExam?.eName ?? ""}",
                              style: AppTextStyle.getOutfit400(
                                  textSize: 18, textColor: AppColors.secondary),
                            ),
                          ));
                    },
                  ),
                  Expanded(
                      child: ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(overscroll: false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(top: 20),
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
                              : studentParentTeacherController
                                          .viewOrAddEditMarks ==
                                      0
                                  ? ScrollConfiguration(
                                      behavior: ScrollBehavior()
                                          .copyWith(overscroll: false),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TabularViewOfMarks(),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ))
                                  : studentParentTeacherController.isLoading
                                      ? SizedBox.shrink()
                                      : ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 20,
                                            );
                                          },
                                          itemCount:
                                              studentParentTeacherController
                                                  .listOfMarksItem.length,
                                          itemBuilder: (context, index) {
                                            MarksItem marksItem =
                                                studentParentTeacherController
                                                    .listOfMarksItem[index];
                                            return MarksEditViewWidget(
                                              marksItem: marksItem,
                                              marksController:
                                                  studentParentTeacherController
                                                          .listOfMarksController[
                                                      index],
                                              observedController:
                                                  studentParentTeacherController
                                                          .listOfObserverController[
                                                      index],
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
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(marksItem?.studentImage ?? ""),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "${marksItem?.studentLastName ?? ""}\t${marksItem?.studentFirstName ?? ""}",
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
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                      validateFunction: (String? value) {})
                ],
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                          validateFunction: (String? value) {})
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class TabularViewOfMarks extends StatefulWidget {
  const TabularViewOfMarks({super.key});

  @override
  State<TabularViewOfMarks> createState() => _TabularViewOfMarksState();
}

class _TabularViewOfMarksState extends State<TabularViewOfMarks> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentParentTeacherController>(
      builder: (context, studentParentTeacherController, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 2, color: AppColors.secondary),
                    bottom: BorderSide(width: 0, color: AppColors.secondary),
                    right: BorderSide(width: 2, color: AppColors.secondary),
                    left: BorderSide(width: 2, color: AppColors.secondary)),
                color: AppColors.orange,
              ),
              child: Text(
                "${studentParentTeacherController.currentSelectedClass?.cName ?? ""}-${studentParentTeacherController.viewMarkSubjectSelected?.subName ?? ""}-${studentParentTeacherController.viewMarkSelectedExam?.eName ?? ""}",
                style: AppTextStyle.getOutfit400(
                    textSize: 18, textColor: AppColors.secondary),
              ),
            ),
            Table(
              columnWidths: {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1)
              },
              border: TableBorder(
                  top: BorderSide(width: 2, color: AppColors.secondary),
                  bottom: BorderSide(width: 2, color: AppColors.secondary),
                  right: BorderSide(width: 2, color: AppColors.secondary),
                  left: BorderSide(width: 2, color: AppColors.secondary),
                  verticalInside:
                      BorderSide(width: 1, color: AppColors.secondary),
                  horizontalInside:
                      BorderSide(width: 1, color: AppColors.secondary)),
              children: [
                ...studentParentTeacherController.listOfMarksItem.map((e) {
                  return TableRow(children: [
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "${e.studentLastName ?? ""}\t${e.studentFirstName ?? ""}",
                            style: AppTextStyle.getOutfit500(
                                textSize: 16, textColor: AppColors.secondary),
                          ),
                        )),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(
                          child: Text(
                            e.mark == null || e.mark!.isEmpty
                                ? "-"
                                : e.mark ?? "",
                            style: AppTextStyle.getOutfit400(
                                textSize: 16, textColor: AppColors.secondary),
                          ),
                        )),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: IconButton(
                            onPressed: () {
                              if (e.remarks == null || e.remarks!.isEmpty) {
                                AppConstants.showCustomToast(
                                    status: false, message: "No Observaciones");
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ObservationDialog(
                                          observations: e.remarks ?? "");
                                    });
                              }
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: e.remarks == null || e.remarks!.isEmpty
                                  ? AppColors.secondary
                                  : AppColors.red,
                            )))
                  ]);
                })
              ],
            )
          ],
        );
      },
    );
  }
}

class ObservationDialog extends StatelessWidget {
  final String observations;

  const ObservationDialog({super.key, required this.observations});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Observaciones",
                            style: AppTextStyle.getOutfit400(
                                textSize: 18, textColor: AppColors.secondary),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.close,
                                color: AppColors.white,
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(observations,
                          style: AppTextStyle.getOutfit400(
                              textSize: 16, textColor: AppColors.secondary)),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
