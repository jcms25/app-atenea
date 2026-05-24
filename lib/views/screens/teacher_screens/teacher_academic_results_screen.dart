import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/followed_up_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_followed_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// Pantalla 2 — Resultados del Seguimiento Académico de un alumno.
/// Muestra las tarjetas de notas a pantalla completa.
class TeacherAcademicResultsScreen extends StatelessWidget {
  final String studentName;

  const TeacherAcademicResultsScreen({
    super.key,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: () {
          Get.back();
        },
        title: Text(
          'Seguimiento Académico',
          style: AppTextStyle.getOutfit600(
              textSize: 20, textColor: AppColors.white),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Cabecera con buscador
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: AppColors.primary,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: AppTextStyle.getOutfit600(
                          textSize: 18, textColor: AppColors.white),
                    ),
                    const SizedBox(height: 15),
                    Consumer<StudentParentTeacherController>(
                      builder: (context, controller, child) {
                        return CustomTextField(
                            filledColor: AppColors.white,
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.secondary,
                            ),
                            hintText: 'Buscar tema, examen',
                            onTextChanged: controller.searchInFollowedUpList,
                            validateFunction: (String? value) {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Lista de resultados
              Expanded(
                child: Consumer<StudentParentTeacherController>(
                  builder: (context, controller, child) {
                    final list = controller.tempListOfStudentFollowedUp;
                    if (list.isEmpty && !controller.isLoading) {
                      return Center(
                        child: Text(
                          'No se encontraron datos',
                          style: AppTextStyle.getOutfit500(
                              textSize: 16, textColor: AppColors.secondary),
                        ),
                      );
                    }
                    return ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          FollowedUpItemDetail? item = list[index].list?[0];
                          return FollowedUpWidget(followedUpItemDetail: item);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context, controller, child) {
              return Visibility(
                visible: controller.isLoading,
                child: LoadingLayout(),
              );
            },
          ),
        ],
      ),
    );
  }
}