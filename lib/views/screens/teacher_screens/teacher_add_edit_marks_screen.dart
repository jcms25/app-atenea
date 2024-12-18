import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class TeacherAddEditMarksScreen extends StatefulWidget {
  const TeacherAddEditMarksScreen({super.key});

  @override
  State<TeacherAddEditMarksScreen> createState() =>
      _TeacherAddEditMarksScreenState();
}

class _TeacherAddEditMarksScreenState extends State<TeacherAddEditMarksScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: Text(
        'grades'.tr,
        style:
            AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.white),
      )),
      body: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              children: [],
            ),
          )),
    );
  }
}

class MarksEditViewWidget extends StatelessWidget {
  const MarksEditViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: Text(
                    '2333',
                    style: AppTextStyle.getOutfit300(
                        textSize: 14, textColor: AppColors.white),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Almagro Rastrollo,Ana',
                  style: AppTextStyle.getOutfit500(
                      textSize: 18, textColor: AppColors.secondary),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
