import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/student_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/subject_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/teacher_list_screen.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/timetable_screen.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_parent_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';


class TeacherClassMenuScreen extends StatelessWidget {
  const TeacherClassMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Consumer<StudentParentTeacherController>(
      builder: (context, studentParentTeacherController, child) {
        return Column(
          children: [
            ...AppConstants.classSubMenuListTeacher.isEmpty
                ? [
              SizedBox(
                child: Center(
                  child: Text(
                    'No se encontraron datos',
                    style: AppTextStyle.getOutfit400(
                        textSize: 18, textColor: AppColors.secondary),
                  ),
                ),
              )
            ] :
            AppConstants.classSubMenuListTeacher
                .map((e) {
              return GestureDetector(
                onTap: (){
                    if(e['name'] == "Alumnos"){
                      Get.to(() => StudentListScreen(),arguments: {"role": RoleType.teacher});
                    }else if(e['name'] == "Padres"){
                      Get.to(() => TeacherParentListScreen());
                    }else if(e['name'] == "Profesores"){
                      Get.to(() => TeacherListScreen(),arguments: {"role": RoleType.teacher});
                    }else if(e['name'] == "Asignaturas"){
                      Get.to(() => SubjectListScreen(),arguments: {"role": RoleType.teacher});
                    }else{
                      Get.to(() => TimeTableScreen(),
                          arguments: {"role": RoleType.teacher});
                    }
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.greyColor.withOpacity(0.2)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            e['name'] ?? "",
                            style: AppTextStyle.getOutfit400(
                                textSize: 18,
                                textColor: AppColors.secondary),
                          )),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        );
      },
    );
  }
}
