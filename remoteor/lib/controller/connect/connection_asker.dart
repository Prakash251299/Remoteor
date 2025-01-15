import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:remoteor/controller/firebase/fetch_users.dart';
import 'package:remoteor/modal/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConnectionAsker {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> askToConnect(MyUserInfo user)async{
    // await Future.delayed(Duration(seconds: 5));
    var res = await http.get(Uri.parse('https://api.ipify.org?format=json'));
    // print(res.body);
    var data = jsonDecode(res.body);
    print(data['ip']);

    var res1 = await http.post(
      Uri.parse('http://4.188.74.40:8080/send-notification'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": user.token,
        "title": "Connection request",
        "body": "${user.name} wants to connect!"
      }),
    );
    if(res1.statusCode==200){
      print("messagge sent");
    }else{
      print("something bad went");
    }
  }
}