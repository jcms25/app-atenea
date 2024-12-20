import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/teacher/teacher_class_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class TeacherClassListDropdown extends StatelessWidget {
  final int fromWhichScreen;
  final Color? backgroundColor;
  final bool? fromWhereStudentListCalled;
  final double? height;
  //1 for students
  //2 for parents
  //3 for teachers
  //4 for subjects
  //5 for time table
  //6 for exam list
  //7 for send message screen to parent,student
  //8 for marks screen (on class changed get list of subjects and exam api called)
  const TeacherClassListDropdown({super.key, required this.fromWhichScreen, this.backgroundColor, this.fromWhereStudentListCalled, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor ?? AppColors.white
      ),
      child: Align(
        alignment: Alignment.centerRight,
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
                  }).toList(), onChanged: (TeacherClassItem? teacherClassItem) async{
                if(studentParentTeacherController.currentSelectedClass?.cid != teacherClassItem?.cid){
                  studentParentTeacherController.setCurrentSelectedClass(teacherClass: teacherClassItem);
                  if(fromWhichScreen == 5){
                    studentParentTeacherController.getTimeTableData(classId: teacherClassItem?.cid ?? "", studentId: null);
                  }
                  else if(fromWhichScreen == 4){
                    studentParentTeacherController.getListOfSubjects(classId: teacherClassItem?.cid ?? "", wpId: null, roleType: RoleType.teacher);
                  }
                  else if(fromWhichScreen == 1){
                    studentParentTeacherController.setSelectedStudentForFollowUp(studentItem: null);
                    studentParentTeacherController.setListOfStudents(listOfStudents: []);
                    studentParentTeacherController.getListOfStudents(classId: teacherClassItem?.cid ?? "", roleType: RoleType.teacher, sortedAccordingToLastName: fromWhereStudentListCalled ?? false);
                  }
                  else if(fromWhichScreen == 2){
                    studentParentTeacherController.getListOfParents(classId: teacherClassItem?.cid ?? "");
                  }
                  else if(fromWhichScreen == 3){
                    studentParentTeacherController.getListOfTeachers(studentId: null, classId: teacherClassItem?.cid ?? "",roleType: RoleType.teacher);
                  }
                  else if(fromWhichScreen == 6){
                    studentParentTeacherController.getListOfExams(classId: teacherClassItem?.cid ?? "", wpUserId: "", roleType: RoleType.teacher);
                  }
                  else if(fromWhichScreen == 8) {
                    studentParentTeacherController.setViewMarkSubjectSelected(subjectItem: null);
                    await studentParentTeacherController.getListOfSubjects(classId: teacherClassItem?.cid ?? "", wpId: null, roleType: RoleType.teacher).then((response) async{
                      await studentParentTeacherController.getListOfExams(classId: teacherClassItem?.cid ?? "", wpUserId: null, roleType: RoleType.teacher);
                    });
                  }
                  else{
                    studentParentTeacherController.getListOfStudents(classId: teacherClassItem?.cid ?? "", roleType: RoleType.teacher, sortedAccordingToLastName: false);
                    studentParentTeacherController.getListOfParents(classId: teacherClassItem?.cid ?? "");
                  }
                }
              });
            }
        ),
      ),
    );
  }
}
