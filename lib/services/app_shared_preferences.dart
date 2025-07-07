import 'dart:convert';

import 'package:colegia_atenea/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assistant/assistant_login_model.dart';

class AppSharedPreferences {
  static const String _userDataKey = "userdata";
  static const String _baseAuthToken = "basicAuthToken";
  static const String _loggedInUserRole = "loggedInUserRole";
  static const String _loggedInUserCredential = "loggedInUserCredential";
  static const String _keyData = "keyData";

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


  // save userdata
  static Future<void> saveUserData({required Userdata? userdata,String? basicAuthToken,String? role}) async{
    await sharedPreferences?.setString(_userDataKey, jsonEncode(userdata));
    if(basicAuthToken != null){
      await sharedPreferences?.setString(_baseAuthToken, basicAuthToken);
    }
    if(role != null){
      await sharedPreferences?.setString(_loggedInUserRole, role);
    }
  }

  //get user data
  static Userdata? getUserData() {
    String? userData = sharedPreferences?.getString(_userDataKey);
   if(userData != null){
     Userdata userdata = Userdata.fromJson(jsonDecode(userData));
     return userdata;
   }
    return null;
  }

  //save basic authentication token
  static Future<void> saveBasicAuthToken({required String basicAuthToken}) async{
    await sharedPreferences?.setString(_baseAuthToken, basicAuthToken);
  }

  //get basic authentication token
  static String? getBasicAthToken(){
    return sharedPreferences?.getString(_baseAuthToken);
  }
  //save assistant logged in data
  static Future<void> saveAssistantLoggedInData(
      {required Assistant assistant,required String basicAuthToken}) async {
    await sharedPreferences?.setString(_userDataKey, jsonEncode(assistant.userdata?.data));
    await sharedPreferences?.setString(_loggedInUserRole, "assistant");
    await sharedPreferences?.setString(_baseAuthToken, basicAuthToken);
  }

  //get assistant logged in data
  static AssistantData? getAssistantLoggedInData() {
    String? assistantData = sharedPreferences?.getString(_userDataKey);
    return assistantData == null
        ? null
        : AssistantData.fromJson(jsonDecode(assistantData));
  }

  //get user logged in role
  static String? getUserLoggedInRole(){
    String? role = sharedPreferences?.getString(_loggedInUserRole);
    return role;
  }

  //save key data
  static Future<void> saveKeyData({KeyData? keyData}) async{
    await sharedPreferences?.setString(_keyData, jsonEncode(keyData));
  }

  //get key data
  static KeyData? getKeyData() {
    String? keyData = sharedPreferences?.getString(_keyData);
    return keyData != null ? KeyData.fromJson(jsonDecode(keyData)) : null;
  }


  //logged out user
  static Future<void> loggedOutUser() async{
    await sharedPreferences?.remove(_userDataKey);
    await sharedPreferences?.remove(_loggedInUserRole);
    await sharedPreferences?.remove(_baseAuthToken);
    await sharedPreferences?.remove(_keyData);
  }
}


