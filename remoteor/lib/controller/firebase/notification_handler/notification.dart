import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize local notifications for displaying messages when app is in foreground.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in foreground: ${message.notification?.title}');
      showNotification(message);
    });
  }

  static void showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }
}













// import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';

// class NotificationHandler{


//   Future<void> initializeNotifications() async {
//     var _firebaseMessaging = FirebaseMessaging.instance;
//     // Request permission
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       announcement: true,
//       provisional: true,
//       carPlay: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("Notification permission granted.");  
//     }else{
//       if(settings.authorizationStatus==AuthorizationStatus.provisional){
//         print("Notification provisional granted.");
//       }else{
//         print("Permission not granted");
//         return;
//       }
//     }

//       // Get device token
//       // _deviceToken = await _firebaseMessaging.getToken();
//       // print("Device Token: $_deviceToken");

//       // Listen for foreground messages
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print("Foreground message received: ${message.notification?.title}");
//         // showDialog(
//         //   context: context,
//         //   builder: (_) => AlertDialog(
//         //     title: Text(message.notification?.title ?? "No Title"),
//         //     content: Text(message.notification?.body ?? "No Body"),
//         //   ),
//         // );
//       });

//       // Handle message when the app is opened from a terminated state
//       FirebaseMessaging.instance.getInitialMessage().then((message) {
//         if (message != null) {
//           print("App opened from terminated state: ${message.notification?.title}");
//         }
//       });

//       // Listen for messages when the app is in the background
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print("App opened from background state: ${message.notification?.title}");
//       });
//     // } else {
//     //   print("Notification permission denied.");
//     // }
//   }

// } 