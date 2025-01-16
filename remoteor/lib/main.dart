// import 'dart:ffi';
// import 'dart:io';
// import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remoteor/controller/firebase/notification_handler/notification.dart';
import 'package:remoteor/controller/firebase/store_token.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:remoteor/constants.dart';
import 'package:remoteor/controller/login_logout/login_handler.dart';
import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:remoteor/firebase_options.dart';
import 'package:remoteor/share.dart';
import 'package:remoteor/view/login_page.dart';
import 'package:remoteor/view/user_list/user_list.dart';
// import 'dart:async';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;
// import 'package:shelf_static/shelf_static.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:dartssh2/dartssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  // await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
  print("Background message: ${message.notification?.body.toString()}");
  PushNotificationService.showNotification(message);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var _firebaseMessaging = FirebaseMessaging.instance;

  /* fcm token refreshes here */
  _firebaseMessaging.onTokenRefresh.listen((token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /* if user is logged in only then token is stored in firestore */
    if(prefs.getBool('status')==true){
      print("refreshing token");
      String? id = await prefs.getString('id');
      await storeTokenInFirestore(id,token);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // UserProvider instance
      ],
      child: const MyApp(),
    ),
    // const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote File Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({Key? key}) : super(key: key);

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage>{
  
  LoginHandler loginController = LoginHandler();

  Widget home(){
    return Scaffold(
        body: FutureBuilder(future: loginController.getLoginStatus(context),
          builder: (BuildContext context, snapshot) {
            print('main is fine');
            print(snapshot.data);
              if (!snapshot.hasData) {
                // while data is loading:
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // data loaded:
                var status = snapshot.data;
                status ??= false; // status becomes false incase of null value
                return status==true?UserList():LoginScreen();
              }
            },
          ),
      );
    
  }

  @override
  Widget build(BuildContext context) {
    // return Text("hi");
    return MaterialApp(
      routes: {'/home': (context) => home(),
        '/share': (context) => RemoteApp("",""),
      },
      initialRoute: '/home',
    );
  }
}