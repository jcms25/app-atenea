import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/teacher/teacher_class_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class TeacherClassListDropdown extends StatelessWidget {
  final int fromWhichScreen;
  //1 for students
  //2 for parents
  //3 for teachers
  //4 for subjects
  //5 for time table
  const TeacherClassListDropdown({super.key, required this.fromWhichScreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white
      ),
      child: Consumer<StudentParentTeacherController>(
        builder:(context,studentParentTeacherController,child){
          return DropdownButton<TeacherClassItem>(
              underline: SizedBox.shrink(),
               isExpanded: true,
              value: studentParentTeacherController.currentSelectedClass,
              items: studentParentTeacherController.listOfClassAssignToTeacher.map((e){
            return DropdownMenuItem<TeacherClassItem>(
                value: e,
                child: Text(e.cName ?? "-",style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),));
          }).toList(), onChanged: (TeacherClassItem? teacherClassItem){
              studentParentTeacherController.setCurrentSelectedClass(teacherClass: teacherClassItem);
              if(fromWhichScreen == 5){
                studentParentTeacherController.getTimeTableData(classId: teacherClassItem?.cid ?? "", studentId: null);
              }else if(fromWhichScreen == 4){
                studentParentTeacherController.getListOfSubjects(classId: teacherClassItem?.cid ?? "", wpId: null, roleType: RoleType.teacher);
              }else if(fromWhichScreen == 1){
                studentParentTeacherController.getListOfStudents(classId: teacherClassItem?.cid ?? "", roleType: RoleType.teacher);
              }else if(fromWhichScreen == 2){
                studentParentTeacherController.getListOfParents(classId: teacherClassItem?.cid ?? "");
              }else{  
                studentParentTeacherController.getListOfTeachers(studentId: null, classId: teacherClassItem?.cid ?? "",roleType: RoleType.teacher);
              }
          });
        }
      ),
    );
  }
}
