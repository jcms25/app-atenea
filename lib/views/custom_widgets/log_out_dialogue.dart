import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';

class LogOutDialogue extends StatelessWidget {
  final int currentLoggedInUserRole;
  // 0 means assistant,
  //1 means student or parent or teacher
  const LogOutDialogue({super.key, required this.currentLoggedInUserRole});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        'sure'.tr,
        style: AppTextStyle.getOutfit400(
            textSize: 18, textColor: AppColors.secondary),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: AppColors.primary,
                elevation: 0.0),
            onPressed: () {
              Get.back();
            },
            child: Text(
              'negativeButton'.tr,
              style: AppTextStyle.getOutfit400(
                  textSize: 14, textColor: AppColors.white),
            )),
       Consumer2<StudentParentTeacherController,AssistantController>(
         builder : (context,studentParentTeacherController,assistantController,child){
           return  ElevatedButton(
               style: ElevatedButton.styleFrom(
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5)),
                   backgroundColor: AppColors.primary,
                   elevation: 0.0),
               onPressed: () async{

                 // if(currentLoggedInUserRole == 0){
                 //
                 // }else{
                 // }

                 try{
                   studentParentTeacherController.setIsLoading(isLoading: true);
                   studentParentTeacherController.setIsLoading(isLoading: true);
                   AppConstants.mainScreenKey.currentState?.closeDrawer();
                   await AppSharedPreferences.loggedOutUser();
                   studentParentTeacherController.loggedOutClearData();
                   studentParentTeacherController.setIsLoading(isLoading: false);
                   Get.offNamedUntil(AppRoutes.loginScreen, (routes) => false);
                 }catch(exception){
                   studentParentTeacherController.setIsLoading(isLoading: false);
                 }
                 // _scaffoldKey.currentState!.closeDrawer();
                 // getSenderId();
               },
               child: Text(
                 'positiveButton'.tr,
                 style: AppTextStyle.getOutfit400(
                     textSize: 14, textColor: AppColors.white),
               ));
         }
       )
      ],
    );
  }
}
