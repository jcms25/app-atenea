import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/get_teacher_list_send_message_model.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/teacher/parent_list_model.dart';

class MessageSendScreen extends StatefulWidget {
  final RoleType roleType;
  final String? teacherId;

  const MessageSendScreen({super.key, this.teacherId, required this.roleType});

  @override
  State<StatefulWidget> createState() {
    return _MessageSendScreenChild();
  }
}

class _MessageSendScreenChild extends State<MessageSendScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      if (widget.roleType != RoleType.teacher) {
        studentParentTeacherController?.getListOfTeacherForMessageSend(
            teacherId: widget.teacherId);
      } else {
        if (studentParentTeacherController
                ?.listOfClassAssignToTeacher.isNotEmpty ??
            false) {
          studentParentTeacherController?.setCurrentSelectedClass(
              teacherClass: studentParentTeacherController
                  ?.listOfClassAssignToTeacher[0]);
          if (studentParentTeacherController?.listOfStudents.isEmpty ?? true) {
            studentParentTeacherController?.getListOfStudents(
                classId: studentParentTeacherController
                        ?.listOfClassAssignToTeacher[0].cid ??
                    "",
                roleType: RoleType.teacher,
                sortedAccordingToLastName: false);
            studentParentTeacherController?.getListOfParents(
                classId: studentParentTeacherController
                        ?.listOfClassAssignToTeacher[0].cid ??
                    "");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController
              ?.setTempListOfStudentFollowedUp(tempListOfStudentFollowedUp: []);
          studentParentTeacherController
              ?.setCurrentSelectedTeacherForMessageSend(
                  currentSelectedTeacherForMessageSend: null);
          studentParentTeacherController?.setSelectedFilePath(
              selectedFilePath: null);
          studentParentTeacherController?.setIsLoading(isLoading: false);

          studentParentTeacherController?.setListOfStudents(listOfStudents: []);
          studentParentTeacherController?.setListOfParents(listOfParents: []);
          studentParentTeacherController?.setCurrentSendingMessageCategory(
              roleType: RoleType.student);
          studentParentTeacherController
              ?.setCurrentSelectedParentForSendMessage(parentItem: null);
          studentParentTeacherController
              ?.setCurrentSelectedStudentForSendMessage(studentItem: null);
        },
        child: Scaffold(
            appBar: CustomAppBarWidget(
                onLeadingIconClicked: () {
                  studentParentTeacherController
                      ?.setTempListOfStudentFollowedUp(
                          tempListOfStudentFollowedUp: []);
                  studentParentTeacherController
                      ?.setCurrentSelectedTeacherForMessageSend(
                          currentSelectedTeacherForMessageSend: null);
                  studentParentTeacherController?.setSelectedFilePath(
                      selectedFilePath: null);
                  studentParentTeacherController?.setIsLoading(
                      isLoading: false);
                  studentParentTeacherController
                      ?.setListOfStudents(listOfStudents: []);
                  studentParentTeacherController
                      ?.setListOfParents(listOfParents: []);
                  studentParentTeacherController
                      ?.setCurrentSendingMessageCategory(
                          roleType: RoleType.student);
                  studentParentTeacherController
                      ?.setCurrentSelectedParentForSendMessage(
                          parentItem: null);
                  studentParentTeacherController
                      ?.setCurrentSelectedStudentForSendMessage(
                          studentItem: null);
                  Get.back();
                },
                title: Text(
                  'sendNewTitle'.tr,
                  style: AppTextStyle.getOutfit500(
                      textSize: 20, textColor: AppColors.white),
                )),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: widget.roleType != RoleType.teacher,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'selectTitle'.tr,
                                  style: AppTextStyle.getOutfit500(
                                      textSize: 18,
                                      textColor: AppColors.secondary),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          AppColors.primary.withOpacity(0.05)),
                                  child:
                                      Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return DropdownButton<
                                          TeacherItemForSendMessage>(
                                        isExpanded: true,
                                        value: studentParentTeacherController
                                            .currentSelectedTeacherForMessageSend,
                                        underline: const SizedBox(),
                                        icon: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                        items: studentParentTeacherController
                                            .teacherListForMessageSend
                                            .map((TeacherItemForSendMessage e) {
                                          return DropdownMenuItem<
                                              TeacherItemForSendMessage>(
                                            value: e,
                                            child: Text(e.teacherName,
                                                style:
                                                    AppTextStyle.getOutfit400(
                                                        textSize: 18,
                                                        textColor: AppColors
                                                            .secondary
                                                            .withOpacity(0.5))),
                                          );
                                        }).toList(),
                                        onChanged:
                                            (TeacherItemForSendMessage? value) {
                                          studentParentTeacherController
                                              .setCurrentSelectedTeacherForMessageSend(
                                                  currentSelectedTeacherForMessageSend:
                                                      value);
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            )),
                        Visibility(
                            visible: widget.roleType == RoleType.teacher,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TeacherClassListDropdown(
                                  fromWhichScreen: 7,
                                  backgroundColor:
                                      AppColors.secondary.withOpacity(0.06),
                                  height: 60,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: RadioListTile<RoleType>(
                                                  value: RoleType.student,
                                                  title: Text(
                                                    'Alumnos',
                                                    style: AppTextStyle
                                                        .getOutfit400(
                                                            textSize: 18,
                                                            textColor: AppColors
                                                                .secondary),
                                                  ),
                                                  groupValue:
                                                      studentParentTeacherController
                                                          .currentSendingMessageCategory,
                                                  onChanged:
                                                      (RoleType? roleType) {
                                                    if (roleType != null) {
                                                      studentParentTeacherController
                                                          .setCurrentSendingMessageCategory(
                                                              roleType:
                                                                  roleType);
                                                    }
                                                  })),
                                          Expanded(
                                              child: RadioListTile<RoleType>(
                                                  value: RoleType.parent,
                                                  title: Text(
                                                    'Padre',
                                                    style: AppTextStyle
                                                        .getOutfit400(
                                                            textSize: 18,
                                                            textColor: AppColors
                                                                .secondary),
                                                  ),
                                                  groupValue:
                                                      studentParentTeacherController
                                                          .currentSendingMessageCategory,
                                                  onChanged:
                                                      (RoleType? roleType) {
                                                    if (roleType != null) {
                                                      // if(studentParentTeacherController.listOfParents.)
                                                      studentParentTeacherController
                                                          .setCurrentSendingMessageCategory(
                                                              roleType:
                                                                  roleType);
                                                    }
                                                  }))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return Text(
                                      studentParentTeacherController
                                                  .currentSendingMessageCategory ==
                                              RoleType.student
                                          ? "Seleccionar Alumno"
                                          : "Seleccionar Padre",
                                      style: AppTextStyle.getOutfit500(
                                          textSize: 18,
                                          textColor: AppColors.secondary),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          AppColors.primary.withOpacity(0.05)),
                                  child:
                                      Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return studentParentTeacherController
                                                  .currentSendingMessageCategory ==
                                              RoleType.student
                                          ? DropdownButton<StudentItem>(
                                              isExpanded: true,
                                              value: studentParentTeacherController
                                                  .currentSelectedStudentForSendMessage,
                                              underline: const SizedBox(),
                                              icon: const Icon(
                                                  Icons.arrow_drop_down_sharp),
                                              items:
                                                  studentParentTeacherController
                                                      .tempListOfStudents
                                                      .map((StudentItem e) {
                                                return DropdownMenuItem<
                                                    StudentItem>(
                                                  value: e,
                                                  child: Text(
                                                      "${e.sFname}\t${e.sLname}",
                                                      style: AppTextStyle
                                                          .getOutfit400(
                                                              textSize: 18,
                                                              textColor: AppColors
                                                                  .secondary
                                                                  .withOpacity(
                                                                      0.5))),
                                                );
                                              }).toList(),
                                              onChanged: (StudentItem? value) {
                                                studentParentTeacherController
                                                    .setCurrentSelectedStudentForSendMessage(
                                                        studentItem: value);
                                              },
                                            )
                                          : DropdownButton<ParentItem>(
                                              isExpanded: true,
                                              value: studentParentTeacherController
                                                  .currentSelectedParentForSendMessage,
                                              underline: const SizedBox(),
                                              icon: const Icon(
                                                  Icons.arrow_drop_down_sharp),
                                              items:
                                                  studentParentTeacherController
                                                      .tempListOfParents
                                                      .map((ParentItem e) {
                                                return DropdownMenuItem<
                                                    ParentItem>(
                                                  value: e,
                                                  child: Text("${e.fullName}",
                                                      style: AppTextStyle
                                                          .getOutfit400(
                                                              textSize: 18,
                                                              textColor: AppColors
                                                                  .secondary
                                                                  .withOpacity(
                                                                      0.5))),
                                                );
                                              }).toList(),
                                              onChanged: (ParentItem? value) {
                                                studentParentTeacherController
                                                    .setCurrentSelectedParentForSendMessage(
                                                        parentItem: value);
                                              },
                                            );
                                    },
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'afTitle'.tr,
                          style: AppTextStyle.getOutfit500(
                              textSize: 18, textColor: AppColors.secondary),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            controller: _subjectController,
                            validateFunction: (String? value) {}),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'msgTitle'.tr,
                          style: AppTextStyle.getOutfit500(
                              textSize: 18, textColor: AppColors.secondary),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            controller: _messageController,
                            maxLine: 5,
                            validateFunction: (String? value) {}),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('attachTitle'.tr,
                            style: AppTextStyle.getOutfit500(
                                textSize: 18, textColor: AppColors.secondary)),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<StudentParentTeacherController>(
                          builder:
                              (context, studentParentTeacherController, child) {
                            return GestureDetector(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  studentParentTeacherController
                                      .setSelectedFilePath(
                                          selectedFilePath:
                                              result.files.single.path ?? "");
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        AppColors.secondary.withOpacity(0.06)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    studentParentTeacherController
                                                .selectedFilePath !=
                                            null
                                        ? studentParentTeacherController
                                            .selectedFilePath!
                                            .split("/")
                                            .last
                                        : "chooseTitle".tr,
                                    textAlign: TextAlign.start,
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
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 100,
                            child: Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return CustomButtonWidget(
                                    buttonTitle: "sendTitle".tr,
                                    onPressed: () async{

                                     await studentParentTeacherController
                                          .sendMessage(
                                              messageSubject:
                                                  _subjectController.text,
                                              description:
                                                  _messageController.text,
                                              whomToSend: studentParentTeacherController
                                                          .currentLoggedInUserRole !=
                                                      RoleType.teacher
                                                  ? 0
                                                  : studentParentTeacherController
                                                              .currentSendingMessageCategory ==
                                                          RoleType.student
                                                      ? 2
                                                      : 1).then((response){
                                        if(response['status']){
                                          Get.back();
                                        }
                                     });
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<StudentParentTeacherController>(
                  builder: (context, studentParentTeacherController, child) {
                    return Visibility(
                        visible: studentParentTeacherController.isLoading,
                        child: LoadingLayout());
                  },
                )
              ],
            )));
  }
}
