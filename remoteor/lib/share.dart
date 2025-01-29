// import 'dart:ffi';
import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remoteor/constants.dart';
import 'package:remoteor/controller/connect/connection_approver.dart';
import 'package:remoteor/controller/login_logout/logout.dart';
import 'package:remoteor/modal/user_info.dart';
import 'package:remoteor/view/toast.dart';
import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RemoteApp extends StatelessWidget {
  // const RemoteApp({Key? key}) : super(key: key);
  String sender = "";
  String senderName = "";
  String? token = "";
  String userIp = "";
  RemoteApp(this.sender, this.senderName, this.token, this.userIp);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote File Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConnectionPage(sender, senderName, token, userIp),
    );
  }
}

class ConnectionPage extends StatefulWidget {
  // const ConnectionPage({Key? key}) : super(key: key);
  String sender = "";
  String senderName = "";
  String? token = "";
  String userIp = "";
  ConnectionPage(this.sender, this.senderName, this.token, this.userIp);

  @override
  State<ConnectionPage> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage>
    with SingleTickerProviderStateMixin {
  // _ConnectionPageState(sender);
  late AnimationController _controller;
  List<double> radii = [100.0, 150.0, 200.0];
  HttpServer? server;
  var socket;
  var connection;
  var client;
  int callConnector = 0;
  int lock = 1;
  int menuWidth = 0;
  int port = 9000;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (int i = 0; i < radii.length; i++) {
          radii[i] += 1;
          if (radii[i] > 300.0) {
            radii[i] = 100.0;
          }
        }
      });
    });

    //  For handling back button click
    //   SystemChannels.platform.setMethodCallHandler((message) async {
    //     if (message == 'SystemNavigator.pop') {
    //       // Handle the back button press
    //       print('Back button pressed!');
    //       return Future.value(null); // Block the default action
    //     }
    //     return Future.value(message);
    //   });
  }

  Future<int> requestForStorage() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int apiLevel = androidInfo.version.sdkInt;
      PermissionStatus status;
      if (apiLevel < 29) {  // for android version 9 or below
        // print();
        status = await Permission.storage.request();
      } else { // for android 10+
        status = await Permission.manageExternalStorage.status;
      }
        // var status = await Permission.manageExternalStorage.request();
        // print(status);
        // var status = await Permission .request();
        // print("ishu");
        if (status.isGranted) {
          print("Permission Granted");
          return 1;
        } else if (status.isDenied) {
          print("Permission not granted, Requesting again.");
          if(apiLevel<29){
            status = await Permission.storage.request();
          }else{
            await Permission.manageExternalStorage.request();
            status = await Permission.manageExternalStorage.status;
          }
          if (status.isGranted) {
            print("Permission granted");
            return 1;
          } else {
            print("Permission denied");
            return 0;
          }
        } else if (status.isPermanentlyDenied) {
          print("Permission Permanently Denied. Open settings to enable.");
          openAppSettings(); // Open app settings if permanently denied
          if(apiLevel<29){
            status = await Permission.storage.request();
          }else{
            status = await Permission.manageExternalStorage.status;
          }
          if (status.isGranted) {
            print("Permission granted by opening settings");
            return 1;
          } else {
            print("Permission denied after opening settings too");
            showCustomSnackBar(context, "storage access not allowed");
            return 0;
          }
        }
    }
    return 0;
  }

  Future<void> serve() async {
    try {
      var handler = const Pipeline().addHandler(
          createStaticHandler("/storage/emulated/0", listDirectories: true));
      // String remoteIp = request.context['remoteAddress'].address.host;
      if (server != null) {
        await server?.close();
      }
      server = await shelf_io.serve(handler, '0.0.0.0', local_port);
      // // server = await shelf_io.serve(handler, '192.168.29.206', local_port);
      print(
          'Serving locally at http://${server?.address.host}:${server?.port}');
      setState(() {
        callConnector = 1;
        lock = 1;
      });
      await serveRemotely();
    } catch (e) {
      await server?.close();
      print("Local server error $e");
      print("Do start the server first");
      showCustomSnackBar(context, 'Do start the server first');
      setState(() {
        callConnector = 0;
      });
    }
  }

  Future<void> serveRemotely() async {
    if (client != null) {
      await client.close(); // Close the SSH client
      client = null;
    }

    // Reconnect after cleanup

    client = SSHClient(
      await SSHSocket.connect(host, 22),
      username: username,
      onPasswordRequest: () => password,
    );

    /* Use server's firewall allowed port here for accessing without restriction */
    /* For security use server's firewall restricted port like 9000 that will be managed by other allowed port. This allowed port (e.g. 8080) forwards request on the server by checking requestor's ip address whether it is allowed to access or not */
    final forward = await client.forwardRemote(host: host, port: 9000);
    if (forward == null) {
      print('Failed to forward remote port');
      callConnector = 0;
      return;
    }
    // fun(forward);
    print("connected");

    await for (connection in forward.connections) {
      // final socket = await Socket.connect('157.35.48.137', 8000);
      print("remote_ip: ${connection.runtimeType}");
      // print(connection.);
      // if(connection.remoteAddress.address!="157.35.48.137"){
      //   return;
      // }
      socket = await Socket.connect('0.0.0.0', 8000);
      // socket = await Socket.connect('49.47.129.38', 8000);
      // socket = await Socket.connect('192.168.177.24', 8000);
      // var r = await Process.run('who', ['-u']);
      // print("who: -> $r");
      try {
        // print(socket.remoteAddress.address);
        connection.stream.cast<List<int>>().pipe(socket);
        socket.cast<List<int>>().pipe(connection.sink);
      } catch (e) {
        print(
            "Error occurred while piping data to servers using local socket -> $e");
        callConnector = 0;
      }
    }
    client.close();
    await client.done;
  }

  @override
  Future<void> dispose() async {
    _controller.dispose();
    await socket.close();
    await connection.sink.close();
    // await client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Sharing Page',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: menuWidth == 200
                      ? Icon(
                          Icons.close,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
              onTap: () async {
                // launch('');
                String url = "http://$host:8080";
                // String url = "http://localhost:8080";
                await launchUrl(Uri.parse(url));
                return;
                print("more vert clicked");
                if (menuWidth == 0) {
                  setState(() {
                    menuWidth = 200;
                  });
                } else {
                  setState(() {
                    menuWidth = 0;
                  });
                }
              },
            )
          ],
        ),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            // menuWidth==200;
            Center(
              child: GestureDetector(
                onTap: () {
                  // Function to run on button click
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (double radius in radii)
                      Container(
                        width: radius,
                        height: radius,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade300,
                            width: 2.0,
                          ),
                        ),
                      ),
                    Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              callConnector == 1 ? Colors.green : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                            child: Icon(
                              Icons.power_settings_new,
                              color: Colors.white,
                              size: 30,
                            ),
                            onTap: () async {
                              /* For stopping continuous button press */
                              if(lock == 0){
                                return;
                              }
                              print("connection button pressed");
                              /* This checks for callConnector if it is '1' sharing is on */

                              if (callConnector != 0) {
                                showCustomSnackBar(context, "Already sharing");
                                setState(() {
                                  lock = 0;
                                });
                                await server?.close();
                                setState(() {
                                  callConnector = 0;
                                  lock = 1;
                                });
                                // await socket.close();
                                // await connection.sink.close();
                                return;
                              }else{
                              // if(callConnector==0){
                              setState(() {
                                lock = 0;
                              });
                              
                              
                              int status = await requestForStorage();

                              // Fluttertoast.showToast(
                              //     msg: "You started sharing your files",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.CENTER,
                              //     timeInSecForIosWeb: 1,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                              // status = await Permission.manageExternalStorage.status;
                              if (status==1) {
                                await serve();
                                showCustomSnackBar(
                                  context, "You started sharing your files");
                              } else {
                                print("Permission is not given");
                              }
                            }
                            }
                            )),
                  ],
                ),
              ),
            ),
            Center(
              child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return widget.sender == ""
                        ? SizedBox()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                            ),
                            height:
                                MediaQuery.of(context).size.height * 35 / 100,
                            width: MediaQuery.of(context).size.width * 80 / 100,
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.sender = "";
                                            print("Connection rejected");
                                          });
                                        },
                                        icon: Icon(Icons.cancel,
                                            size: height / 20,
                                            color: Colors.grey),
                                      ),
                                    ]),
                                // SizedBox(height:15),
                                Icon(
                                  Icons.offline_share,
                                  size: height / 6.5,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${widget.senderName} wants to connect",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                GestureDetector(
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height*30/100,
                                    height: height / 17,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Colors.blue,
                                    ),
                                    child: Center(
                                        child: Text("Allow",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white))),
                                  ),
                                  onTap: () async {
                                    ConnectionApprover _approver =
                                        ConnectionApprover();
                                    await _approver.allowConnection(
                                        widget.sender,
                                        widget.token,
                                        widget.userIp,
                                        port,
                                        context);
                                    print("Connection approved");
                                    setState(() {
                                      widget.sender = "";
                                    });
                                  },
                                ),
                                // Container(width:50,height:50,color: Colors.red,),
                              ],
                            ),
                          );
                  }),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: menuWidth.toDouble(),
                height: 400,
                padding: EdgeInsets.only(right: 5),
                // color: Colors.black,
                child: Column(
                    // alignment: Alignment.topRight,
                    children: [
                      menuWidth == 200
                          ? Center(
                              child: InkWell(
                                child: Container(
                                    height: 40,
                                    // width:menuWidth==200?menuWidth:200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Color.fromARGB(255, 50, 76, 79),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                                onTap: () async {
                                  logout(context);
                                },
                              ),
                            )
                          : SizedBox(),
                    ])),
          ],
        ),
      ),
    );
  }
}
