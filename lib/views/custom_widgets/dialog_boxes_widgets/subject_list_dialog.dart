import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/subject_list_model.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_textstyle.dart';

class SubjectListDialog extends StatelessWidget {
  const SubjectListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
              return CheckboxListTile(
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: AppColors.secondary, width: 2)),
                  activeColor: AppColors.white,
                  checkColor: AppColors.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  title: Text(
                    'Todo',
                    style: AppTextStyle.getOutfit400(
                        textSize: 16, textColor: AppColors.black),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  value: studentParentTeacherController.isAllSubjectSelected,
                  onChanged: (bool? value) {
                    if(value ?? false){

                      studentParentTeacherController.setIsAllSubjectSelected(
                          isAllSubjectSelected: value ?? false);
                    }else{
                      studentParentTeacherController.setIsAllSubjectSelected(isAllSubjectSelected: false);
                      studentParentTeacherController.setListOfSelectedSubjectsId(listOfSelectedSubjectsId: []);
                    }
                  });
            }),
            Expanded(child: Consumer<StudentParentTeacherController>(
              builder: (context, studentParentTeacherController, child) {
                return studentParentTeacherController.listOfSubject.isNotEmpty ? ListView.builder(
                    itemCount:
                        studentParentTeacherController.tempListOfSubject.length,
                    itemBuilder: (context, index) {
                      SubjectItem subjectItem = studentParentTeacherController
                          .tempListOfSubject[index];
                      return CheckboxListTile(
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                              side: BorderSide(
                                  color: AppColors.secondary, width: 2)),
                          activeColor: AppColors.white,
                          checkColor: AppColors.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                          side: BorderSide(
                            width: 1,
                            color: AppColors.secondary
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          title: Text(
                            subjectItem.subName ?? "",
                            style: AppTextStyle.getOutfit400(
                                textSize: 16, textColor: AppColors.black),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: studentParentTeacherController
                              .listOfSelectedSubjectsId
                              .contains(subjectItem),
                          onChanged: (bool? value) {
                            if (value ?? false) {
                              studentParentTeacherController.addSelectedSubject(
                                  subject: subjectItem);
                            } else {
                              studentParentTeacherController
                                  .removeSelectedSubject(subject: subjectItem);
                            }
                          });
                    }) : Center(
                  child: Text('Sujetos no encontrados',
                  style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
                  ),
                );
              },
            )),
            CustomButtonWidget(
                padding: 10, buttonTitle: 'Bueno', onPressed: () {
                  Get.back();
            }),
          ],
        ),
      ),
    );
  }
}
