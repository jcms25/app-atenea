import 'package:colegia_atenea/views/assistant_module/assistant_main_screen.dart';
import 'package:colegia_atenea/views/screens/login_screen.dart';
import 'package:colegia_atenea/views/screens/main_screen.dart';
import 'package:colegia_atenea/views/screens/personal_main_screen.dart';
import 'package:get/get.dart';

import '../views/screens/splash_screen.dart';
import '../views/screens/role_selection_screen.dart';

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

  //secretaria y personal no docente
  static const String _personalMainScreen = "/personalMainScreen";
  static String get personalMainScreen => _personalMainScreen;

  static const String _roleSelectionScreen = "/roleSelectionScreen";
  static String get roleSelectionScreen => _roleSelectionScreen;

  static final List<GetPage> routePages = [
    GetPage(name: _initialRoute, page: () => const SplashScreen()),
    GetPage(name: _loginScreen, page: () => const LoginScreen()),
    GetPage(name: _studentParentTeacherMainScreen, page: () => const MainScreen()),

    //parent teacher student
    GetPage(name: assistantMainScreen, page: () => const AssistantScreen(currentIndex: 0)),

    //secretaria y personal no docente
    GetPage(name: _personalMainScreen, page: () => const PersonalMainScreen()),

    GetPage(
      name: _roleSelectionScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return RoleSelectionScreen(
          userName: args['userName'],
          userPassword: args['userPassword'],
          isRememberMe: args['isRememberMe'],
          roles: List<String>.from(args['roles']),
        );
      },
    ),

  ];

}