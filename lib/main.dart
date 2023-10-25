
import 'dart:async';
import 'package:colegia_atenea/screens/nav_screens/navigation_screen.dart';
import 'package:colegia_atenea/screens/assistant_module/assistant_main_screen.dart';
import 'package:colegia_atenea/screens/login_screen.dart';
import 'package:colegia_atenea/services/notification_service.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/services/share_preferences.dart';
import 'package:colegia_atenea/services/world_languages.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_strings.dart';
import 'package:colegia_atenea/utils/lifecycle_manager.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/item_logo_rounded.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


FlutterLocalNotificationsPlugin notificationsPlugin=FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey,
  ));
  await Firebase.initializeApp();
  await NotificationService.initialize();
  AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings("logo");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true
  );
  InitializationSettings initializationSettings= InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosSettings
  );
  // bool? initialize = await notificationsPlugin.initialize(initializationSettings);
  await notificationsPlugin.initialize(initializationSettings);
  // FirebaseMessaging.instance.getToken().then((value) => print(value));
  FirebaseMessaging.onMessage.listen((event) {
      NotificationService.showNotification(event);
      if(event.notification!.body!.split("|").first == "0") {
        setLoginFalse();
      }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if(event.notification!.body!.split("|").first == "0"){
      Fluttertoast.showToast(msg: 'logOut'.tr);
    }
  });
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
      LifeCycleManager(key: null,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: const MyHomePage(),
            translations: WorldLanguage(), //Language class from world_languages.dart
            locale: const Locale('es', 'ES'), // translations will be displayed in that locale
            fallbackLocale: const Locale('es', 'ES'), // specify the fallback locale in case an invalid locale is selected.
            theme: ThemeData(
              primarySwatch: createMaterialColor(AppColors.primary),
            ),
          ))
  );
}

  void setLoginFalse() async{

  await SharedPref.initialization();
  await SharedPref.pref.setBool(SharedPref.isLogin, false);
  Fluttertoast.showToast(msg: 'logOut'.tr);
  Get.to(() => const LoginScreen());

  }

  void getInitialMessage() async{
   RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
   if(message!=null){
     RemoteNotification? notification = message.notification;
     AndroidNotification? android = message.notification!.android;
     if(notification != null && android != null){
       if(message.data["1"] == "0"){
         setLoginFalse();
       }
     }
   }
 }


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('es','ES')
      ],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate
      ],
    );


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



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkWhetherUserLoginOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: AppColors.primary,
          child: Stack(
            children: [
              Container(
                color: AppColors.primary,
              ),
              const Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: ItemWhiteOpacityCircle(),),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(AppImages.title),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 280,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            AppStrings.title,
                            textAlign: TextAlign.center,
                            style: CustomStyle.title
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "optimize".tr,
                          textAlign: TextAlign.center,
                          style: CustomStyle.optimize,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style:CustomStyle.txtvalue1,
                                children: [
                                  TextSpan(text: '© ${DateTime.now().year} '),
                                  const TextSpan(
                                      text: AppStrings.iGexSolutions,
                                      style: TextStyle(
                                          color: AppColors.primary)),
                                  const TextSpan(text: AppStrings.copyRights),
                                ]))
                      ],
                    ),
                  )),
              const Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: ItemLogoRounded(),
              ),
            ],
          ),
        ));
  }

  void checkWhetherUserLoginOrNot() async {
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 2) {
      SharedPref();
      Timer(const Duration(seconds: 5), () =>
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
              SharedPref.checkLogin() == true
                  ? const AssistantScreen(currentIndex: 0,)
                  : const LoginScreen())));
    }
    else {
      SharedPref();
      Timer(const Duration(seconds: 5), () =>
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
              SharedPref.checkLogin() == true
                  ? const NavigationScreen()
                  : const LoginScreen())));
    }
  }
}