import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remoteor/modal/user_info.dart';

Future<void> storeAccessor(MyUserInfo currentUser,String accessorId,String userIp,int port)async{
  var db = FirebaseFirestore.instance;
  await db.collection('accessors').doc(currentUser.id).set({"${accessorId}":"1"},SetOptions(merge: true));
  await db.collection('devicePermissions').doc(userIp).set({"port":port},SetOptions(merge: true));
}