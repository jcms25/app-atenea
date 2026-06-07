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

  // Consulta los roles del usuario y decide si hacer login directo
  // o navegar a la pantalla de selección de perfil.
  Future<void> loginOrSelectRole({
    required String userName,
    required String userPassword,
    required bool isRememberMe,
    required StudentParentTeacherController studentParentTeacherController,
    required AssistantController assistantController,
  }) async {
    setIsLoading(isLoading: true);
    try {
      dynamic response = await Api.httpRequest(
        requestType: RequestType.post,
        endPoint: Api.getUserRoles,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'username': userName.trim(),
        },
      );

      List<String> roles = [];
      if (response['status'] == true) {
        roles = List<String>.from(response['roles']);
      }

      setIsLoading(isLoading: false);

      if (roles.length == 1) {
        // Un solo perfil: login directo
        await userLogin(
          userName: userName,
          userPassword: userPassword,
          userRole: roles.first,
          isRememberMe: isRememberMe,
          studentParentTeacherController: studentParentTeacherController,
          assistantController: assistantController,
        );
      } else if (roles.length > 1) {
        // Doble perfil: navegar a pantalla de selección
        Get.toNamed(AppRoutes.roleSelectionScreen, arguments: {
          'userName': userName,
          'userPassword': userPassword,
          'isRememberMe': isRememberMe,
          'roles': roles,
        });
      } else {
        // Usuario no encontrado: intentar login para que el servidor
        // devuelva el mensaje de error apropiado
        await userLogin(
          userName: userName,
          userPassword: userPassword,
          userRole: 'parent',
          isRememberMe: isRememberMe,
          studentParentTeacherController: studentParentTeacherController,
          assistantController: assistantController,
        );
      }
    } catch (_) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(
          status: false, message: 'Error de conexión. Inténtalo de nuevo.');
    }
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
          : userRole == "teacher"
          ? "teacher"
          : userRole == "parent"
          ? "parent"
          : userRole == "student"
          ? "student"
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
            message: "Inicio de sesión correcto");

        resetLoginScreen();

        await AppSharedPreferences.saveActiveUserCredential(
            userName: userName, userPassword: userPassword);

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
          if (roleOfUser == "parent") {
            await AppSharedPreferences.saveKeyData(keyData: loginModel.keyData);
          }
          await _fetchAndSaveAvailableRoles(userName: userName, userPassword: userPassword);
          setIsLoading(isLoading: false);
          Get.offNamedUntil(
              AppRoutes.studentParentTeacherMainScreen, (route) => false);
        } else if (roleOfUser == "assistant") {
          Assistant assistant = Assistant.fromJson(response);

          await AppSharedPreferences.saveAssistantLoggedInData(
              assistant: assistant,
              basicAuthToken: assistant.basicAuthToken);
          assistantController.setAssistant(assistant: assistant.userdata?.data);
          await _fetchAndSaveAvailableRoles(userName: userName, userPassword: userPassword);
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

    // Escucha la rotación del token FCM: cuando Firebase emite
    // un token nuevo, se registra en el servidor sin necesidad
    // de que el usuario rehaga login.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateDeviceToken();
    });

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

        // Refresca el token FCM por si rotó mientras la app
        // estuvo cerrada (el login no se repite en este flujo).
        updateDeviceToken();

        Get.offNamedUntil(
            AppRoutes.studentParentTeacherMainScreen, (routes) => false);
      } else {
        AssistantData? assistant = AppSharedPreferences.getAssistantLoggedInData();
        assitantController?.setAssistant(assistant: assistant);
        Get.offNamedUntil(AppRoutes.assistantMainScreen, (routes) => false);
      }
    } else {
      Get.offNamedUntil(AppRoutes.loginScreen, (route) => false);
    }
  }

  // Actualiza el token FCM en el servidor sin necesidad de
  // rehacer login. Se llama al arrancar con sesión activa y
  // cada vez que Firebase rota el token (onTokenRefresh).
  Future<void> updateDeviceToken() async {
    try {
      String? role = AppSharedPreferences.getUserLoggedInRole();
      // Solo aplica a los roles con token FCM por usuario
      if (role != "student" && role != "parent" && role != "teacher") {
        return;
      }
      Userdata? userdata = AppSharedPreferences.getUserData();
      String uid = role == "parent"
          ? userdata?.parentWpUsrId ?? ""
          : userdata?.wpUsrId ?? "";
      if (uid.isEmpty) return;

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      // El endpoint update-device-token usa permission_callback
      // '__return_true' y recibe el uid por el body. NO se envía
      // cabecera Authorization: hacerlo dispara una autenticación
      // en WordPress que devuelve 401.
      await Api.httpRequest(
        requestType: RequestType.post,
        endPoint: Api.updateDeviceToken,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'uid': uid,
          'device_uuid': fcmToken,
          'device_type': io.Platform.isAndroid ? "Android" : "Ios",
        },
      );
    } catch (exception) {
      // Actualizar el token es una acción de fondo:
      // si falla, se reintentará en el próximo arranque
      // o en el próximo onTokenRefresh.
    }
  }

  // Obtiene los roles disponibles del usuario y los guarda en SharedPreferences
  Future<void> _fetchAndSaveAvailableRoles({
    required String userName,
    required String userPassword,
  }) async {
    try {
      dynamic response = await Api.httpRequest(
        requestType: RequestType.post,
        endPoint: Api.getUserRoles,
        header: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: <String, dynamic>{
          'username': userName,
        },
      );
      if (response['status'] == true) {
        List<String> roles = List<String>.from(response['roles']);
        await AppSharedPreferences.saveAvailableRoles(roles: roles);
      }
    } catch (_) {
      // Si falla, no bloqueamos el login
    }
  }

  // Cambia de perfil sin cerrar sesión
  Future<void> switchProfile({
    required String newRole,
    required StudentParentTeacherController studentParentTeacherController,
    required AssistantController assistantController,
  }) async {
    try {
      setIsLoading(isLoading: true);

      Map<String, dynamic>? credentials = AppSharedPreferences.getActiveUserCredential();
      if (credentials == null) {
        setIsLoading(isLoading: false);
        return;
      }

      String userName = credentials['userName'] ?? '';
      String userPassword = credentials['userPassword'] ?? '';
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      dynamic response = await Api.httpRequest(
        requestType: RequestType.post,
        endPoint: Api.loginEndPoint,
        header: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: <String, dynamic>{
          'username': userName,
          'password': userPassword,
          'reg_select_role': newRole,
          'device_uuid': fcmToken,
          'device_type': io.Platform.isAndroid ? "Android" : "Ios",
        },
      );

      if (response['status'] == true) {
        if (newRole == 'teacher' || newRole == 'parent' || newRole == 'student') {
          LoginModel loginModel = LoginModel.fromJson(response);
          await AppSharedPreferences.saveUserData(
            basicAuthToken: loginModel.basicAuthToken,
            userdata: loginModel.userdata,
            role: newRole,
          );
          studentParentTeacherController.setLoginModel(userdata: loginModel.userdata);
          studentParentTeacherController.setRole(
            role: newRole == 'student'
                ? RoleType.student
                : newRole == 'parent'
                    ? RoleType.parent
                    : RoleType.teacher,
          );
          if (newRole == 'parent') {
            await AppSharedPreferences.saveKeyData(keyData: loginModel.keyData);
          }
          setIsLoading(isLoading: false);
          studentParentTeacherController.setCurrentBottomIndexSelected(index: 0);
          Get.offNamedUntil(AppRoutes.studentParentTeacherMainScreen, (route) => false);
          studentParentTeacherController.getDashboardData(showLoader: true);
        } else if (newRole == 'assistant') {
          Assistant assistant = Assistant.fromJson(response);
          await AppSharedPreferences.saveAssistantLoggedInData(
            assistant: assistant,
            basicAuthToken: assistant.basicAuthToken,
          );
          assistantController.setAssistant(assistant: assistant.userdata?.data);
          setIsLoading(isLoading: false);
          Get.offNamedUntil(AppRoutes.assistantMainScreen, (route) => false);
        }
      } else {
        setIsLoading(isLoading: false);
        AppConstants.showCustomToast(
          status: false,
          message: response['message'] ?? 'Error al cambiar de perfil',
        );
      }
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: '$exception');
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
