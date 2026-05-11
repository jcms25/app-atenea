import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.setSelectedDinningDate(date: DateTime.now());
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('es', 'ES'),     
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      studentParentTeacherController?.setSelectedDinningDate(date: picked);
    }
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
                      const SizedBox(height: 10),
                      TeacherClassListDropdown(
                        fromWhichScreen: 9,
                        height: 60,
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.06),
                      )
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Text(
                "Fecha:",
                style: AppTextStyle.getOutfit400(
                    textSize: 16, textColor: AppColors.secondary),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.secondary.withValues(alpha: 0.06),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        style: AppTextStyle.getOutfit400(
                            textSize: 16, textColor: AppColors.secondary),
                      ),
                      Icon(Icons.calendar_today, color: AppColors.secondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return CustomButtonWidget(
                      buttonTitle: 'Ver datos',
                      onPressed: () async {
                        studentParentTeacherController
                            .setDinningStudentList(dinningStudentList: []);
                        studentParentTeacherController.setDinningSettings(
                            dinningSettings: null);
                        Get.back();
                        if (widget.currentLoggedInRole == "teacher" &&
                                studentParentTeacherController
                                        .currentSelectedClass !=
                                    null ||
                            widget.currentLoggedInRole == "parent") {
                          await studentParentTeacherController
                              .getDinningStudentList(
                                  classId: widget.currentLoggedInRole == "parent"
                                      ? ""
                                      : studentParentTeacherController
                                              .currentSelectedClass?.cid ??
                                          "",
                                  date: selectedDate);
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
