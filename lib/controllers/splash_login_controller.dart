import 'dart:io' as io;

import 'package:colegia_atenea/models/assistant/assistant_login_model.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../services/api.dart';
import '../utils/app_routes.dart';
import 'assistant_controller.dart';
import 'student_parent_teacher_controller.dart';

class SplashLoginController extends ChangeNotifier {
  //loader
  bool isLoading = false;

  void setIsLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  //password visibility handler
  bool isObscure = false;

  void setIsObscure({required bool isObscure}) {
    this.isObscure = isObscure;
    notifyListeners();
  }

  //current selected role for login
  String currentSelectedRole = AppConstants.roleDropDown[0];

  void setSelectedRole({required String selectedRole}) {
    currentSelectedRole = selectedRole;
    notifyListeners();
  }

  //set remember me
  bool isRememberMe = false;

  void setIsRememberMe({required bool status}) {
    isRememberMe = status;
    notifyListeners();
  }

  //login user
  Future<void> userLogin(
      {required String userName,
      required String userPassword,
      required String userRole,
      required bool isRememberMe,
      required StudentParentTeacherController studentParentTeacherController,
      required AssistantController assistantController}) async {
    try {
      setIsLoading(isLoading: true);
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      String roleOfUser = userRole == AppConstants.roleDropDown[1]
          ? "student"
          : userRole == AppConstants.roleDropDown[2]
              ? "parent"
              : userRole == AppConstants.roleDropDown[3]
                  ? "teacher"
                  : "assistant";

      dynamic response = await Api.httpRequest(
          requestType: RequestType.post,
          endPoint: Api.loginEndPoint,
          header: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: <String, dynamic>{
            'username': userName,
            'password': userPassword,
            'reg_select_role': roleOfUser,
            'device_uuid': fcmToken,
            'device_type': io.Platform.isAndroid ? "Android" : "Ios"
          });
      if (response['status']) {
        if (isRememberMe) {
          await AppSharedPreferences.saveLoggedInCredential(userCredential: {
            "userName": userName,
            "userPassword": userPassword,
            "userRole": userRole
          });
        }

        AppConstants.showCustomToast(
            status: response['status'],
            message: "Iniciar sesión correctamente");

        resetLoginScreen();

        if (roleOfUser == "student" ||
            roleOfUser == "parent" ||
            roleOfUser == "teacher") {
          LoginModel loginModel = LoginModel.fromJson(response);
          await AppSharedPreferences.saveUserData(
            basicAuthToken: loginModel.basicAuthToken,
              userdata: loginModel.userdata, role: roleOfUser);
          studentParentTeacherController.setLoginModel(userdata: loginModel.userdata);
          studentParentTeacherController.setRole(
              role: roleOfUser == "student"
                  ? RoleType.student
                  : roleOfUser == "parent"
                      ? RoleType.parent
                      : RoleType.teacher);
          setIsLoading(isLoading: false);
          Get.offNamedUntil(
              AppRoutes.studentParentTeacherMainScreen, (route) => false);
        } else if (roleOfUser == "assistant") {
          Assistant assistant = Assistant.fromJson(response);
          await AppSharedPreferences.saveAssistantLoggedInData(
              assistant: assistant);
          assistantController.setAssistant(assistant: assistant);
          Get.offNamedUntil(AppRoutes.assistantMainScreen, (route) => false);
          setIsLoading(isLoading: false);
        }
      } else {
        setIsLoading(isLoading: false);
        AppConstants.showCustomToast(
            status: false,
            message: response['message'] ?? response['Message'] ?? "");
      }
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //checked if user already logged in or not
  void checkUserAlreadyLoggedIn(
      {required StudentParentTeacherController? studentParentTeacherController,
      required AssistantController? assitantController}) async {
    String? role = AppSharedPreferences.getUserLoggedInRole();

    if (role != null) {
      if (role == "student" || role == "parent" || role == "teacher") {
        Userdata? userdata = AppSharedPreferences.getUserData();
        studentParentTeacherController?.setLoginModel(userdata: userdata);
        studentParentTeacherController?.setRole(
            role: role == "student"
                ? RoleType.student
                : role == "parent"
                    ? RoleType.parent
                    : RoleType.teacher);

        Get.offNamedUntil(
            AppRoutes.studentParentTeacherMainScreen, (routes) => false);
      } else {
        Assistant? assistant = AppSharedPreferences.getAssistantLoggedInData();
        assitantController?.setAssistant(assistant: assistant);
        Get.offNamedUntil(AppRoutes.assistantMainScreen, (routes) => false);
      }
    } else {
      Get.offNamedUntil(AppRoutes.loginScreen, (route) => false);
    }
  }

  //reset login screen
  void resetLoginScreen() {
    isRememberMe = false;
    setSelectedRole(selectedRole: AppConstants.roleDropDown[0]);
    isObscure = false;
    notifyListeners();
  }
}
