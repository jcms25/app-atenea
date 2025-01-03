import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/exam_list_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:colegia_atenea/views/custom_widgets/dialog_boxes_widgets/subject_list_dialog.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';

class TeacherAddEditExamScreen extends StatefulWidget {
  const TeacherAddEditExamScreen({super.key});

  @override
  State<TeacherAddEditExamScreen> createState() =>
      _TeacherAddEditExamScreenState();
}

class _TeacherAddEditExamScreenState extends State<TeacherAddEditExamScreen> {
  final GlobalKey<FormState> _addEditExamFormKey = GlobalKey<FormState>();
  StudentParentTeacherController? studentParentTeacherController;
  Map<String, dynamic>? arguments;

  TextEditingController? nameOfExamController;
  TextEditingController? comments;
  ExamListItem? examListItem;

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    examListItem = arguments?['edit-exam'];
    nameOfExamController = TextEditingController(text: examListItem?.eName);
    comments = TextEditingController(text: examListItem?.comments);
    initializeDateFormatting(Get.locale!.languageCode, null);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);

      if (studentParentTeacherController
              ?.listOfClassAssignToTeacher.isNotEmpty ??
          false) {
        studentParentTeacherController?.setCurrentSelectedClass(
            teacherClass:
                studentParentTeacherController?.listOfClassAssignToTeacher[0]);
        studentParentTeacherController?.getListOfSubjects(
            classId: studentParentTeacherController
                    ?.listOfClassAssignToTeacher[0].cid ??
                "",
            wpId: null,
            roleType: RoleType.teacher);
      } else {
        studentParentTeacherController?.getListOfClassesAssignToTeacher(
            showLoader: true,
            fromWhere: examListItem == null ? null : 9
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, on) {
          studentParentTeacherController?.resetExamData();
          studentParentTeacherController?.setIsLoading(isLoading: false);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: Text(
              arguments?['reason'] == "add-exam"
                  ? 'Agregar examen'
                  : 'Editar examen',
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
            onLeadingIconClicked: () {
              studentParentTeacherController?.resetExamData();
              studentParentTeacherController?.setIsLoading(isLoading: false);
              Get.back();
            },
          ),
          body: Stack(
            children: [
              ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: Form(
                      key: _addEditExamFormKey,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clase'.tr,
                                style: AppTextStyle.getOutfit400(
                                    textSize: 18,
                                    textColor: AppColors.secondary),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TeacherClassListDropdown(
                                fromWhichScreen: 4,
                                height: 60,
                                backgroundColor:
                                    AppColors.secondary.withOpacity(0.06),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nombre del examen/trabajo",
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextField(
                                      controller: nameOfExamController,
                                      validateFunction: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return "Se requiere el título del examen";
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha de inicio del examen/trabajo',
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          DateTime? dateTime =
                                              await studentParentTeacherController
                                                  .pickDate();
                                          studentParentTeacherController
                                              .setExamStartDate(
                                                  dateTime: dateTime);
                                          studentParentTeacherController.setExamEndDate(dateTime: dateTime);
                                        },
                                        child: Container(
                                          height: 60,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.secondary
                                                  .withOpacity(0.06)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                  studentParentTeacherController
                                                      .examStartDate),
                                              textAlign: TextAlign.left,
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 18,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha final de examen/trabajo',
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          DateTime? dateTime =
                                              await studentParentTeacherController
                                                  .pickDate(startDate: studentParentTeacherController.examStartDate);
                                          studentParentTeacherController
                                              .setExamEndDate(
                                                  dateTime: dateTime);
                                        },
                                        child: Container(
                                          height: 60,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.secondary
                                                  .withOpacity(0.06)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                  studentParentTeacherController
                                                      .examEndDate),
                                              textAlign: TextAlign.left,
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 18,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Horas',
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? time =
                                              await studentParentTeacherController
                                                  .pickTime();
                                          studentParentTeacherController
                                              .setExamTime(examTime: time);
                                        },
                                        child: Container(
                                          height: 60,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.secondary
                                                  .withOpacity(0.06)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${studentParentTeacherController.examTime.hour}:${studentParentTeacherController.examTime.minute < 10 ? "0${studentParentTeacherController.examTime.minute}" : studentParentTeacherController.examTime.minute}",
                                              textAlign: TextAlign.left,
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 18,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "subject".tr,
                                style: AppTextStyle.getOutfit400(
                                    textSize: 18,
                                    textColor: AppColors.secondary),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Consumer<StudentParentTeacherController>(
                                builder: (context,
                                    studentParentTeacherController, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SubjectListDialog();
                                          });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.secondary
                                              .withOpacity(0.06)),
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Seleccionar Asignaturas',
                                          style: AppTextStyle.getOutfit400(
                                              textSize: 18,
                                              textColor: AppColors.secondary),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Consumer<StudentParentTeacherController>(
                                builder: (context,
                                    studentParentTeacherController, child) {
                                  return Text(
                                    studentParentTeacherController
                                        .listOfSelectedSubjectsId
                                        .map((e) {
                                          return e.subName ?? "";
                                        })
                                        .toList()
                                        .join(","),
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 14,
                                        textColor: AppColors.secondary),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Comentarios",
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextField(
                                      controller: comments,
                                      validateFunction: (String? value) {}),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 100,
                                  child:
                                      Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return CustomButtonWidget(
                                          buttonTitle:
                                              arguments?['reason'] == "add-exam"
                                                  ? 'Agregar'
                                                  : 'Editar',
                                          onPressed: () async{
                                            if (_addEditExamFormKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              if (studentParentTeacherController
                                                  .listOfSelectedSubjectsId
                                                  .isNotEmpty) {
                                               await studentParentTeacherController.addEditExam(
                                                    classId: studentParentTeacherController.currentSelectedClass?.cid ??
                                                        "",
                                                    examName: nameOfExamController?.text ?? "",
                                                    startDateOfExam:
                                                        studentParentTeacherController
                                                            .examStartDate
                                                            .toString(),
                                                    endDateOfExam:
                                                        studentParentTeacherController
                                                            .examEndDate
                                                            .toString(),
                                                    examTime: studentParentTeacherController
                                                                .examTime
                                                                .minute <
                                                            10
                                                        ? "${studentParentTeacherController.examTime.hour}:0${studentParentTeacherController.examTime.minute}"
                                                        : "${studentParentTeacherController.examTime.hour}:${studentParentTeacherController.examTime.minute}",
                                                    comments:
                                                        comments?.text ?? "",
                                                    subjects: studentParentTeacherController.listOfSelectedSubjectsId);
                                              } else {
                                                AppConstants.showCustomToast(
                                                    status: false,
                                                    message:
                                                        "Por favor seleccione asignaturas");
                                              }
                                            }
                                          });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ))),
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

  @override
  void dispose() {
    if (!mounted) {
      nameOfExamController?.dispose();
      comments?.dispose();
    }
    super.dispose();
  }
}

class AddEditExamWidget extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const AddEditExamWidget(
      {super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getOutfit400(
              textSize: 18, textColor: AppColors.secondary),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
            controller: controller, validateFunction: (String? value) {}),
      ],
    );
  }
}
