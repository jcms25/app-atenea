import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/get_teacher_list_send_message_model.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
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

class MessageSendScreen extends StatefulWidget {
  final RoleType roleType;
  final String? teacherId;
  final String? initialSubject;
  final String? replyId;

  const MessageSendScreen({super.key, this.teacherId, required this.roleType, this.initialSubject, this.replyId});

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
            if (widget.initialSubject != null) {
              _subjectController.text = widget.initialSubject!;
            }
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
                    roleType: RoleType.teacher);
                studentParentTeacherController?.getListOfParents(
                    classId: studentParentTeacherController
                            ?.listOfClassAssignToTeacher[0].cid ??
                        "");
                // Carga la lista jerárquica (alumno → padres) para
                // la vista nueva de envío a padres. Convive con
                // getListOfParents porque la lista plana la sigue
                // usando teacher_parent_list_screen.
                studentParentTeacherController?.getStudentsWithParents(
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
              messageSendingCategoryForTeacher: null);
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
                          messageSendingCategoryForTeacher: null);
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
                ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // color: AppColors.primary
                                          //     .withOpacity(0.05)
                                         color: AppColors.primary.withValues(alpha: 0.05)
                                      ),
                                      child: Consumer<
                                          StudentParentTeacherController>(
                                        builder: (context,
                                            studentParentTeacherController,
                                            child) {
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
                                                .map((TeacherItemForSendMessage
                                                    e) {
                                              return DropdownMenuItem<
                                                  TeacherItemForSendMessage>(
                                                value: e,
                                                child: Text(e.teacherName,
                                                    style: AppTextStyle
                                                        .getOutfit400(
                                                            textSize: 18,
                                                            // textColor: AppColors
                                                            //     .secondary
                                                            //     .withOpacity(
                                                            //         0.5)
                                                            textColor: AppColors.secondary.withValues(alpha: 0.5)
                                                    )),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (TeacherItemForSendMessage?
                                                    value) {
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
                                      // backgroundColor:
                                      //     AppColors.secondary.withOpacity(0.06),
                                      backgroundColor: AppColors.secondary.withValues(alpha: 0.06),
                                      height: 60,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Consumer<StudentParentTeacherController>(
                                      builder: (context,
                                          studentParentTeacherController,
                                          child) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Seleccionar",
                                              style: AppTextStyle.getOutfit500(
                                                  textSize: 18,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 60,
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // color: AppColors.primary
                                                  //     .withOpacity(0.05)
                                                color: AppColors.primary.withValues(alpha: 0.05)

                                              ),
                                              child: DropdownButton<
                                                  MessageSendCategoryForTeacher>(
                                                isExpanded: true,
                                                value: studentParentTeacherController
                                                    .currentSendingMessageCategory,
                                                underline: const SizedBox(),
                                                hint: Text(
                                                  "Seleccionar",
                                                  style:
                                                      AppTextStyle.getOutfit500(
                                                          textSize: 16,
                                                          // textColor: AppColors
                                                          //     .secondary
                                                          //     .withOpacity(
                                                          //         0.5)
                                                        textColor: AppColors.secondary.withValues(alpha: 0.5)
                                                      ),
                                                ),
                                                icon: const Icon(Icons
                                                    .arrow_drop_down_sharp),
                                                items: AppConstants
                                                    .listOfCategoryToTeacherSendMessage
                                                    .map(
                                                        (MessageSendCategoryForTeacher
                                                            e) {
                                                  return DropdownMenuItem<
                                                      MessageSendCategoryForTeacher>(
                                                    value: e,
                                                    child: Text(
                                                        e ==
                                                                MessageSendCategoryForTeacher
                                                                    .student
                                                            ? "Alumnos"
                                                            : e ==
                                                                    MessageSendCategoryForTeacher
                                                                        .parent
                                                                ? "Padres"
                                                                : e ==
                                                                        MessageSendCategoryForTeacher
                                                                            .toAllStudent
                                                                    ? "Todos los Alumnos"
                                                                    : "Todos los Padres",
                                                        style: AppTextStyle
                                                            .getOutfit400(
                                                                textSize: 18,
                                                                // textColor: AppColors
                                                                //     .secondary
                                                                //     .withOpacity(
                                                                //         0.5)
                                                              textColor: AppColors.secondary.withValues(alpha: 0.5)
                                                        )),
                                                  );
                                                }).toList(),
                                                onChanged:
                                                    (MessageSendCategoryForTeacher?
                                                        value) {
                                                  studentParentTeacherController
                                                      .setCurrentSendingMessageCategory(
                                                          messageSendingCategoryForTeacher:
                                                              value);
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Consumer<StudentParentTeacherController>(
                                      builder: (context,
                                          studentParentTeacherController,
                                          child) {
                                        return Visibility(
                                            visible: studentParentTeacherController
                                                        .currentSendingMessageCategory ==
                                                    MessageSendCategoryForTeacher
                                                        .student ||
                                                studentParentTeacherController
                                                        .currentSendingMessageCategory ==
                                                    MessageSendCategoryForTeacher
                                                        .parent,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  studentParentTeacherController
                                                              .currentSendingMessageCategory ==
                                                          MessageSendCategoryForTeacher
                                                              .student
                                                      ? "Seleccionar Alumnos"
                                                      : "Seleccionar Padres",
                                                  style:
                                                      AppTextStyle.getOutfit500(
                                                          textSize: 18,
                                                          textColor: AppColors
                                                              .secondary),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      // color: AppColors.primary
                                                      //     .withOpacity(0.05)
                                                      color: AppColors.primary.withValues(alpha: 0.05)
                                                  ),
                                                  child: Consumer<
                                                      StudentParentTeacherController>(
                                                    builder: (context,
                                                        studentParentTeacherController,
                                                        child) {
                                                      return studentParentTeacherController
                                                                  .currentSendingMessageCategory ==
                                                              MessageSendCategoryForTeacher
                                                                  .student
                                                            ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.stretch,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [                                                                
                                                                // Cabecera: título + botón Limpiar
                                                                // (siempre presente, con visibilidad alternada
                                                                // para que no haya saltos verticales)
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                            studentParentTeacherController.selectedStudentsForSendMessage.isEmpty
                                                                                ? "Seleccionar Alumnos"
                                                                                : "Seleccionados: ${studentParentTeacherController.selectedStudentsForSendMessage.length}",
                                                                            style: AppTextStyle.getOutfit500(
                                                                              textSize: 16,
                                                                              textColor: AppColors.secondary.withValues(alpha: 0.7),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Visibility(
                                                                          visible: studentParentTeacherController
                                                                              .selectedStudentsForSendMessage.isNotEmpty,
                                                                          maintainSize: true,
                                                                          maintainAnimation: true,
                                                                          maintainState: true,
                                                                          child: TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                              minimumSize: Size.zero,
                                                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                            ),
                                                                            onPressed: () {
                                                                              studentParentTeacherController.clearSelectedStudents();
                                                                            },
                                                                            child: Text(
                                                                              "Limpiar",
                                                                              style: AppTextStyle.getOutfit500(
                                                                                textSize: 14,
                                                                                textColor: AppColors.primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Divider(
                                                                      height: 1,
                                                                      thickness: 1,
                                                                      color: AppColors.secondary.withValues(alpha: 0.2),
                                                                    ),
                                                                    ],
                                                                   ),
                                                                   Divider(
                                                                     height: 1,
                                                                     thickness: 1,
                                                                     color: AppColors.secondary.withValues(alpha: 0.2),
                                                                   ),
                                                                   ConstrainedBox(
                                                                  constraints: const BoxConstraints(maxHeight: 220),
                                                                  child: ListView.builder(
                                                                    shrinkWrap: true,
                                                                    itemCount: studentParentTeacherController.tempListOfStudents.length,
                                                                    itemBuilder: (context, index) {
                                                                      final StudentItem e =
                                                                          studentParentTeacherController.tempListOfStudents[index];
                                                                      final bool checked =
                                                                          studentParentTeacherController.isStudentSelected(e);
                                                                      return CheckboxListTile(
                                                                        dense: true,
                                                                        contentPadding: EdgeInsets.zero,
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal: -4, vertical: -4),
                                                                        controlAffinity: ListTileControlAffinity.leading,
                                                                        activeColor: AppColors.primary,
                                                                        value: checked,
                                                                        onChanged: (_) {
                                                                          studentParentTeacherController
                                                                              .toggleSelectedStudent(student: e);
                                                                        },
                                                                        title: Text(
                                                                          "${e.sLname}, ${e.sFname}",
                                                                          style: AppTextStyle.getOutfit400(
                                                                            textSize: 16,
                                                                            textColor: AppColors.secondary,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.stretch,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        studentParentTeacherController.selectedParentIdsForSendMessage.isEmpty
                                                                            ? "Seleccionar Padres"
                                                                            : "Seleccionados: ${studentParentTeacherController.selectedParentIdsForSendMessage.length}",
                                                                        style: AppTextStyle.getOutfit500(
                                                                          textSize: 16,
                                                                          textColor: AppColors.secondary.withValues(alpha: 0.7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible: studentParentTeacherController
                                                                          .selectedParentIdsForSendMessage.isNotEmpty,
                                                                      maintainSize: true,
                                                                      maintainAnimation: true,
                                                                      maintainState: true,
                                                                      child: TextButton(
                                                                        style: TextButton.styleFrom(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                          minimumSize: Size.zero,
                                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                        ),
                                                                        onPressed: () {
                                                                          studentParentTeacherController.clearSelectedParents();
                                                                        },
                                                                        child: Text(
                                                                          "Limpiar",
                                                                          style: AppTextStyle.getOutfit500(
                                                                            textSize: 14,
                                                                            textColor: AppColors.primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  height: 1,
                                                                  thickness: 1,
                                                                  color: AppColors.secondary.withValues(alpha: 0.2),
                                                                ),
                                                                ConstrainedBox(
                                                                  constraints: const BoxConstraints(maxHeight: 220),
                                                                  child: ListView.builder(
                                                                    shrinkWrap: true,
                                                                    itemCount: studentParentTeacherController.studentsWithParents.length,
                                                                    itemBuilder: (context, index) {
                                                                      final s = studentParentTeacherController.studentsWithParents[index];
                                                                      return Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 6, bottom: 2),
                                                                            child: Text(
                                                                              "${s.sLname ?? ''}, ${s.sFname ?? ''}",
                                                                              style: AppTextStyle.getOutfit400(
                                                                                textSize: 15,
                                                                                textColor: AppColors.secondary.withValues(alpha: 0.7),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          ...?s.parents?.map((p) {
                                                                            final id = p.parentWpUsrId ?? "";
                                                                            final bool checked = studentParentTeacherController.isParentSelected(id);
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(left: 24),
                                                                              child: CheckboxListTile(
                                                                                dense: true,
                                                                                contentPadding: EdgeInsets.zero,
                                                                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                                                controlAffinity: ListTileControlAffinity.leading,
                                                                                activeColor: AppColors.primary,
                                                                                value: checked,
                                                                                onChanged: (_) {
                                                                                  studentParentTeacherController.toggleSelectedParent(parentId: id);
                                                                                },
                                                                                title: Text(
                                                                                  "${p.pLname ?? ''}, ${p.pFname ?? ''}",
                                                                                  style: AppTextStyle.getOutfit400(
                                                                                    textSize: 16,
                                                                                    textColor: AppColors.secondary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                    },
                                                  ),
                                                )
                                              ]),
                                        );
                                      },
                                    ),
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
                                textInputAction: TextInputAction.done,
                                validateFunction: (String? value) {}),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('attachTitle'.tr,
                                style: AppTextStyle.getOutfit500(
                                    textSize: 18,
                                    textColor: AppColors.secondary)),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles();
                                    if (result != null) {
                                      studentParentTeacherController
                                          .setSelectedFilePath(
                                              selectedFilePath:
                                                  result.files.single.path ??
                                                      "");
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // color: AppColors.secondary
                                        //     .withOpacity(0.06)
                                        color: AppColors.secondary.withValues(alpha: 0.06)
                                    ),
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
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return CustomButtonWidget(
                                        buttonTitle: "sendTitle".tr,
                                        onPressed: () async {
                                          // ── Caso multiselección de alumnos ──────────────────────
                                          // Si la categoría es "student" y hay alumnos marcados
                                          // en la lista de seleccionados, se envía un mensaje
                                          // 1-a-1 a cada uno (sin group_name) y se muestra un
                                          // único toast de resumen al final.
                                          if (studentParentTeacherController.currentSendingMessageCategory ==
                                                  MessageSendCategoryForTeacher.student &&
                                              studentParentTeacherController
                                                  .selectedStudentsForSendMessage.isNotEmpty) {
                                            final selected = List<StudentItem>.from(
                                                studentParentTeacherController
                                                    .selectedStudentsForSendMessage);
                                            int ok = 0;
                                            int fail = 0;
                                            for (final s in selected) {
                                              final res = await studentParentTeacherController.sendMessage(
                                                messageSubject: _subjectController.text,
                                                description: _messageController.text,
                                                receiverId: s.wpUsrId,
                                                replyId: widget.replyId,
                                                silent: true,
                                              );
                                              if (res['status'] == true) {
                                                ok++;
                                              } else {
                                                fail++;
                                              }
                                            }
                                            // Resumen final
                                            if (fail == 0) {
                                              AppConstants.showCustomToast(
                                                  status: true,
                                                  message: "Enviado a $ok alumnos");
                                            } else {
                                              AppConstants.showCustomToast(
                                                  status: false,
                                                  message:
                                                      "Enviado a $ok, fallaron $fail");
                                            }
                                            // Limpia selección y vuelve atrás como en el flujo normal
                                            studentParentTeacherController.clearSelectedStudents();
                                            if (ok > 0) {
                                              studentParentTeacherController.setCurrentSelectedMessageType(
                                                  currentSelectedMessageListType: AppConstants.messageType2);
                                              studentParentTeacherController.getMessageList(showLoader: true);
                                              Get.back();
                                              Get.back();
                                            }
                                            return;
                                          }

                                          // ── Caso multiselección de padres ──────────────────────
                                          // Si la categoría es "parent" y hay padres marcados
                                          // en la lista de seleccionados, se envía un mensaje
                                          // 1-a-1 a cada uno (sin group_name) y se muestra un
                                          // único toast de resumen al final.
                                          if (studentParentTeacherController.currentSendingMessageCategory ==
                                                  MessageSendCategoryForTeacher.parent &&
                                              studentParentTeacherController
                                                  .selectedParentIdsForSendMessage.isNotEmpty) {
                                            final selectedIds = List<String>.from(
                                                studentParentTeacherController
                                                    .selectedParentIdsForSendMessage);
                                            int ok = 0;
                                            int fail = 0;
                                            for (final id in selectedIds) {
                                              final res = await studentParentTeacherController.sendMessage(
                                                messageSubject: _subjectController.text,
                                                description: _messageController.text,
                                                receiverId: id,
                                                replyId: widget.replyId,
                                                silent: true,
                                              );
                                              if (res['status'] == true) {
                                                ok++;
                                              } else {
                                                fail++;
                                              }
                                            }
                                            // Resumen final
                                            if (fail == 0) {
                                              AppConstants.showCustomToast(
                                                  status: true,
                                                  message: "Enviado a $ok padres");
                                            } else {
                                              AppConstants.showCustomToast(
                                                  status: false,
                                                  message:
                                                      "Enviado a $ok, fallaron $fail");
                                            }
                                            // Limpia selección y vuelve atrás como en el flujo normal
                                            studentParentTeacherController.clearSelectedParents();
                                            if (ok > 0) {
                                              studentParentTeacherController.setCurrentSelectedMessageType(
                                                  currentSelectedMessageListType: AppConstants.messageType2);
                                              studentParentTeacherController.getMessageList(showLoader: true);
                                              Get.back();
                                              Get.back();
                                            }
                                            return;
                                          }

                                          // ── Resto de casos: comportamiento original ─────────────
                                          await studentParentTeacherController.sendMessage(
                                              messageSubject: _subjectController.text,
                                              description: _messageController.text,
                                              classId: studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.toAllStudent ||
                                                       studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.toAllParent
                                                       ? studentParentTeacherController.currentSelectedClass?.cid ?? "" : null,
                                              receiverId: studentParentTeacherController.currentLoggedInUserRole == RoleType.parent || studentParentTeacherController.currentLoggedInUserRole == RoleType.student ? studentParentTeacherController.currentSelectedTeacherForMessageSend?.wpUsrId : studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.student ? studentParentTeacherController.currentSelectedStudentForSendMessage?.wpUsrId : studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.parent ? studentParentTeacherController.currentSelectedParentForSendMessage?.parentWpUsrId : null,
                                              toAllParent: studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.toAllParent ? "1" : null,
                                              toAllStudent: studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.toAllStudent ? "1" : null,
                                              groupName: studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.toAllParent
                                                  ? "Clase ${studentParentTeacherController.currentSelectedClass?.cName ?? ""} Padres"
                                                  : studentParentTeacherController.currentSendingMessageCategory == MessageSendCategoryForTeacher.toAllStudent
                                                  ? "Clase ${studentParentTeacherController.currentSelectedClass?.cName ?? ""} Alumnos"
                                                  : null,
                                              replyId: widget.replyId,                                        
                                          ).then((res){                                            
                                            if(res['status']){
                                              studentParentTeacherController.setCurrentSelectedMessageType(
                                                  currentSelectedMessageListType: AppConstants.messageType2);
                                              studentParentTeacherController.getMessageList(showLoader: true);
                                              Get.back();
                                              Get.back();
                                            }
                                          });
                                          }
                                        );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
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