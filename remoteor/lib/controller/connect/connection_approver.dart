import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:remoteor/controller/firebase/store_accessor.dart';
import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:remoteor/modal/user_info.dart';
// import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConnectionApprover{
  Future<void> allowConnection(String accessorId, String? token, String userIp, int port, context)async{
    if(token == null){
      print("whom is to be allowed has sent null token");
      return;
    }
    // SharedPreferences _prefs = await SharedPreferences.getInstance();
    // final user = Provider.of<UserProvider>(context);
    final currentUser = Provider.of<UserProvider>(context,listen: false).user;

    // final username = await _prefs.getString('username');
    // final currentUserid = await _prefs.getString('id');
    // final userName = userProvider.userName;
    var res1 = await http.post(
      Uri.parse('http://4.188.74.40:9090/send-notification'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "title": "Apprved",
        "body": "You are connected with ${currentUser?.name}",
        "screen": "/access",
        "sender":"${currentUser?.name}"
      }),
    );
    if(res1.statusCode==200){
      print("messagge sent");
      // Add this user data to the current user's accessors collection in firestore
      var db = FirebaseFirestore.instance;
      var data = await db.collection('${currentUser?.id}');
      await storeAccessor(currentUser!,accessorId,userIp,port);

      // approve ip of the accessor and add it too.


    }else{
      print("something bad went");
    }
  }
}