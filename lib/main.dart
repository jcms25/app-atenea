import 'dart:io';

import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/splash_login_controller.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/services/notification_service.dart';
import 'package:colegia_atenea/services/world_languages.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey,
  ));

  await Firebase.initializeApp();
  await NotificationService.initialize();
  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("logo");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);
  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosSettings);
  // bool? initialize = await notificationsPlugin.initialize(initializationSettings);
  await notificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.instance.getToken().then((value) => print("token is : $value"));
  FirebaseMessaging.onMessage.listen((event) {
    if (Platform.isAndroid) {
      NotificationService.showNotification(event);
    }
    if (event.notification!.body!.split("|").first == "0") {
      setLoginFalse();
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.notification!.body!.split("|").first == "0") {
      Fluttertoast.showToast(msg: 'logOut'.tr);
    }
  });
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await AppSharedPreferences.initialization();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<StudentParentTeacherController>(
        create: (context) => StudentParentTeacherController(),
      ),
      ChangeNotifierProvider(create: (context) => SplashLoginController()),
      ChangeNotifierProvider(create: (context) => AssistantController())
    ],
    child: SafeArea(
        child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const SplashScreen(),
      // home: const LoginScreen1(),
      translations: WorldLanguage(),
      //Language class from world_languages.dart
      locale: const Locale('es', 'ES'),
      // translations will be displayed in that locale
      fallbackLocale: const Locale('es', 'ES'),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.routePages,
      // specify the fallback locale in case an invalid locale is selected.
      theme: ThemeData(
          primarySwatch: createMaterialColor(AppColors.primary),
          useMaterial3: false),
    )),
  ));
}

void setLoginFalse() async {
  await AppSharedPreferences.loggedOutUser();
  Get.offNamedUntil(AppRoutes.loginScreen,(routes) => false);
}

void getInitialMessage() async {
  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;
    if (notification != null && android != null) {
      if (message.data["1"] == "0") {
        setLoginFalse();
      }
    }
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

