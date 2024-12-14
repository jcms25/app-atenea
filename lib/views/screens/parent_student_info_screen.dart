import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';

class ParentStudentInfo extends StatefulWidget {
  const ParentStudentInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ParentStudentInfoChild();
  }
}

class _ParentStudentInfoChild extends State<ParentStudentInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Consumer<StudentParentTeacherController>(
                  builder: (context, studentParentTeacherController, child) {
                    RoleType? userRole =
                        studentParentTeacherController.currentLoggedInUserRole;
                    List<StudentData> studentData = [];
                    List<ParentData> parentData = [];

                    if (userRole == RoleType.student) {
                      parentData = studentParentTeacherController
                          .loginModel?.userdata?.parentData ??
                          [];
                    } else {
                      studentData = studentParentTeacherController
                          .loginModel?.userdata?.studentData ??
                          [];
                    }

                    return ListView.separated(
                        separatorBuilder: (context,index){
                          return const SizedBox(height: 20,);
                        },
                        itemCount: userRole == RoleType.student
                            ? parentData.length
                            : studentData.length,
                        itemBuilder: (context, index) {
                          int role = userRole == RoleType.student ? 0 : 1;
                          return DetailWidget(
                              roleOfUser: role,
                              parentData: role == 0 ? parentData[index] : null,
                              studentData:
                              role == 1 ? studentData[index] : null);
                        });
                  },
                ))),
            const SizedBox(height: 20,),
          ],
        ),
        ));
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No hay datos disponibles",
        style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label,
                style: AppTextStyle.getOutfit400(
                    textSize: 16,
                    textColor: AppColors.secondary.withOpacity(0.6))),
            const Spacer(),
            Text(
              value,
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CustomDottedLineWidget()
      ],
    );
  }
}

class DetailWidget extends StatelessWidget {
  final int roleOfUser;
  final ParentData? parentData;
  final StudentData? studentData;

  const DetailWidget(
      {super.key,
      required this.roleOfUser,
      required this.parentData,
      required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.06),
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(
              roleOfUser == 1
                  ? studentData?.stuImage ?? "-"
                  : parentData?.parentImage ?? "-",
            ),
            backgroundColor: AppColors.primary,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            roleOfUser == 1
                ? studentData?.sFname ?? "-"
                : parentData?.pFname ?? "-",
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.secondary),
          ),
          const SizedBox(
            height: 5,
          ),
          CustomRow(
            "email".tr,
            roleOfUser == 1
                ? studentData?.stuEmail ?? "-"
                : parentData?.parentEmail ?? "-",
          ),
          roleOfUser == 1
              ? CustomRow("singalClass".tr, studentData?.className ?? "-")
              : CustomRow("eTitle".tr, parentData?.pEdu ?? "-"),
          roleOfUser == 1
              ? CustomRow(
                  "dob".tr,
                  DateFormat("dd-MM-yyyy")
                      .format(DateTime.parse(studentData?.sDob ?? "-")))
              : CustomRow("parentpro".tr, parentData?.pProfession ?? "-"),
          Visibility(
            visible: roleOfUser == 0,
            child: CustomRow(
                "mobile".tr, roleOfUser == 0 ? parentData?.pPhone ?? "-" : "-"),
          )
        ],
      ),
    );
  }
}
