import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/splash_login_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String userName;
  final String userPassword;
  final bool isRememberMe;
  final List<String> roles;

  const RoleSelectionScreen({
    super.key,
    required this.userName,
    required this.userPassword,
    required this.isRememberMe,
    required this.roles,
  });

  String _roleLabel(String role) {
    switch (role) {
      case 'parent':
        return 'Padre / Madre';
      case 'teacher':
        return 'Profesor/a';
      case 'student':
        return 'Alumno/a';
      case 'assistant':
        return 'Asistencia';
      default:
        return role;
    }
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'parent':
        return Icons.family_restroom;
      case 'teacher':
        return Icons.school;
      case 'student':
        return Icons.menu_book;
      case 'assistant':
        return Icons.assignment_ind;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      image: AppImages.logo,
      imageType: 0,
      circularImage: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.10),
          height: 160,
          width: 160,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppColors.primary, width: 3.0, style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(160)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.5),
                spreadRadius: 0,
                blurRadius: 25,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              AppImages.logo,
              errorBuilder: (a, b, c) {
                return const Icon(
                  Icons.error_outline,
                  color: AppColors.primary,
                );
              },
            ),
          ),
        ),
      ),
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            "¿Con qué perfil quieres entrar?",
            style: AppTextStyle.getOutfit600(
                textSize: 22, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          Text(
            "Tienes más de un perfil en el colegio.",
            style: AppTextStyle.getOutfit300(
                textSize: 16, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 40),
          Consumer3<SplashLoginController, StudentParentTeacherController,
              AssistantController>(
            builder: (context, splashLoginController, appController,
                assistantController, child) {
              return Column(
                children: roles.map((role) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          _roleIcon(role),
                          color: Colors.white,
                          size: 24,
                        ),
                        label: Text(
                          _roleLabel(role),
                          style: AppTextStyle.getOutfit600(
                              textSize: 18, textColor: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await splashLoginController.userLogin(
                            userName: userName,
                            userPassword: userPassword,
                            userRole: role,
                            isRememberMe: isRememberMe,
                            studentParentTeacherController: appController,
                            assistantController: assistantController,
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "← Volver al login",
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: AppColors.secondary),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      childWidgetMarginFromTop: EdgeInsets.only(top: 150),
      loadingWidget: Consumer<SplashLoginController>(
        builder: (context, splashLoginController, child) {
          return Visibility(
              visible: splashLoginController.isLoading,
              child: const LoadingLayout());
        },
      ),
    );
  }
}
