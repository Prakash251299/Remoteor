
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:remoteor/controller/firebase/store_user_info.dart';
import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:remoteor/modal/user_info.dart';
// import 'package:remoteor/constants.dart';
// import 'package:remoteor/share.dart';
import 'package:remoteor/view/toast.dart';
import 'package:remoteor/view/user_list/user_list.dart';
// import 'package:remoteor/view/toast.dart';
// import 'package:remoteor/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHandler{
  FirebaseFirestore con = FirebaseFirestore.instance;
  // ReadWrite _readWrite = ReadWrite();
  Future<bool> getLoginStatus(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = await prefs.getString('username');
    String? img = await prefs.getString('userimg');
    String? email = await prefs.getString('useremail');
    String? id = await prefs.getString('id');
    MyUserInfo user = MyUserInfo(name, img, email,id);
    Provider.of<UserProvider>(context, listen: false).setUser(user);
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
      // if(await getLoginStatus(context)){
      //   print("already logged in");
      //   Navigator.pop(context); // For removing the previous login screen
      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserList()));
      // }else{
        print("signing in with google");
        var currentUser = await signInWithGoogle();
         MyUserInfo user = MyUserInfo(currentUser.user?.displayName, currentUser.user?.photoURL, currentUser.user?.email, currentUser.user?.uid);

        // Access the provider and update user data
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        print("ishu logged in");
        if(currentUser.user!=null){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('status', true);
          await prefs.setString('username', '${currentUser.user?.displayName}');
          await prefs.setString('userimg', '${currentUser.user?.photoURL}');
          await prefs.setString('useremail', '${currentUser.user?.email}');
          await prefs.setString('id', '${currentUser.user?.uid}');
          // getting messagin token and storing them in firestore
          FirebaseMessaging messaging = FirebaseMessaging.instance;

          // Get the initial token
          String? token = await messaging.getToken();
          if (token != null) {
            print("Initial FCM Token: $token");
            await storeUserInfo(user,token);
          }


          
          /* Remove previous screens and go to the UserList */
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserList()),(route)=>false);
        }else{
          print("user signin returned null user");
        }
    }catch(e){
      print("Error at login(context) function -> $e");
      showCustomSnackBar(context,"Error while sigining in");
    }
  }
}