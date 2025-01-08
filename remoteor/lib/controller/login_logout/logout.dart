import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:remoteor/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(context)async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await GoogleSignIn().signOut();
  await prefs.remove('status');
  await prefs.remove('username');
  await prefs.remove('userimg');
  await prefs.remove('useremail');
  await prefs.remove('id');
  Provider.of<UserProvider>(context, listen: false).clearUser();
  // Navigator.pop(context);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(route)=>false);
}