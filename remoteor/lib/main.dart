// import 'dart:ffi';
// import 'dart:io';
// import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

void main()async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.ensureInitialized();

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
  @override
  Widget build(BuildContext context) {
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
}