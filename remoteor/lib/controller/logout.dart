import 'package:flutter/material.dart';
import 'package:remoteor/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(context)async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('status');
  // Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen())).then((v){Navigator.of(context).popUntil(ModalRoute.withName("LoginPage"));});
}