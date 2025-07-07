// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class SharedPref {
//   SharedPref(){
//     initialization();
//   }
//   static String isLogin= "Login";
//   static late SharedPreferences pref;
//
//
//   static Future initialization() async {
//     pref = await SharedPreferences.getInstance();
//
//   }
//
//   static bool checkLogin() {
//     if(pref.getBool(isLogin)==null){
//       return false;
//     }
//     return pref.getBool(isLogin)!;
//   }
// }
