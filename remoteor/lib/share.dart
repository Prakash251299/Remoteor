// import 'dart:ffi';
import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remoteor/constants.dart';
import 'package:remoteor/controller/login_logout/logout.dart';
import 'package:remoteor/view/toast.dart';
import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dartssh2/dartssh2.dart';

class RemoteApp extends StatelessWidget {
  const RemoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote File Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConnectionPage(),
    );
  }
}

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<double> radii = [100.0, 150.0, 200.0];
  HttpServer? server;
  var socket;
  var connection;
  var client;
  int callConnector = 0;
  int menuWidth = 0;

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
  }

  Future<void> requestForStorage() async {
    // var status = await Permission.manageExternalStorage.request();
    var status = await Permission.manageExternalStorage.status;
    // print(status);
    // var status = await Permission .request();
    // print("ishu");
    if (status.isGranted) {
      print("Permission Granted");
    } else if (status.isDenied) {
      print("Permission not granted, Requesting again.");
      await Permission.manageExternalStorage.request();
      var t = await Permission.manageExternalStorage.status;
      if (t.isGranted) {
        print("Permission granted");
      } else {
        print("Permission denied");
      }
    } else if (status.isPermanentlyDenied) {
      print("Permission Permanently Denied. Open settings to enable.");
      openAppSettings(); // Open app settings if permanently denied
      var t = await Permission.manageExternalStorage.status;
      if (t.isGranted) {
        print("Permission granted by opening settings");
      } else {
        print("Permission denied after opening settings too");
      }
    }
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
      // server = await shelf_io.serve(handler, '192.168.29.206', local_port);
      print(
          'Serving locally at http://${server?.address.host}:${server?.port}');
      await serveRemotely();
    } catch (e) {
      print("Local server error $e");
      print("Do start the server first");
      // Fluttertoast.showToast(
      //   msg: "Do start the server first",
      //   toastLength: Toast.LENGTH_SHORT,
      //   // gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );
      showCustomSnackBar(context, 'Do start the server first');
      callConnector = 0;
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

    final forward = await client.forwardRemote(host: host, port: 9090);
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
      // if(connection.remoteAddress.address!="157.35.48.137"){
      //   return;
      // }
      socket = await Socket.connect('0.0.0.0', 8000);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Connection Page',style: TextStyle(color: Colors.white),),
          actions: [
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: menuWidth == 200
                      ? Icon(Icons.close,color: Colors.white,)
                      : Icon(Icons.more_vert,color: Colors.white,)),
              onTap: () {
                // _controller.addListener(() {
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
                // });
                // });
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
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          child: Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                            size: 30,
                          ),
                          onTap: () async {
                            await serve();
                            return;
                            /* This checks for callConnector if it is '1' then no further sharing will be done 
                          if any error occures it becomes '0' and executes below connection commands */

                            if (callConnector != 0) {
                              showCustomSnackBar(context,"Already logged in");
                              return;
                            }
                            callConnector = 1;
                            await requestForStorage();
                            // Fluttertoast.showToast(
                            //     msg: "You started sharing your files",
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.CENTER,
                            //     timeInSecForIosWeb: 1,
                            //     textColor: Colors.white,
                            //     fontSize: 16.0);
                            showCustomSnackBar(context,"You started sharing your files");
                            var status = await Permission.manageExternalStorage.status;
                            if (status.isGranted) {
                              await serve();
                            } else {
                              print("Permission is not given");
                            }
                          },
                        )),
                  ],
                ),
              ),
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
