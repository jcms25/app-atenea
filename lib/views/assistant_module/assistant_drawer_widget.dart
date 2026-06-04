import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/log_out_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:colegia_atenea/controllers/splash_login_controller.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../custom_widgets/custom_button_widget.dart';
import '../screens/edit_profile_screen.dart';
import 'assistant_classes_screen.dart';

class AssistantDrawerWidget extends StatelessWidget {
  const AssistantDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Consumer<AssistantController>(
              builder: (context, assistantController, child) {
                String profileImage = assistantController.assistant?.userImage ?? "";
                return GestureDetector(
                  onTap: () {
                    Get.to(() => EditProfileScreen(
                      roleType: RoleType.assistant,
                      assistantData: assistantController.assistant,
                      userdata: null,
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 65,
                        width: 65,
                        child: profileImage.isEmpty
                            ? const CircleAvatar(
                          backgroundImage: AssetImage(AppImages.people),
                        )
                            : CircleAvatar(
                          radius: 16.0,
                          backgroundColor: AppColors.primary,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(65.0),
                            child: Image.network(
                              profileImage,
                              fit: BoxFit.cover,
                              height: 65,
                              width: 65,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "hello".tr,
                                style: AppTextStyle.getOutfit300(
                                    textSize: 16, textColor: AppColors.white),
                              ),
                              AutoSizeText(
                                  maxLines: 1,
                                  assistantController.assistant?.displayName ?? "",
                                  style: AppTextStyle.getOutfit600(
                                      textSize: 20, textColor: AppColors.white))
                            ],
                          )),
                      const SizedBox(width: 10),
                      Image.asset(AppImages.whiteAppLogo, width: 50, height: 50)
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ...AppConstants.assistantDrawerAndBottomList.map((e) {
            return Consumer<AssistantController>(
              builder: (context, assistantController, child) {
                return AssistantDrawerItemWidget(
                  optionName: e.optionName,
                  optionId: e.optionId,
                  svgIconImage: e.optionIcon,
                  currentSelectedIndex: assistantController.currentBottomIndexSelected,
                  assistantController: assistantController,
                );
              },
            );
          }),
          const Spacer(),
          Consumer<AssistantController>(
            builder: (context, assistantController, child) {
              List<String> availableRoles = AppSharedPreferences.getAvailableRoles();
              if (availableRoles.length <= 1) return const SizedBox.shrink();
              String currentRole = AppSharedPreferences.getUserLoggedInRole() ?? '';
              List<String> otherRoles = availableRoles.where((r) => r != currentRole).toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cambiar perfil',
                        style: AppTextStyle.getOutfit600(
                            textSize: 13, textColor: AppColors.primary)),
                    const SizedBox(height: 4),
                    ...otherRoles.map((role) {
                      String label = role == 'teacher'
                          ? 'Profesor'
                          : role == 'parent'
                              ? 'Padre/Madre'
                              : role == 'student'
                                  ? 'Alumno'
                                  : 'Asistencia';
                      IconData icon = role == 'teacher'
                          ? Icons.school
                          : role == 'parent'
                              ? Icons.family_restroom
                              : role == 'student'
                                  ? Icons.person
                                  : Icons.assignment_ind;
                      return GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final splashController = Provider.of<SplashLoginController>(context, listen: false);
                          final studentParentTeacherController = Provider.of<StudentParentTeacherController>(context, listen: false);
                          await splashController.switchProfile(
                            newRole: role,
                            studentParentTeacherController: studentParentTeacherController,
                            assistantController: assistantController,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(icon, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(label,
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 16, textColor: AppColors.black)),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
          CustomButtonWidget(
              buttonTitle: "logout".tr,
              suffixIcon: AppImages.loginArrow,
              margin: 10,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return LogOutDialogue(currentLoggedInUserRole: 0);
                    });
              }),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.hasData ? 'v${snapshot.data!.version}' : '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  version,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontFamily: 'Outfit',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AssistantDrawerItemWidget extends StatelessWidget {
  final String optionName;
  final int optionId;
  final int currentSelectedIndex;
  final String? svgIconImage;
  final AssistantController assistantController;

  const AssistantDrawerItemWidget(
      {super.key,
      required this.optionName,
      required this.optionId,
      required this.currentSelectedIndex,
      this.svgIconImage,
      required this.assistantController});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: currentSelectedIndex == optionId,
      selectedTileColor: AppColors.primary,
      leading: SvgPicture.asset(
        svgIconImage ?? "",
        width: 25,
        height: 25,
        colorFilter: ColorFilter.mode(
            currentSelectedIndex == optionId ? AppColors.white : AppColors.primary,
            BlendMode.srcIn),
      ),
      onTap: () {
        if (optionId != 1) {
          Get.back();
          assistantController.setCurrentBottomIndexSelected(
              currentBottomIndexSelected: optionId);
        } else {
          Get.to(() => ChildScreen());
        }
      },
      title: Text(optionName,
          style: AppTextStyle.getOutfit400(
              textSize: 18,
              textColor: currentSelectedIndex == optionId
                  ? AppColors.white
                  : AppColors.primary)),
    );
  }
}
