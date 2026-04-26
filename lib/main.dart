import 'dart:io';
import 'package:colegia_atenea/controllers/edit_profile_controller.dart';
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
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    show InAppWebViewController;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controllers/store_controller.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Variable reactiva para deep linking — MainScreen la escucha en tiempo real
final RxString pendingDeepLink = ''.obs;
final RxString pendingEid = ''.obs;
final RxString pendingClassId = ''.obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey,
  ));

  if (Platform.isAndroid) {
    InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await Firebase.initializeApp();
  await NotificationService.initialize();

  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("logo");
  DarwinInitializationSettings iosSettings =
      const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true,
          requestSoundPermission: true);
  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosSettings);
  await notificationsPlugin.initialize(initializationSettings);

  // ─── App en foreground: mostrar notificación local ───────────────────────
  FirebaseMessaging.onMessage.listen((event) {
    if (Platform.isAndroid) {
      NotificationService.showNotification(event);
    }
    if (event.notification!.body!.split("|").first == "0") {
      setLoginFalse();
    }
  });

  // ─── App en background: usuario toca la notificación ─────────────────────
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.notification!.body!.split("|").first == "0") {
      Fluttertoast.showToast(msg: 'logOut'.tr);
      return;
    }
    _navigateFromMessage(event);
  });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await AppSharedPreferences.initialization();

  // ─── App terminada: usuario toca la notificación ─────────────────────────
  getInitialMessage();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<StudentParentTeacherController>(
        create: (context) => StudentParentTeacherController(),
      ),
      ChangeNotifierProvider(create: (context) => SplashLoginController()),
      ChangeNotifierProvider(create: (context) => AssistantController()),
      ChangeNotifierProvider(create: (context) => EditProfileController()),
      ChangeNotifierProvider(create: (context) => StoreController()),
    ],
    child: SafeArea(
        child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: WorldLanguage(),
      locale: const Locale('es', 'ES'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      fallbackLocale: const Locale('es', 'ES'),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.routePages,
      theme: ThemeData(
          primarySwatch: createMaterialColor(AppColors.primary),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
          ),
          useMaterial3: false),
    )),
  ));
}

void _navigateFromMessage(RemoteMessage message) {
  final String destination = NotificationService.resolveRoute(message);
  if (destination == "dashboard") return;
  // Leer eid y classId del payload si existen
  final String eid = message.data["eid"] ?? "";
  final String classId = message.data["classId"] ?? "";
  pendingEid.value = eid;
  pendingClassId.value = classId;
  // Actualizar la variable reactiva — MainScreen la detectará automáticamente
  pendingDeepLink.value = destination;
}

void setLoginFalse() async {
  await AppSharedPreferences.loggedOutUser();
  Get.offNamedUntil(AppRoutes.loginScreen, (routes) => false);
}

void getInitialMessage() async {
  RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  if (message == null) return;

  if (message.data["1"] == "0" ||
      (message.notification?.body?.split("|").first == "0")) {
    setLoginFalse();
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _navigateFromMessage(message);
  });
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};

  final int r = Colors.red.toARGB32(),
      g = Colors.green.toARGB32(),
      b = Colors.blue.toARGB32();

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
  return MaterialColor(color.toARGB32(), swatch);
}
