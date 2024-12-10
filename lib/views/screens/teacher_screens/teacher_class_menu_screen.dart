import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';


class TeacherClassMenuScreen extends StatelessWidget {
  const TeacherClassMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<StudentParentTeacherController>(
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
                        return Container(
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
                        );
                      })
              ],
            );
          },
        ),
        Consumer<StudentParentTeacherController>(
          builder: (context, studentParentTeacherController, child) {
            return Visibility(
                visible: studentParentTeacherController.isLoading,
                child: const LoadingLayout());
          },
        )
      ],
    );
  }
}
