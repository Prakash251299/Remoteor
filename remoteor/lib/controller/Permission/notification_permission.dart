import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remoteor/view/error/notification_error.dart';

Future<void> fcmNotificationPermission(context) async {
  var _firebaseMessaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await _firebaseMessaging.requestPermission();
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      provisional: true,
      carPlay: true,
    );

  if(settings.authorizationStatus==AuthorizationStatus.authorized){
    // await openAppSettings();
    print("permission granted");
    return;
  }else{
    print("fcmNotificationPermission permission denied");
    // while(true){
      await openAppSettings();
      if(settings.authorizationStatus==AuthorizationStatus.authorized){
        print("permission granted");
        return;
      }
      print("permission denied again");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NotificationError()),(route)=>false);

    // }
  }
  // print('Permission granted: ${settings.authorizationStatus}');
}
