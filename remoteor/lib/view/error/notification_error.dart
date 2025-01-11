import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remoteor/view/user_list/user_list.dart';

class NotificationError extends StatelessWidget {
  const NotificationError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,title: Text("Notification is must",style: TextStyle(color: Colors.white),),),
      backgroundColor: Colors.black,
      body: 
        Center(
          child: InkWell(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.red,
                child: Text("Allow notification",style: TextStyle(color: Colors.white),)),
              
              onTap: () async {
                await openAppSettings();
                var _firebaseMessaging = FirebaseMessaging.instance;
                // NotificationSettings settings =
                    // await _firebaseMessaging.requestPermission();
                NotificationSettings settings = await _firebaseMessaging.requestPermission(
                  alert: true,
                  badge: true,
                  sound: true,
                  announcement: true,
                  provisional: true,
                  carPlay: true,
                );
                            if (settings.authorizationStatus ==
                    AuthorizationStatus.authorized) {
                  print("permission granted");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => UserList()),
                      (route) => false);
                  // return;
                }else{
                print("permission denied again");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationError()),
                    (route) => false);
                }
              }),
        )
      // ]),
    );
    // );
  }
}
