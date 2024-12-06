// import 'dart:convert';
// import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
// import 'package:colegia_atenea/models/Student/Studentlogin.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/assistant/assistant_login_model.dart';
//
// class SessionManagement {
//   void createSession(Studentlogin login,) async{
//     saveModel('Student',login);
//   }
//   void saveModel(String key, Studentlogin login) async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     //0 for studentLogin
//     // 1 for parentLogin
//     await preferences.setInt("Role", 0);
//     await preferences.setString(key,json.encode(login));
//   }
//   Future<int?> getRole(String key) async{
//     SharedPreferences preferences= await SharedPreferences.getInstance();
//     return preferences.getInt("Role") ;
//
//   }
//
//   Future<Studentlogin> getModel(String key) async {
//      SharedPreferences preferences = await SharedPreferences.getInstance();
//     return Studentlogin.fromJson(json.decode(preferences.getString('Student')!));
//   }
//
//   void destroySession() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.remove('Student');
//   }
//
//   void createSessionParent(Parentlogin parentLogin,) async{
//     saveModelParent('Parent',parentLogin);
//     }
//
//   void saveModelParent(String key, Parentlogin login) async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setString(key,json.encode(login));
//     await preferences.setInt("Role", 1);
//     }
//
//   Future<Parentlogin> getModelParent(String key) async {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//     return Parentlogin.fromJson(json.decode(preferences.getString('Parent')!));
//   }
//   void destroySessionParent() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.remove('Parent');
//   }
//
//   void saveAssistant(Assistant assistantLoginData) async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setString('Assistant',json.encode(assistantLoginData));
//     await preferences.setInt("Role", 2);
//   }
//
//   Future<Assistant> getAssistantDetail() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     return Assistant.fromJson(json.decode(preferences.getString('Assistant')!));
//   }
//
//   void destroyAssistantSession() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.remove('Assistant');
//   }
//
// }