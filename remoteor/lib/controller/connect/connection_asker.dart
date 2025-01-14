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



    // String token = await getMessagingToken(user.id);
    // print(token);
  }

  // Future<void> getMessagingToken()async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedToken = await prefs.getString('fcm_message_token');
  //   String? token = await _firebaseMessaging.getToken();
  //   if(token!=savedToken){
  //     await prefs.setString('fcm_message_token', '$token');
  //     // save it to firestore too
  //     print("token changed");
  //   }
  //   print(token);



  //   // FirebaseMessaging.instance.onTokenRefresh
  //   // .listen((fcmToken) {
  //   //   // TODO: If necessary send token to application server.

  //   //   // Note: This callback is fired at each app startup and whenever a new
  //   //   // token is generated.
  //   //   print("new token: $fcmToken");
  //   // })
  //   // .onError((err) {
  //   //   // Error getting token.
  //   //   print("Error getting the token");
  //   // });
  // }
}