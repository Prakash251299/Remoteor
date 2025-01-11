import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:remoteor/controller/Permission/notification_permission.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:remoteor/modal/user_info.dart';
import 'package:remoteor/view/error/notification_error.dart';
import 'package:remoteor/view/toast.dart';
// import 'package:remoteor/view/user_list/user_list.dart';

Future<List<MyUserInfo>> fetchUsers(context)async{
  await fcmNotificationPermission(context);
  // if(permitted==0){
  //   showCustomSnackBar(context,"Do allow notification, restart");
  //   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NotificationError()),(route)=>false);

  // }
  var _firebaseMessaging = FirebaseMessaging.instance;

  List<MyUserInfo>users = [];
  try{
    var db = FirebaseFirestore.instance;
    var allUsers;
    allUsers = await db
      .collection("users")
      .get();
    print(allUsers.docs.length);
    allUsers.docs.forEach((user){
      users.add(MyUserInfo(user['name'], user['imgUrl'], user['email'], user.id));
    });
  }catch(e){
    print("Error fetching users $e");
  }
  return users;
  // return [];
}

Future<String> getMessagingToken(userid)async{
  String token = "";
  var db = FirebaseFirestore.instance;
  var data = await db.collection('users').doc(userid).get();
  token = data['token'];
  return token;
}
