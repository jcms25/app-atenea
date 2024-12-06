import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class TeacherClassListScreen extends StatefulWidget {
  const TeacherClassListScreen({super.key});

  @override
  State<TeacherClassListScreen> createState() => _TeacherClassListScreenState();
}

class _TeacherClassListScreenState extends State<TeacherClassListScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getListOfClassesAssignToTeacher(
          showLoader: studentParentTeacherController
                  ?.listOfClassAssignToTeacher.isEmpty ??
              true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<StudentParentTeacherController>(
          builder: (context, studentParentTeacherController, child) {
            return Column(
              children: [
                ...studentParentTeacherController
                        .listOfClassAssignToTeacher.isEmpty
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
                      ]
                    : studentParentTeacherController.listOfClassAssignToTeacher
                        .map((e) {
                        return Container(
                          width: MediaQuery.sizeOf(context).width,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.greyColor.withOpacity(0.2)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                e.cName ?? "",
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
