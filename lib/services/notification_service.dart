import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification!.body!.split("|").first == "0") {
    await AppSharedPreferences.initialization();
    await AppSharedPreferences.loggedOutUser();
  }
}

class NotificationService {

  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    }
  }

  static void showNotification(RemoteMessage event) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "shareNcare_Notification",
      "App Notification",
      priority: Priority.max,
      importance: Importance.max,
      visibility: NotificationVisibility.public,
      playSound: true,
      channelShowBadge: true,
      icon: "logo",
    );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    notificationsPlugin.show(
      0,
      event.notification!.title!,
      event.notification!.body!.split("|").last,
      notificationDetails,
    );
  }

  /// Determina a qué sección navegar según el payload FCM.
  /// Campos esperados en message.data: "type" y/o "section"
  ///
  /// Valores conocidos:
  ///   Exámenes : "Exam Created", "Exam Update"
  ///   Notas    : "Notes Add",   "Notes Update"
  static String resolveRoute(RemoteMessage message) {
    final String type = message.data["type"] ?? "";

    switch (type) {
      case "Exam Created":
      case "Exam Update":
        return "exams";
      case "Notes Add":
      case "Notes Update":
        return "grades";
      case "Event Add":
      case "Event Update":
        return "events";
      case "Circular":
        return "circular";
      case "Message":
      case "New Sub Message":
        return "messages";
      case "Evaluations":
        return "evaluations";
      default:
        return "dashboard";
    }
  }
}
