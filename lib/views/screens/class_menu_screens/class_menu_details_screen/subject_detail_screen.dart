import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_textstyle.dart';

class SubjectDetailScreen extends StatefulWidget {
  final String subjectId;
  final String group;

  const SubjectDetailScreen(
      {super.key, required this.subjectId, required this.group});

  @override
  State<SubjectDetailScreen> createState() => SubjectsDetail();
}

class SubjectsDetail extends State<SubjectDetailScreen> {
  StudentParentTeacherController? studentParentController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentController = Provider.of(context, listen: false);
      studentParentController?.getSingleSubjectDetails(
          subjectId: widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (result, onPopInvoked) {
          studentParentController?.setSubjectDetails(subjectDetail: null);
          studentParentController?.setSubject(subject: null);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                studentParentController?.setSubject(subject: null);
                Get.back();
              },
              title: Text(
                "subjectdetail".tr,
                style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),
              )),
          body: BackgroundLayout(
            image: "",
            imageType: 0,
            childWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Consumer<StudentParentTeacherController>(
                          builder: (context, appController, child) {
                        return AutoSizeText(
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          appController.subjectDetail?.subName ?? "-",
                          style: AppTextStyle.getOutfit600(
                              textSize: 22, textColor: AppColors.secondary),
                        );
                      }),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: AppColors.secondary.withOpacity(0.06)
                      color: AppColors.secondary.withValues(alpha: 0.06)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<StudentParentTeacherController>(
                        builder: (context, appController, child) {
                          return CustomSubjectDetailRow(
                              label: 'groupName'.tr, value: widget.group);
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const CustomDottedLineWidget(),
                      const SizedBox(
                        height: 5,
                      ),
                      Consumer<StudentParentTeacherController>(
                        builder: (context, appController, child) {
                          return CustomSubjectDetailRow(
                              label: "subjectcode".tr,
                              value:
                                  appController.subjectDetail?.subCode ?? "-");
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const CustomDottedLineWidget(),
                      const SizedBox(
                        height: 5,
                      ),
                      Consumer<StudentParentTeacherController>(
                        builder: (context, appController, child) {
                          return CustomSubjectDetailRow(
                              label: "faculty".tr,
                              value:
                                  "${appController.subjectDetail?.firstName ?? "-"}\t${appController.subjectDetail?.lastName ?? "-"}");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomDottedLineWidget(),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'nameofthebook'.tr,
                            style: AppTextStyle.getOutfit400(
                                textSize: 18,
                                // textColor:
                                //     AppColors.secondary.withOpacity(0.75)
                                textColor: AppColors.secondary.withValues(alpha: 0.75)
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Consumer<StudentParentTeacherController>(
                            builder: (context, appController, child) {
                              return Text(
                                appController.subject?.data?[0].bookName
                                        ?.replaceAll(";", "\n") ??
                                    "-",
                                style: AppTextStyle.getOutfit600(
                                    textSize: 18,
                                    textColor: AppColors.secondary),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: Consumer<StudentParentTeacherController>(
                      builder: (context, appController, child) {
                        Map<String, dynamic> booksMap =
                            jsonDecode(appController.subject?.books ?? "{}");

                        List<Widget> bookWidget = booksMap.values.map((e) {
                          return CachedNetworkImage(
                            imageUrl: e,
                            width: 200,
                            height: 200,
                            placeholder: (context, error) => const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.book,
                              size: 20,
                            ),
                          );
                        }).toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: bookWidget,
                          ),
                        );
                      },
                    ))
              ],
            ),
            circularImage: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).width * 0.02),
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                      color: AppColors.primary,
                      width: 3.0,
                      style: BorderStyle.solid),
                  borderRadius: const BorderRadius.all(Radius.circular(160)),
                  boxShadow: [
                    BoxShadow(
                      // color: AppColors.primary.withOpacity(0.5),
                      color: AppColors.primary.withValues(alpha: 0.5),
                      spreadRadius: 0,
                      blurRadius: 25,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.white,
                  radius: 8.0,
                  child: SvgPicture.asset(AppImages.book, width: 50, height: 50
                      //
                      ),
                ),
              ),
            ),
            loadingWidget: Consumer<StudentParentTeacherController>(
              builder: (context, studentParentTeacherController, child) {
                return Visibility(
                    visible: studentParentTeacherController.isLoading,
                    child: LoadingLayout());
              },
            ),
          ),
        ));
  }
}

class CustomSubjectDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomSubjectDetailRow(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          label,
          style: AppTextStyle.getOutfit400(
              textSize: 18,
              // textColor: AppColors.secondary.withOpacity(0.75)
             textColor: AppColors.secondary.withValues(alpha: 0.75)
          ),
        )),
        Expanded(
            child: Text(value,
                style: AppTextStyle.getOutfit600(
                    textSize: 16, textColor: AppColors.secondary)))
      ],
    );
  }
}
