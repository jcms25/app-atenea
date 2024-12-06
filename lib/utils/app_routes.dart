import 'package:colegia_atenea/views/assistant_module/assistant_main_screen.dart';
import 'package:colegia_atenea/views/screens/login_screen.dart';
import 'package:colegia_atenea/views/screens/main_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../views/screens/splash_screen.dart';

class AppRoutes{




  static const String _initialRoute = "/";
  static String get initialRoute => _initialRoute;

  static const String _loginScreen = "/loginScreen";
  static String get loginScreen => _loginScreen;

  //parent teacher student
  static const String _studentParentTeacherMainScreen = "/mainScreen";
  static String get studentParentTeacherMainScreen => _studentParentTeacherMainScreen;


  //assistant
  static const String _assistantMainScreen = "/assistantMainScreen";
  static String get assistantMainScreen => _assistantMainScreen;

  static final List<GetPage> routePages = [
    GetPage(name: _initialRoute, page: () => const SplashScreen()),
    GetPage(name: _loginScreen, page: () => const LoginScreen1()),
    GetPage(name: _studentParentTeacherMainScreen, page: () => const MainScreen()),

    //parent teacher student
    GetPage(name: assistantMainScreen, page: () => const AssistantScreen(currentIndex: 0)),

  ];

}