import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';
import '../../services/api.dart';
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
        Consumer2<StudentParentTeacherController, AssistantController>(builder:
            (context, studentParentTeacherController, assistantController,
                child) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: AppColors.primary,
                  elevation: 0.0),
              onPressed: () async {
                // if(currentLoggedInUserRole == 0){
                //
                // }else{
                // }

                try {
                  Get.back();
                  AppConstants.mainScreenKey.currentState?.closeDrawer();
                  studentParentTeacherController.setIsLoading(isLoading: true);
                  RoleType? roleType =
                      studentParentTeacherController.currentLoggedInUserRole;

                  await Api.httpRequest(
                      requestType: RequestType.post,
                      endPoint: Api.logoutEndPoint,
                      body: <String, dynamic>{
                        "user_id": roleType == RoleType.assistant
                            ? assistantController.assistant?.userdata.id
                                .toString()
                            : roleType == RoleType.student ||
                                    roleType == RoleType.teacher
                                ? studentParentTeacherController
                                        .loginModel?.userdata?.wpUsrId ??
                                    ""
                                : studentParentTeacherController
                                        .loginModel?.userdata?.parentWpUsrId ??
                                    ""
                      }).then((response) async {
                    if (response['status']) {
                      AppConstants.mainScreenKey.currentState?.closeDrawer();
                      await AppSharedPreferences.loggedOutUser();
                      studentParentTeacherController.loggedOutClearData();
                      studentParentTeacherController.setIsLoading(
                          isLoading: false);
                      Get.offNamedUntil(
                          AppRoutes.loginScreen, (routes) => false);
                    } else {
                      studentParentTeacherController.setIsLoading(isLoading: false);
                      AppConstants.showCustomToast(
                          status: false,
                          message:
                              response['Message'] ?? response['message'] ?? "");
                    }
                  });
                } catch (exception) {
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
        })
      ],
    );
  }
}

// void logOutApi(String senderId) async {
//   try {
//     final Response response = await post(
//         Uri.parse("https://colegioatenea.es/wp-json/scl-api/v1/logout"),
//         body: <String, dynamic>{"user_id": senderId});
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data["status"]) {
//         SessionManagement sessionManagement = SessionManagement();
//         int? role = await sessionManagement.getRole("Role");
//         SharedPreferences sharedPreferences =
//             await SharedPreferences.getInstance();
//         sharedPreferences.setBool('Login', false);
//         if (role == 0) {
//           sessionManagement.destroySession();
//         } else {
//           sessionManagement.destroySessionParent();
//         }
//         Fluttertoast.showToast(
//             msg: 'logOut'.tr, backgroundColor: AppColors.primary);
//         navigateTo();
//       } else {
//         Fluttertoast.showToast(msg: data["message"]);
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   } catch (exception) {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }
