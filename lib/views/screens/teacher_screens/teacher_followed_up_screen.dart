import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/followed_up_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/followed_up_bottom_sheet.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class TeacherFollowedUpScreen extends StatefulWidget {
  const TeacherFollowedUpScreen({super.key});

  @override
  State<TeacherFollowedUpScreen> createState() =>
      _TeacherFollowedUpScreenState();
}

class _TeacherFollowedUpScreenState extends State<TeacherFollowedUpScreen> {
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
        studentParentTeacherController?.getListOfStudents(
            classId: studentParentTeacherController
                    ?.listOfClassAssignToTeacher[0].cid ??
                "",
            roleType: RoleType.teacher);
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
          studentParentTeacherController
              ?.setListOfStudentFollowedUp(listOfStudentFollowedUp: []);
          studentParentTeacherController?.setListOfStudents(listOfStudents: []);
          studentParentTeacherController?.setSelectedStudentForFollowUp(
              studentItem: null);
          studentParentTeacherController?.setIsLoading(isLoading: false);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              studentParentTeacherController
                  ?.setListOfStudentFollowedUp(listOfStudentFollowedUp: []);
              studentParentTeacherController
                  ?.setListOfStudents(listOfStudents: []);
              studentParentTeacherController?.setSelectedStudentForFollowUp(
                  studentItem: null);
              studentParentTeacherController?.setIsLoading(isLoading: false);
              Get.back();
            },
            title: Text(
              'subMenuDrawer13'.tr,
              style: AppTextStyle.getOutfit600(
                  textSize: 20, textColor: AppColors.white),
            ),
            actionIcons: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30))),
                      builder: (context) {
                        return StatefulBuilder(builder: (context, state) {
                          return FollowedUpBottomSheet();
                        });
                      });
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.orange),
                  child: Center(
                    child: Text(
                      "Gestionar",
                      style: AppTextStyle.getOutfit400(
                          textSize: 16, textColor: AppColors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: AppColors.primary),
                      padding: const EdgeInsets.all(20),
                      child: Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return CustomTextField(
                              filledColor: AppColors.white,
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.secondary,
                              ),
                              hintText: 'Buscar tema,examen',
                              onTextChanged: studentParentTeacherController
                                  .searchInFollowedUpList,
                              validateFunction: (String? value) {});
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                // return studentParentTeacherController
                                //         .tempListOfStudentFollowedUp.isEmpty
                                //     ? Center(
                                //         child: Text(
                                //           'No se encontraron datos',
                                //           style: AppTextStyle.getOutfit500(
                                //               textSize: 16,
                                //               textColor: AppColors.secondary),
                                //         ),
                                //       )
                                //     :

                                return ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 10,
                                          );
                                        },
                                        itemCount:
                                            studentParentTeacherController
                                                .tempListOfStudentFollowedUp
                                                .length,
                                        itemBuilder: (context, index) {
                                          FollowedUpItemDetail? item =
                                              studentParentTeacherController
                                                  .tempListOfStudentFollowedUp[
                                                      index]
                                                  .list?[0];
                                          return FollowedUpWidget(
                                            followedUpItemDetail: item,
                                          );
                                        });
                              },
                            ),
                          )))
                ],
              ),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return Visibility(
                      visible: studentParentTeacherController.isLoading &&
                          !(Get.isBottomSheetOpen!),
                      child: LoadingLayout());
                },
              )
            ],
          ),
        ));
  }
}

class FollowedUpWidget extends StatelessWidget {
  final FollowedUpItemDetail? followedUpItemDetail;

  const FollowedUpWidget({super.key, required this.followedUpItemDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColors.color10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary),
            padding: const EdgeInsets.all(10),
            child: Text(
              DateFormat("dd-MM-yyyy")
                  .format(DateTime.parse(followedUpItemDetail?.date ?? "-")),
              style: AppTextStyle.getOutfit300(
                  textSize: 14, textColor: AppColors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomFollowedUpRow(
              label: "subject".tr,
              value: followedUpItemDetail?.subjectName ?? "-"),
          const SizedBox(
            height: 10,
          ),
          CustomDottedLineWidget(),
          const SizedBox(
            height: 10,
          ),
          CustomFollowedUpRow(
              label: "examname".tr,
              value: followedUpItemDetail?.examName ?? "-"),
          const SizedBox(
            height: 10,
          ),
          CustomDottedLineWidget(),
          const SizedBox(
            height: 10,
          ),
          CustomFollowedUpRow(
              label: "grade".tr, value: followedUpItemDetail?.mark ?? "-"),
          const SizedBox(
            height: 10,
          ),
          CustomDottedLineWidget(),
          const SizedBox(
            height: 10,
          ),
          CustomFollowedUpRow(
              label: "obser".tr, value: followedUpItemDetail?.remarks ?? "-"),
          const SizedBox(
            height: 10,
          ),
          CustomDottedLineWidget(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class CustomFollowedUpRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomFollowedUpRow(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getOutfit400(
              textSize: 16,
              // textColor: AppColors.secondary.withOpacity(0.5)
              textColor: AppColors.secondary.withValues(alpha: 0.5)
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          value.isEmpty ? "-" : value,
          textAlign: TextAlign.end,
          style: AppTextStyle.getOutfit500(
              textSize: 16, textColor: AppColors.secondary),
        ))
      ],
    );
  }
}
