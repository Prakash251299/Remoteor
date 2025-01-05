
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remoteor/constants.dart';
import 'package:remoteor/share.dart';
import 'package:remoteor/view/toast.dart';
// import 'package:remoteor/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHandler{
  FirebaseFirestore con = FirebaseFirestore.instance;
  // ReadWrite _readWrite = ReadWrite();
  Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('status') ?? false;
  }
  Future<UserCredential> signInWithGoogle() async {
    print("sign0");
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print("sign1");
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    print("sign2");

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("sign3");

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  
  Future<void> login(context)async {
    try{
      if(await getLoginStatus()){
        print("already logged in");
        Navigator.pop(context); // For removing the previous login screen
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RemoteApp()));
      }else{
        print("signing in with google");
        var user = await signInWithGoogle();
        print("ishu logged in");
        if(user.user!=null){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setBool('status', true);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RemoteApp()));
        }else{
          print("Error user is not logged in even after trying");
          // showSnackBar(context,"Error while sigining in");
        }
      }
    }catch(e){
      print("Error at login(context) function -> $e");
    }
  }
}