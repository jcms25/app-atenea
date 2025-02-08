import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../controllers/student_parent_teacher_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_textstyle.dart';
import '../teacher_class_list_dropdown.dart';

class DinningManageServiceBottomSheetTeacher extends StatefulWidget {
  final String currentLoggedInRole;

  const DinningManageServiceBottomSheetTeacher(
      {super.key, required this.currentLoggedInRole});

  @override
  State<DinningManageServiceBottomSheetTeacher> createState() =>
      _DinningManageServiceBottomSheetTeacherState();
}

class _DinningManageServiceBottomSheetTeacherState
    extends State<DinningManageServiceBottomSheetTeacher> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      if (studentParentTeacherController?.currentSelectedDinningDay == null &&
          studentParentTeacherController?.selectedDinningMonth == null) {
        studentParentTeacherController?.setCurrentSelectedDinningDay(
            selectedDinningDay: DateTime.now().day);
        MonthModel? currentMonthModel = AppConstants.monthInSpanish
            .firstWhereOrNull((e) => e.id == DateTime.now().month);
        studentParentTeacherController?.setCurrentSelectedDinningMonth(
            dinningMonth: currentMonthModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              color: AppColors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<StudentParentTeacherController>(
                  builder: (context, studentParentTeacherController, child) {
                return Visibility(
                  visible:
                      studentParentTeacherController.currentLoggedInUserRole ==
                          RoleType.teacher,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Clase",
                        style: AppTextStyle.getOutfit400(
                            textSize: 16, textColor: AppColors.secondary),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TeacherClassListDropdown(
                        fromWhichScreen: 9,
                        height: 60,
                        backgroundColor: AppColors.secondary.withOpacity(0.06),
                      )
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Mes :",
                style: AppTextStyle.getOutfit400(
                    textSize: 16, textColor: AppColors.secondary),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.secondary.withOpacity(0.06)),
                    padding: const EdgeInsets.all(5),
                    child: DropdownButton<MonthModel>(
                        isExpanded: true,
                        underline: SizedBox.shrink(),
                        value:
                            studentParentTeacherController.selectedDinningMonth,
                        items: AppConstants.monthInSpanish.map((e) {
                          return DropdownMenuItem<MonthModel>(
                              value: e,
                              child: Text(
                                e.monthName,
                                style: AppTextStyle.getOutfit400(
                                    textSize: 16,
                                    textColor: AppColors.secondary),
                              ));
                        }).toList(),
                        hint: Text(
                          'Seleccione mes',
                          style: AppTextStyle.getOutfit500(
                              textSize: 16,
                              textColor: AppColors.secondary.withOpacity(0.5)),
                        ),
                        onChanged: (MonthModel? value) {
                          studentParentTeacherController
                              .setCurrentSelectedDinningMonth(
                                  dinningMonth: value);
                        }),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Día",
                style: AppTextStyle.getOutfit400(
                    textSize: 16, textColor: AppColors.secondary),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return Container(
                    height: 60,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.secondary.withOpacity(0.06)),
                    padding: const EdgeInsets.all(5),
                    child: DropdownButton<int>(
                        isExpanded: true,
                        underline: SizedBox.shrink(),
                        value: studentParentTeacherController
                            .currentSelectedDinningDay,
                        items: List.generate(31, (index) {
                          return DropdownMenuItem<int>(
                              value: index + 1, child: Text("${index + 1}"));
                        }),
                        hint: Text(
                          'Seleccione mes',
                          style: AppTextStyle.getOutfit500(
                              textSize: 16,
                              textColor: AppColors.secondary.withOpacity(0.5)),
                        ),
                        onChanged: (int? value) {
                          studentParentTeacherController
                              .setCurrentSelectedDinningDay(
                                  selectedDinningDay: value);
                        }),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return CustomButtonWidget(
                      buttonTitle: 'Ver datos',
                      onPressed: () async {
                        studentParentTeacherController
                            .setDinningStudentList(dinningStudentList: []);
                        studentParentTeacherController.setDinningSettings(
                            dinningSettings: null);
                        if (studentParentTeacherController
                                    .selectedDinningMonth ==
                                null ||
                            studentParentTeacherController
                                    .currentSelectedDinningDay ==
                                null) {
                          AppConstants.showCustomToast(
                              status: false,
                              message: "Por favor seleccione datos");
                        } else {
                          Get.back();
                          if (widget.currentLoggedInRole == "teacher" &&
                                  studentParentTeacherController
                                          .currentSelectedClass !=
                                      null ||
                              widget.currentLoggedInRole == "parent") {
                            await studentParentTeacherController
                                .getDinningStudentList(
                                    classId:
                                        widget.currentLoggedInRole == "parent"
                                            ? ""
                                            : studentParentTeacherController
                                                    .currentSelectedClass
                                                    ?.cid ??
                                                "",
                                    month: studentParentTeacherController
                                            .selectedDinningMonth?.id ??
                                        0,
                                    day: studentParentTeacherController
                                            .currentSelectedDinningDay ??
                                        0);
                          }
                        }
                      });
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
