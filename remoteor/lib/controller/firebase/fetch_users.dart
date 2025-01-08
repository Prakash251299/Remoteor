import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:remoteor/modal/user_info.dart';

Future<List<MyUserInfo>> fetchUsers()async{
  List<MyUserInfo>users = [];
  try{
    var db = FirebaseFirestore.instance;
    var allUsers;
    allUsers = await db
      .collection("users")
      .get();
    print(allUsers.docs.length);
    allUsers.docs.forEach((user){
      users.add(MyUserInfo(user['name'], user['imgUrl'], user['email'], user.id));
    });
  }catch(e){
    print("Error fetching users $e");
  }
  return users;
  // return [];
}