import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TeacherDetails extends StatefulWidget {
  final String wpUserId;
  final String? subject;
  final String inCharge;

  const TeacherDetails({
    super.key,
    required this.wpUserId,
    this.subject,
    required this.inCharge,
  });

  @override
  State<TeacherDetails> createState() => _TeacherDetailsChild();
}

class _TeacherDetailsChild extends State<TeacherDetails> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getSingleTeacherDetails(teacherWPUserId: widget.wpUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res,ctx){
          studentParentTeacherController?.setTeacherDetail(singleTeacherModel: null);
        },
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            studentParentTeacherController?.setTeacherDetail(singleTeacherModel: null);
            Get.back();
          },
          title: Text(
            "techerdetail".tr,
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.white),
          )),
      body: BackgroundLayout(
        image: "",
        imageType: 0,
        childWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: Center(
                  child: Consumer<StudentParentTeacherController>(builder: (context,studentParentTeacherController,child){
                    return Column(
                      children: [
                        AutoSizeText(
                          maxLines: 5,
                          studentParentTeacherController.teacherDetail?.firstName ?? "",
                          style: AppTextStyle.getOutfit600(
                              textSize: 22,
                              textColor: AppColors.secondary),
                        ),
                        AutoSizeText(
                          maxLines: 5,
                          studentParentTeacherController.teacherDetail?.lastName ?? "-",
                          style: CustomStyle.login.copyWith(
                              fontSize: 16,
                              // color: AppColors.secondary.withOpacity(0.5)
                              color: AppColors.secondary.withValues(alpha: 0.5)
                          ),
                        )
                      ],
                    );
                  }),
                )),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TeacherDetailsWidget(label: "iotc".tr, value: widget.inCharge.isEmpty ? "-" : widget.inCharge),
                const SizedBox(
                  height: 20,
                ),
                Consumer<StudentParentTeacherController>(
                  builder: (context,studentParentTeacherController,child){
                    return TeacherDetailsWidget(label: "fch".tr, value: studentParentTeacherController.teacherDetail?.familyCareHour ?? "-");
                  },
                ),
                const SizedBox(height: 20,),

                Consumer<StudentParentTeacherController>(
                  builder: (context,studentParentTeacherController,child){
                    return TeacherDetailsWidget(label: "email".tr, value: studentParentTeacherController.teacherDetail?.userEmail ?? "-");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                      return Visibility(
                          visible: studentParentTeacherController
                              .currentLoggedInUserRole ==
                              RoleType.teacher,
                          child: Column(
                            children: [
                              Consumer<StudentParentTeacherController>(
                                builder: (context,studentParentTeacherController,child){
                                  return TeacherDetailsWidget(label: "teléfono", value: studentParentTeacherController.teacherDetail?.phone ?? "-");
                                },
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ));

                    }),

                Consumer<StudentParentTeacherController>(
                  builder: (context,studentParentTeacherController,child){
                    return TeacherDetailsWidget(
                        label: "subjects".tr, value: widget.subject == null ? studentParentTeacherController.teacherDetail?.subjectName?.join("\n") ?? "-" : widget.subject ?? "");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
        circularImage: Align(
          alignment: Alignment.center,
          child: Container(
            margin:
            EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.02),
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
            child: Consumer<StudentParentTeacherController>(
              builder: (context,studentParentTeacherController,child){
                return studentParentTeacherController.teacherDetail == null || studentParentTeacherController.teacherDetail?.image == null || studentParentTeacherController.teacherDetail!.image!.isEmpty
                    ? Center(
                  child: SvgPicture.asset(
                    AppImages.people,
                    width: 100,
                    height: 100,
                    colorFilter: const ColorFilter.mode(
                        AppColors.orange, BlendMode.srcIn),
                  ),
                )
                    : CircleAvatar(
                  radius: 16.0,
                  backgroundColor: AppColors.primary,
                  backgroundImage: NetworkImage(studentParentTeacherController.teacherDetail?.image ?? ""),
                  // ),
                );
              },
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

class TeacherDetailsWidget extends StatelessWidget {
  final String label;
  final String value;

  const TeacherDetailsWidget(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getOutfit500(
              textSize: 18,
              // textColor: AppColors.secondary.withOpacity(0.75)
              textColor: AppColors.secondary.withValues(alpha: 0.75)
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: 60
          ),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: AppColors.secondary.withOpacity(0.06)
                color: AppColors.secondary.withValues(alpha: 0.06)
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: AppTextStyle.getOutfit500(
                    textSize: 18, textColor: AppColors.secondary),
              ),
            )),
      ],
    );
  }
}
