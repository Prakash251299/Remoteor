import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:remoteor/constants.dart';
import 'package:remoteor/controller/connect/connection_asker.dart';
import 'package:remoteor/controller/firebase/fetch_users.dart';
import 'package:remoteor/controller/login_logout/logout.dart';
import 'package:remoteor/controller/provider/user_provider.dart';
import 'package:remoteor/share.dart';
// import 'package:remoteor/share.dart';
import 'package:remoteor/view/toast.dart';
import 'package:remoteor/view/user_list/cubit/user_cubit.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  final List<Map<String, String>> dummyUsers = const [
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com'},
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com'},
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com'},
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com'},
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com'},
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com'},
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('User List')),
      body: 
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          BlocProvider(
            create: (context)=>UserCubit()..fetchData(),
            child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              if(state.status==LoadPage.loading){
                return SizedBox();
              }else if(state.status==LoadPage.loaded){
              if(state.users.length==0){
                print("no users");
                return Center(
                  child: Text("No users available",style: TextStyle(color: Colors.white),),
                );
              }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: state.users.map((user) {
                      // children: dummyUsers.map((user) {
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 4,
                          color: Colors.black12,
                          // color: Colors.lightBlue[200],
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            // title: Text(user['name']!,style: TextStyle(color: Colors.white),),
                            // subtitle: Text(user['email']!,style: TextStyle(color: Colors.white)),
                            title: Text(user.name!,style: TextStyle(color: Colors.white),),
                            subtitle: Text(user.email!,style: TextStyle(color: Colors.white)),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () async {
                              // Handle tap
                              final currentUser = Provider.of<UserProvider>(context,listen: false).user;
                              print("Provider username ${currentUser?.name}");
                              showCustomSnackBar(context, 'Clicked on ${user.name}');
                              // showCustomSnackBar(context, 'Clicked on ${user['name']!}');
                              ConnectionAsker _connectionAsker = ConnectionAsker();
                              await _connectionAsker.askToConnect();
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );}else{
              showCustomSnackBar(context, "Something went wrong");
              return
              SizedBox();
            }}),
          ),
          Positioned(
            bottom:50,
            right:20,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white
                ),
                // margin: EdgeInsets.only(bottom: 50,right: 20),
                // color:Colors.lightBlue[300],
                width:65,
                height: 65,
                child: IconButton(
                  icon:Icon(Icons.offline_share_rounded,size: 50,color: Colors.blue[300],),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RemoteApp()));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: Card(
  //       child: ,
  //     ),
  //   );
  // }
// }