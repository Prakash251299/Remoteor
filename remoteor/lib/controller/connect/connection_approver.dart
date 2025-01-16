import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConnectionApprover{
  Future<void> allowConnection(String token,context)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // final user = Provider.of<UserProvider>(context);
    final username = await _prefs.getString('username');
    // final userName = userProvider.userName;
    var res1 = await http.post(
      Uri.parse('http://4.188.74.40:8080/send-notification'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "title": "Apprved",
        "body": "You are connected with ${username}",
        "screen": "/access",
        "sender":"${username}"
      }),
    );
    if(res1.statusCode==200){
      print("messagge sent");
    }else{
      print("something bad went");
    }
  }
}