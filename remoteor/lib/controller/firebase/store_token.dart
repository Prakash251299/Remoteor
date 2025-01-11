import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> storeTokenInFirestore(String? id,String token)async{
  if(id==null||id==""){
    print("refreshed token can not be stored in firebase as id is null");
    return;
  }
  var db = FirebaseFirestore.instance;
  await db.collection('users').doc(id).set({"token":token},SetOptions(merge: true));
  print("token stored in firestore");
}