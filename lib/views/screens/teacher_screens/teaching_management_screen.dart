import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/exam_list_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_add_edit_marks_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_followed_up_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/student_parent_teacher_controller.dart';
class TeachingManagementScreen extends StatefulWidget {
  const TeachingManagementScreen({super.key});

  @override
  State<TeachingManagementScreen> createState() => _TeachingManagementScreenState();
}

class _TeachingManagementScreenState extends State<TeachingManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: GridView.builder(
                itemCount: AppConstants.teachingSubMenuListTeacher.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2), itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  onTeachingManagementOptionClick(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.circular(10),
                      // color: AppColors.primary.withOpacity(0.06)
                      color: AppColors.primary.withValues(alpha: 0.06)
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "${AppConstants.teachingSubMenuListTeacher[index]['name']}",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.primary),),
                  ),
                ),
              );
            }),))
      ],
    );
  }

  void onTeachingManagementOptionClick(int index) {
    switch(index){
      case 0:
        Get.to(() => TeacherScheduleScreen());
        break;
      case 1:
        Get.to(() => ExamListScreen(), arguments: {"role": RoleType.teacher});
        break;
      case 2:
        Get.to(() => TeacherAddEditMarksScreen());
        break;
      case 3:
        Get.to(() => TeacherFollowedUpScreen());
        break;
      default:
        break;
    }
  }
}


