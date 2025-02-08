import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/teacher/teacher_schedule_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_constants.dart';
import '../../custom_widgets/custom_loader.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getTeacherScheduleList(teacherWpUserId: studentParentTeacherController?.userdata?.wpUsrId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, mac) {
          studentParentTeacherController?.setSelectedTeacherScheduleItem(teacherScheduleItem: null);
          studentParentTeacherController?.setTeacherScheduleList(teacherScheduleList: []);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: (){
              studentParentTeacherController?.setSelectedTeacherScheduleItem(teacherScheduleItem: null);
              studentParentTeacherController?.setTeacherScheduleList(teacherScheduleList: []);
              Get.back();

              },
              title: Text(
            'subMenuDrawer12'.tr,
            style: AppTextStyle.getOutfit500(
                textSize: 20,
                textColor: AppColors.white),
          )),
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
                          builder: (context, studentParentTeacherController, child) {
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: AppConstants.daysInSpanish.length,
                              itemBuilder: (context, position) {
                                return GestureDetector(
                                  onTap: () {

                                    if(studentParentTeacherController.teacherScheduleList.isNotEmpty){
                                      studentParentTeacherController.setSelectedTeacherScheduleItem(teacherScheduleItem: studentParentTeacherController.teacherScheduleList[position]);
                                      studentParentTeacherController.setCurrentSelectedDay(currentSelectedDay: position);
                                    }else{
                                      studentParentTeacherController.setCurrentSelectedDay(currentSelectedDay: position);
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: studentParentTeacherController.currentSelectedDay ==
                                            position
                                            ? AppColors.primary
                                            : AppColors.primary
                                            .withOpacity(0.05)),
                                    child: Center(
                                      child: Text(
                                        AppConstants.daysInSpanish[position],
                                        style: AppTextStyle.getOutfit500(textSize: 16, textColor: studentParentTeacherController.currentSelectedDay == position ? AppColors.white : AppColors.primary),
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
                                    .selectedTeacherScheduleItem?.data?.isEmpty ?? true
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
                                      TeacherScheduleItemData? teacherScheduleItem = appController.selectedTeacherScheduleItem?.data?[index];
                                      return Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: AppColors.primary
                                                .withOpacity(0.05)),
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
                                              teacherScheduleItem?.hour ?? "",
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
                                              // subjectName,
                                              teacherScheduleItem?.subName ?? "",
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
                                        .selectedTeacherScheduleItem?.data?.length ?? 0);
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
          ),
        ));
  }
}
