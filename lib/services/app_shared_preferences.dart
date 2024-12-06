import 'dart:convert';

import 'package:colegia_atenea/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/student_parent_teacher_controller.dart';
import '../models/assistant/assistant_login_model.dart';

class AppSharedPreferences {
  static const String _userDataKey = "userdata";
  static const String _loggedInUserRole = "loggedInUserRole";
  static const String _loggedInUserCredential = "loggedInUserCredential";

  static SharedPreferences? sharedPreferences;

  static Future<void> initialization() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  //save login credentials
  static Future<void> saveLoggedInCredential({required Map<String,dynamic> userCredential}) async {
    await sharedPreferences?.setString(_loggedInUserCredential, jsonEncode(userCredential));
  }

  //get saved logged in credentials
  static Map<String,dynamic>? getSavedLoggedInCredential(){
    String? savedLoggedInCredential = sharedPreferences?.getString(_loggedInUserCredential);
    return  savedLoggedInCredential != null ? jsonDecode(savedLoggedInCredential) : null;
  }

  //save user data
  static Future<void> saveLoginData(
      {required LoginModel loginData, required String role}) async {
    await sharedPreferences?.setString(_userDataKey, jsonEncode(loginData));
    await sharedPreferences?.setString(_loggedInUserRole, role);
  }

  //get user data
  static LoginModel? getUserData() {
    String? userData = sharedPreferences?.getString(_userDataKey);
    return userData == null ? null : LoginModel.fromJson(jsonDecode(userData));
  }

  //save assistant logged in data
  static Future<void> saveAssistantLoggedInData(
      {required Assistant assistant}) async {
    await sharedPreferences?.setString(_userDataKey, jsonEncode(assistant));
    await sharedPreferences?.setString(_loggedInUserRole, "assistant");
  }

  //get assistant logged in data
  static Assistant? getAssistantLoggedInData() {
    String? assistantData = sharedPreferences?.getString(_userDataKey);
    return assistantData == null
        ? null
        : Assistant.fromJson(jsonDecode(assistantData));
  }

  //get user logged in role
  static String? getUserLoggedInRole(){
    String? role = sharedPreferences?.getString(_loggedInUserRole);
    return role;
  }


  //logged out user
  static Future<void> loggedOutUser() async{
    await sharedPreferences?.remove(_userDataKey);
    await sharedPreferences?.remove(_loggedInUserRole);
  }
}


