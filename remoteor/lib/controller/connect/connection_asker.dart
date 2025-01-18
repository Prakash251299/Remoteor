import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:remoteor/controller/firebase/fetch_users.dart';
// import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:remoteor/modal/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConnectionAsker {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> askToConnect(MyUserInfo user,context)async{
    // await Future.delayed(Duration(seconds: 5));
    var res = await http.get(Uri.parse('https://api.ipify.org?format=json'));
    // final currentUser = Provider.of<UserProvider>(context,listen: false).user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentUsertoken = await prefs.getString('token');
    print("current user token");
    print(currentUsertoken);
    print("user token to get notification");
    print(user.token);
    var data = jsonDecode(res.body);
    String userIp = data['ip'];
    // print(data['ip']);

    var res1 = await http.post(
      Uri.parse('http://4.188.74.40:9090/send-notification'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": user.token,
        "title": "Connection request",
        "body": "${user.name} wants to connect!",
        "screen": "/share",
        "sender":"${user.id}",
        "senderName":'${user.name}',
        "userIp":"$userIp",
        "senderToken":"${currentUsertoken}",
      }),
    );
    if(res1.statusCode==200){
      print("messagge sent");
    }else{
      print("something bad went");
    }
  }
}