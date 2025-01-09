import 'dart:convert';

import 'package:http/http.dart' as http;
class ConnectionAsker {
  Future<void> askToConnect()async{
    var res = await http.get(Uri.parse('https://api.ipify.org?format=json'));
    // print(res.body);
    var data = jsonDecode(res.body);
    print(data['ip']);
  }
}