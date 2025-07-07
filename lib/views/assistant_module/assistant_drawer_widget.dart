import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/log_out_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
                const SizedBox(
                  width: 10,
                ),
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
                // const Spacer(),
                const SizedBox(
                  width: 10,
                ),
                Image.asset(AppImages.whiteAppLogo, width: 50, height: 50)
              ],
            ),
          );
        },
      ),
    ),
          const SizedBox(
            height: 10,
          ),

          // ...AppConstants.assistantDrawerAndBottomList.forEach((e){return AssistantDrawerItemWidget(optionName: e.optionName, optionId: e.optionId, currentSelectedIndex: 1);}).toList(),

          ...AppConstants.assistantDrawerAndBottomList.map((e){
            return Consumer<AssistantController>(
              builder: (context,assistantController,child){
                return AssistantDrawerItemWidget(optionName: e.optionName, optionId: e.optionId,
                  svgIconImage: e.optionIcon,
                  currentSelectedIndex: assistantController.currentBottomIndexSelected, assistantController: assistantController,);
              },
            );
          }),
          const Spacer(),
          CustomButtonWidget(
              buttonTitle: "logout".tr,
              suffixIcon: AppImages.loginArrow,
              margin: 10,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return LogOutDialogue(
                          currentLoggedInUserRole: 0);
                    });
              })

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
      this.svgIconImage, required this.assistantController});


  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: currentSelectedIndex == optionId,
      selectedTileColor: AppColors.primary,
      leading:  SvgPicture.asset(

        svgIconImage ?? "",
        width: 25,
        height: 25,
        colorFilter: ColorFilter.mode(currentSelectedIndex == optionId ? AppColors.white : AppColors.primary, BlendMode.srcIn),) ,
      onTap: () {

        if(optionId != 1){
          Get.back();
          assistantController.setCurrentBottomIndexSelected(currentBottomIndexSelected: optionId);
        }else{
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
