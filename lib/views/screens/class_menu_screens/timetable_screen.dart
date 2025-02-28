import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/timetable_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_textstyle.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => TimeTable();
}

class TimeTable extends State<TimeTableScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  Map<String, dynamic>? arguments;

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    RoleType currentLoggedInUser = arguments?['role'];
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
          studentParentTeacherController?.getTimeTableData(
              classId: currentLoggedInUser == RoleType.teacher
                  ? studentParentTeacherController
                      ?.listOfClassAssignToTeacher[0].cid
                  : arguments?["classId"],
              studentId: arguments?['wpUserId']);
        }
      } else {
        studentParentTeacherController?.getTimeTableData(
            classId: arguments?["classId"], studentId: arguments?['wpUserId']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            Get.back();
          },
          title: Text(
            arguments?['role'] == RoleType.teacher
                ? "Horario"
                : "Horario de ${arguments?["studentName"]} (${arguments?["className"]})",
            style: AppTextStyle.getOutfit500(
                textSize: 20, textColor: AppColors.white),
          ),
          actionIcons: [
            Visibility(
                visible: arguments?['role'] == RoleType.teacher,
                child: Expanded(
                    child: TeacherClassListDropdown(
                  fromWhichScreen: 5,
                )))
          ],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: false,
                    child:  Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: AppColors.primary),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Consumer<StudentParentTeacherController>(
                                    builder: (context, appController, child) {
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
                                                textColor: AppColors.secondary),
                                            border: InputBorder.none),
                                        cursorColor: AppColors.primary,
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 18,
                                            textColor: AppColors.secondary),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged:
                                        appController.searchInTimeTableData,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))),
                const SizedBox(height: 20,),
                Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: Consumer<StudentParentTeacherController>(
                        builder: (context, appController, child) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: AppConstants.daysInSpanish.length,
                            itemBuilder: (context, position) {
                              return GestureDetector(
                                onTap: () {
                                  if (appController.timeTableList.isNotEmpty) {
                                    appController.setParticularDayTimeTableData(
                                        particularDayTimeTableData:
                                            appController
                                                    .timeTableList[position]
                                                    .data ??
                                                []);
                                    appController.setCurrentSelectedDay(
                                        currentSelectedDay: position);
                                  } else {
                                    appController.setCurrentSelectedDay(
                                        currentSelectedDay: position);
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: appController.currentSelectedDay ==
                                              position
                                          ? AppColors.primary
                                          // : AppColors.primary
                                          //     .withOpacity(0.05)
                                         : AppColors.primary.withValues(alpha: 0.05)
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppConstants.daysInSpanish[position],
                                      style: AppTextStyle.getOutfit500(textSize: 16, textColor: studentParentTeacherController?.currentSelectedDay == position ? AppColors.white : AppColors.primary),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, position) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                          );
                        },
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15)
                      .copyWith(bottom: 20),
                  child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: Consumer<StudentParentTeacherController>(
                        builder: (context, appController, child) {
                          return appController.isLoading
                              ? const SizedBox.shrink()
                              : appController
                                      .tempParticularDayTimeTableData.isEmpty
                                  ? Center(
                                      child: Text(
                                        'noStudentFound'.tr,
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 16,
                                            textColor: AppColors.secondary),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) {
                                        TimeTableItemData data = appController
                                                .tempParticularDayTimeTableData[
                                            index];
                                        String subjectName = arguments?[
                                                    'role'] ==
                                                RoleType.teacher
                                            ? data.subName?.join("\n") ?? "-"
                                            : data.subName?.length == 2
                                                ? appController.getSubjectName(
                                                    subjectName:
                                                        data.subName ?? [])
                                                : data.subName?.join("\n") ??
                                                    "-";
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // color: AppColors.primary
                                              //     .withOpacity(0.05)
                                              color: AppColors.primary.withValues(alpha: 0.05)
                                          ),
                                          constraints: const BoxConstraints(
                                              minHeight: 50),
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data.begintime}-${data.endtime}",
                                                style:
                                                    AppTextStyle.getOutfit600(
                                                        textSize: 20,
                                                        textColor:
                                                            AppColors.primary),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                subjectName,
                                                style:
                                                    AppTextStyle.getOutfit400(
                                                        textSize: 14,
                                                        textColor: AppColors
                                                            .secondary),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                      itemCount: appController
                                          .tempParticularDayTimeTableData
                                          .length);
                        },
                      )),
                ))
              ],
            ),
            Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
              return Visibility(
                  visible: studentParentTeacherController.isLoading,
                  child: LoadingLayout());
            })
          ],
        ));
  }
}
