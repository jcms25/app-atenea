//Note : This is use for both parent and teacher and not for student.
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/dinning_manage_service_bottom_sheet_teacher.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class ManageServiceScreen extends StatefulWidget {
  const ManageServiceScreen({super.key});

  @override
  State<ManageServiceScreen> createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {});
    studentParentTeacherController =
        Provider.of<StudentParentTeacherController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setListOfStatusOfStudentDinning(
              listOfStatusOfStudentDinning: []);
          studentParentTeacherController
              ?.setMapOfStatusOfStudentDinning(mapOfStatusOfStudentDinning: {});
          studentParentTeacherController
              ?.setDinningStudentList(dinningStudentList: []);
          studentParentTeacherController?.setCurrentSelectedDinningDay(
              selectedDinningDay: null);
          studentParentTeacherController?.setCurrentSelectedDinningMonth(
              dinningMonth: null);
          studentParentTeacherController?.setDinningSettings(
              dinningSettings: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              studentParentTeacherController?.setListOfStatusOfStudentDinning(
                  listOfStatusOfStudentDinning: []);
              studentParentTeacherController?.setMapOfStatusOfStudentDinning(
                  mapOfStatusOfStudentDinning: {});
              studentParentTeacherController
                  ?.setDinningStudentList(dinningStudentList: []);
              studentParentTeacherController?.setCurrentSelectedDinningDay(
                  selectedDinningDay: null);
              studentParentTeacherController?.setCurrentSelectedDinningMonth(
                  dinningMonth: null);

              studentParentTeacherController?.setDinningSettings(
                  dinningSettings: null);
              Get.back();
            },
            title: Text(
              'Gestionar Servicio',
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
            actionIcons: [
              DinningRoomAttendanceButton()
            ],
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacher, child) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                        ),
                        padding: const EdgeInsets.all(10).copyWith(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColors.transparent,
                                builder: (context) {
                                  return DinningManageServiceBottomSheetTeacher(
                                    currentLoggedInRole: studentParentTeacher
                                                .currentLoggedInUserRole ==
                                            RoleType.parent
                                        ? "parent"
                                        : "teacher",
                                  );
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
                        ),
                      );
                    },
                  ),
                  Expanded(child: Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                      return studentParentTeacherController
                              .dinningStudentList.isEmpty
                          ? Center(
                              child: Text(
                                'No se encontraron datos de comedor.',
                                style: AppTextStyle.getOutfit500(
                                    textSize: 16,
                                    textColor: AppColors.secondary),
                              ),
                            )
                          : ScrollConfiguration(
                              behavior:
                                  ScrollBehavior().copyWith(overscroll: false),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      Consumer<StudentParentTeacherController>(
                                        builder: (context,
                                            studentParentTeacherController,
                                            child) {
                                          return Visibility(
                                              visible: studentParentTeacherController
                                                          .currentSelectedDinningDay !=
                                                      null &&
                                                  studentParentTeacherController
                                                          .selectedDinningMonth !=
                                                      null,
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                decoration: BoxDecoration(
                                                    color: AppColors.secondary
                                                        .withOpacity(0.06),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20))),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Notificar asistencia al Comedor para el día\t:\t\n${studentParentTeacherController.currentSelectedDinningDay}/${studentParentTeacherController.selectedDinningMonth?.id}/${DateTime.now().year}",
                                                  style:
                                                      AppTextStyle.getOutfit500(
                                                          textSize: 18,
                                                          textColor: AppColors
                                                              .secondary),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Franja horaria\t:",
                                            style: AppTextStyle.getOutfit500(
                                                textSize: 16,
                                                textColor: AppColors.secondary),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                              child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.secondary
                                                    .withOpacity(0.06),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            constraints:
                                                BoxConstraints(minWidth: 100),
                                            padding: const EdgeInsets.all(20),
                                            child: Center(
                                              child: Text(
                                                studentParentTeacherController
                                                        .dinningSettings
                                                        ?.closingTime ??
                                                    "-",
                                                style:
                                                    AppTextStyle.getOutfit400(
                                                        textSize: 16,
                                                        textColor: AppColors
                                                            .secondary),
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(3),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1)
                                        },
                                        border: TableBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          top: BorderSide(
                                              width: 1,
                                              color: AppColors.secondary),
                                          bottom: BorderSide(
                                              width: 1,
                                              color: AppColors.secondary),
                                          left: BorderSide(
                                              width: 1,
                                              color: AppColors.secondary),
                                          right: BorderSide(
                                              width: 1,
                                              color: AppColors.secondary),
                                          horizontalInside: BorderSide(
                                              color: AppColors.secondary,
                                              width: 1),
                                          verticalInside: BorderSide(
                                              color: AppColors.secondary,
                                              width: 1),
                                        ),
                                        children: [
                                          TableRow(children: [
                                            DinningHeaderTableCell(
                                                cellLabel: "class".tr),
                                            DinningHeaderTableCell(
                                                cellLabel: "student".tr),
                                            DinningHeaderTableCell(
                                                cellLabel: "Comedor"),
                                            DinningHeaderTableCell(
                                                cellLabel: "Asiste")
                                          ]),
                                          ...studentParentTeacherController
                                              .dinningStudentList
                                              .map((e) {
                                            Color color = Color(int.parse(
                                                    e.color?.substring(1, 7) ??
                                                        "#000000",
                                                    radix: 16) +
                                                0xFF000000);
                                            return TableRow(children: [
                                              TableCell(
                                                  child: Container(
                                                height: 60,
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    e.className ?? "",
                                                    style: AppTextStyle
                                                        .getOutfit500(
                                                            textSize: 16,
                                                            textColor: AppColors
                                                                .secondary),
                                                  ),
                                                ),
                                              )),
                                              TableCell(
                                                  child: Container(
                                                height: 60,
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    e.studentName ?? "",
                                                    style: AppTextStyle
                                                        .getOutfit500(
                                                            textSize: 16,
                                                            textColor: AppColors
                                                                .secondary),
                                                  ),
                                                ),
                                              )),
                                              TableCell(
                                                  child: Container(
                                                height: 60,
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Checkbox(
                                                      activeColor: AppColors
                                                          .secondary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      value:
                                                          e.diningProfile == 1
                                                              ? true
                                                              : false,
                                                      onChanged: null),
                                                ),
                                              )),
                                              TableCell(
                                                  child: Container(
                                                height: 60,
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Checkbox(
                                                      activeColor: color,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              side:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          color)),
                                                      value: studentParentTeacherController
                                                              .mapOfStatusOfStudentDinning[e
                                                                  .wpUsrId ??
                                                              ""] ==
                                                          1,
                                                      onChanged: (bool? value) {
                                                        studentParentTeacherController
                                                            .addDinningStatusData(
                                                                keyName:
                                                                    e.wpUsrId ??
                                                                        "",
                                                                status: value ??
                                                                        false
                                                                    ? 1
                                                                    : 0);
                                                      }),
                                                ),
                                              )),
                                            ]);
                                          })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                    },
                  )),
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

class DinningRoomAttendanceButton extends StatelessWidget {
  const DinningRoomAttendanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentParentTeacherController>(
      builder: (context, studentParentTeacherController, child) {
        RoleType? currentLoggedInRole =
            studentParentTeacherController.currentLoggedInUserRole;
        return Visibility(
            visible: currentLoggedInRole == RoleType.teacher ||
                currentLoggedInRole == RoleType.parent,
            child: GestureDetector(
              onTap: studentParentTeacherController
                          .dinningSettings?.checkClosingTime ==
                      "open"
                  ? () async {
                      await studentParentTeacherController.addEditDinningStatus(
                          monthNumber: studentParentTeacherController
                                  .selectedDinningMonth?.id ??
                              0,
                          day: studentParentTeacherController
                                  .currentSelectedDinningDay ??
                              0);
                    }
                  : null,
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: studentParentTeacherController
                                .dinningSettings?.checkClosingTime ==
                            "open"
                        ? AppColors.orange
                        : AppColors.orange.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    'Enviar',
                    style: AppTextStyle.getOutfit400(
                        textSize: 18,
                        textColor: studentParentTeacherController
                                    .dinningSettings?.checkClosingTime ==
                                "open"
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.5)),
                  ),
                ),
              ),
            ));
      },
    );
  }
}

class DinningHeaderTableCell extends StatelessWidget {
  final String cellLabel;

  const DinningHeaderTableCell({super.key, required this.cellLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          cellLabel,
          style: AppTextStyle.getOutfit500(
              textSize: 16, textColor: AppColors.white),
        ),
      ),
    );
  }
}
