import 'dart:io';
import 'package:adb/adb.dart';
import 'package:remoteor/share.dart';

class ScreenMirror{
  Future<void> mirror()async{
    print("mirroring");
    ConnectionPageState c = ConnectionPageState();
    int status = await c.requestForStorage();
    if(status==0){
      print("Permission not given");
      return;
    }
    try {
      final adb = Adb();
      // List connected devices
      final devices = await adb.devices();
      print('Connected Devices: $devices');

    // Enable ADB over TCP/IP on port 5555
    // ProcessResult result = await Process.run('adb', ['tcpip', '5555']);
    // ProcessResult result = await Process.run('adb',['shell']);
    // print(result.stdout);
    // print(result.stderr);
  } catch (e) {
    print('Error enabling ADB over TCP: $e');
  }
  }
}