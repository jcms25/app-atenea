import 'package:colegia_atenea/services/share_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';
import '../utils/app_images.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async{
  if(message.notification!.body!.split("|").first == "0"){
    await SharedPref.initialization();
    await SharedPref.pref.setBool(SharedPref.isLogin, false);
  }
}


class NotificationService{

  static Future<void> initialize() async{
    //below line will take permission for permission
    //for android it will already given
    //but for iOS it will ask permission
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if(settings.authorizationStatus == AuthorizationStatus.authorized){

      //when app is in background this function will call
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    }
  }


  static void showNotification(RemoteMessage event){
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails("shareNcare_Notification","App Notification",
      priority: Priority.max,
      importance: Importance.max,
      visibility: NotificationVisibility.public,
      playSound: true,
      channelShowBadge: true,
      icon: "logo",
    );

    DarwinNotificationDetails iOSNotificationDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android:  androidNotificationDetails,
        iOS: iOSNotificationDetails
    );

    notificationsPlugin.show(0, event.notification!.title!,event.notification!.body!.split("|").last, notificationDetails);
  }

}