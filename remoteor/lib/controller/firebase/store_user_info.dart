import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remoteor/modal/user_info.dart';

Future<void> storeUserInfo(MyUserInfo currentUser)async{
  var db = FirebaseFirestore.instance;
  await db.collection('users').doc(currentUser.id).set({"name":currentUser.name,"email":currentUser.email,"imgUrl":currentUser.imgUrl,"token":currentUser.token},SetOptions(merge: true));
}