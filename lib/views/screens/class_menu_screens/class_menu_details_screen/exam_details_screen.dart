import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ExamDetailScreen extends StatefulWidget {
  final String id;
  final String sID;
  final String professorName;
  final String subjectName;

  const ExamDetailScreen({
    super.key,
    required this.id,
    required this.sID,
    required this.professorName, required this.subjectName,
  });

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenChildState();
}

class _ExamDetailScreenChildState extends State<ExamDetailScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getDetailsOfExam(examId: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setIsLoading(isLoading: false);
          studentParentTeacherController?.setExamDetailItem(
              examDetailItem: null);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBarWidget(
                onLeadingIconClicked: () {
                  studentParentTeacherController?.setIsLoading(
                      isLoading: false);
                  studentParentTeacherController?.setExamDetailItem(
                      examDetailItem: null);
                  Get.back();
                },
                title: Text(
                  "testdetail".tr,
                  style: AppTextStyle.getOutfit600(
                      textSize: 20, textColor: AppColors.white),
                )),
            body: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Image.asset(AppImages.studying),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 00, right: 00),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "subject".tr,
                                        style: CustomStyle.txtvalue4,
                                      ),
                                    ),
                                    Expanded(child: Text(
                                      widget.subjectName,
                                      style: CustomStyle.txtvalue4.copyWith(
                                          fontWeight: FontWeight.w600),
                                    )
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomDottedLineWidget(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return ExamDetailRow(
                                        label: "professor".tr,
                                        value: widget.professorName);
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomDottedLineWidget(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return ExamDetailRow(
                                        label: "title".tr,
                                        value: studentParentTeacherController
                                                .examDetailItem?.eName ??
                                            "-");
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomDottedLineWidget(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return ExamDetailRow(
                                        label: "date".tr,
                                        value: studentParentTeacherController
                                                .examDetailItem?.eSDate ??
                                            "-");
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const CustomDottedLineWidget(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return ExamDetailRow(
                                        label: "hour".tr,
                                        value: studentParentTeacherController
                                                .examDetailItem?.time ??
                                            "-");
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const CustomDottedLineWidget(),
                                Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return Visibility(
                                        visible: studentParentTeacherController
                                            .examDetailItem?.comments == null || studentParentTeacherController
                                            .examDetailItem!.comments!.isNotEmpty,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ExamDetailRow(
                                                label: "comment".tr,
                                                value: studentParentTeacherController
                                                    .examDetailItem?.comments ??
                                                    "-"),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            CustomDottedLineWidget(),
                                          ],
                                        )
                                    );
                                  },
                                ),

                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                  return Visibility(
                      visible: studentParentTeacherController.isLoading,
                      child: LoadingLayout());
                })
              ],
            )));
  }
}

class ExamDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ExamDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: CustomStyle.txtvalue4,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Text(
          value,
          style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
        ))
      ],
    );
  }
}
