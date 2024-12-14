import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/student_details_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_textstyle.dart';

class StudentDetails extends StatefulWidget {
  final String sid;
  final String pValue;

  const StudentDetails({super.key, required this.sid, required this.pValue});

  @override
  State<StudentDetails> createState() => _StudentDetailsChild();
}

class _StudentDetailsChild extends State<StudentDetails> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getStudentDetails(studentId: widget.sid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setStudentDetails(
              studentDetails: null);
          studentParentTeacherController?.setIsLoading(isLoading: false);
        },
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBarWidget(
                title: Text("studentdetail".tr,
                    style: AppTextStyle.getOutfit500(
                        textSize: 20, textColor: AppColors.white)),
                onLeadingIconClicked: () {
                  studentParentTeacherController?.setStudentDetails(
                      studentDetails: null);
                  studentParentTeacherController?.setIsLoading(
                      isLoading: false);
                  Get.back();
                },
              ),
              body: Stack(
                children: [
                  BackgroundLayout(
                    imageType: 1,
                    childWidget: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: SingleChildScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Consumer<StudentParentTeacherController>(
                                builder: (context,
                                    studentParentTeacherController, child) {
                                  return Text(
                                    "${studentParentTeacherController.studentDetails?.sFname ?? ""}\t${studentParentTeacherController.studentDetails?.sLname ?? ""}",
                                    style: AppTextStyle.getOutfit600(
                                        textSize: 22,
                                        textColor: AppColors.secondary),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(child:
                                    Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return CustomStudentDetailRow(
                                        label: 'dob'.tr,
                                        value: studentParentTeacherController
                                                    .studentDetails?.sDob !=
                                                null
                                            ? DateFormat("dd/MM/yyyy").format(
                                                studentParentTeacherController
                                                        .studentDetails?.sDob ??
                                                    DateTime.now())
                                            : "-");
                                  },
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "address".tr,
                              style: AppTextStyle.getOutfit600(
                                  textSize: 18, textColor: AppColors.secondary),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return Visibility(
                                  visible: studentParentTeacherController.isAddressAndParentDetailsVisible(idOfStudentYouAreSeeingDetails: widget.sid),
                                  child: CustomStudentDetailRow(
                                      label: 'streetaddress'.tr,
                                      height: 100,
                                      alignment: Alignment.topLeft,
                                      value: studentParentTeacherController
                                              .studentDetails?.sAddress ??
                                          "-"),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(child:
                                    Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return CustomStudentDetailRow(
                                        label: "city".tr,
                                        value:
                                            "${studentParentTeacherController.studentDetails?.sCity}");
                                  },
                                )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(child:
                                    Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return CustomStudentDetailRow(
                                        label: "pincode".tr,
                                        value:
                                            "${studentParentTeacherController.studentDetails?.sZipcode}");
                                  },
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return CustomStudentDetailRow(
                                    label: "country".tr,
                                    value:
                                        "${studentParentTeacherController.studentDetails?.sCountry}");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return CustomStudentDetailRow(
                                    label: "Email",
                                    value:
                                        "${studentParentTeacherController.studentDetails?.stuEmail}");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "schooldetail".tr,
                              style: AppTextStyle.getOutfit600(
                                  textSize: 18, textColor: AppColors.secondary),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController, child) {
                                return CustomStudentDetailRow(
                                    label: "doj".tr,
                                    value:
                                    studentParentTeacherController
                                        .studentDetails?.sDoj !=
                                        null
                                        ? DateFormat("dd/MM/yyyy").format(
                                        studentParentTeacherController
                                            .studentDetails?.sDoj ??
                                            DateTime.now())
                                        : "-");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(child:
                                    Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return CustomStudentDetailRow(
                                        label: "class".tr,
                                        value:
                                            "${studentParentTeacherController.studentDetails?.className}");
                                  },
                                )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(child:
                                    Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return CustomStudentDetailRow(
                                        label: "rollno".tr,
                                        value:
                                            "${studentParentTeacherController.studentDetails?.sRollno}");
                                  },
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return Visibility(
                                    visible: studentParentTeacherController
                                        .isAddressAndParentDetailsVisible(
                                            idOfStudentYouAreSeeingDetails:
                                                widget.sid),
                                    child: Column(
                                      // children: studentParentTeacherController.studentDetails?.parentData.map<Widget>((e){
                                      children: studentParentTeacherController
                                              .studentDetails?.parentData
                                              .map<Widget>((e) {
                                            return ParentWidget(
                                              parentData: e,
                                            );
                                          }).toList() ??
                                          [],
                                    ));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    circularImage: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.sizeOf(context).height * 0.10),
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: AppColors.primary,
                              width: 3.0,
                              style: BorderStyle.solid),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(160)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 25,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Consumer<StudentParentTeacherController>(
                          builder:
                              (context, studentParentTeacherController, child) {
                            return CircleAvatar(
                              backgroundImage: NetworkImage(
                                  studentParentTeacherController
                                          .studentDetails?.stuImage ??
                                      ""),
                              backgroundColor: AppColors.primary,
                            );
                          },
                        ),
                      ),
                    ),
                    image: '',
                  ),
                ],
              ),
            ),
            Consumer<StudentParentTeacherController>(
              builder: (context, studentParentTeacherController, child) {
                return Visibility(
                    visible: studentParentTeacherController.isLoading,
                    child: LoadingLayout());
              },
            )
          ],
        ));
  }
}

class CustomStudentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final double? height;
  final Alignment? alignment;

  const CustomStudentDetailRow(
      {super.key,
      required this.label,
      required this.value,
      this.height,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getOutfit400(
              textSize: 18, textColor: AppColors.secondary.withOpacity(0.75)),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: height ?? 60),
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.secondary.withOpacity(0.06)),
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyle.getOutfit500(
                  textSize: 18, textColor: AppColors.secondary),
            ),
          ),
        )
      ],
    );
  }
}

class ParentWidget extends StatelessWidget {
  final ParentsDatum parentData;

  const ParentWidget({super.key, required this.parentData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          parentData.pGender == "Male"
              ? "parentsdetail".tr
              : "parentsdetail2".tr,
          style: AppTextStyle.getOutfit600(
              textSize: 18, textColor: AppColors.secondary),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomStudentDetailRow(
            label: parentData.pGender == "Male" ? "pname".tr : "pname2".tr,
            value: "${parentData.pFname}\t${parentData.pLname}"),
        const SizedBox(
          height: 10,
        ),
        CustomStudentDetailRow(
            label: "pemail".tr, value: parentData.parentEmail ?? "-"),
        const SizedBox(
          height: 10,
        ),
        CustomStudentDetailRow(
            label: "mobile".tr, value: parentData.pPhone ?? "-"),
        const SizedBox(
          height: 10,
        ),
        CustomStudentDetailRow(
            label: "parentpro".tr, value: parentData.pProfession ?? "-"),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
