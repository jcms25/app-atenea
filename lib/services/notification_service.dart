import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'dart:convert';

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
      id: 0,
      title: event.notification!.title!,
      body: event.notification!.body!.split("|").last,
      notificationDetails: notificationDetails,
      // payload: los datos del push serializados, para poder
      // navegar cuando el usuario toca la notificación estando
      // la app en primer plano.
      payload: jsonEncode(event.data),
    );
  }

  // Determina a qué sección navegar según el payload FCM.
  // Campos esperados en message.data: "type" y/o "section"
  //
  // Valores conocidos:
  //   Exámenes : "Exam Created", "Exam Update"
  //   Notas    : "Notes Add",   "Notes Update"
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
      case "Classroom Event":
        return "classroom";
      case "Autorizacion":
        return "autorizaciones";
      case "Tutoria":
        return "tutoria";
      default:
        return "dashboard";
    }
  }
  // Igual que resolveRoute, pero a partir del Map de datos
  // (usado al tocar una notificación local, cuyo payload es
  // un Map deserializado y no un RemoteMessage).
  static String resolveRouteFromData(Map<String, dynamic> data) {
    final String type = data["type"]?.toString() ?? "";
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
      case "Classroom Event":
        return "classroom";
      case "Autorizacion":
        return "autorizaciones";
      case "Tutoria":
        return "tutoria";
      default:
        return "dashboard";
    }
  }
}