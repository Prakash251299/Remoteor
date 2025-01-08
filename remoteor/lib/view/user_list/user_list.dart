import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:remoteor/constants.dart';
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

  final List<Map<String, String>> users = const [
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
      appBar: AppBar(title: const Text('User List')),
      body: 
      BlocProvider(
        create: (context)=>UserCubit()..fetchData(),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if(state.status==LoadPage.loading){
            return SizedBox();
          }else if(state.status==LoadPage.loaded){
          if(state.users.length==0){
            print("no users");
            return Center(
              child: Text("No users available"),
            );
          }
        return SingleChildScrollView(
          child: Column(
            children: state.users.map((user) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.name!),
                  subtitle: Text(user.email!),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    // Handle tap
                    final currentUser = Provider.of<UserProvider>(context,listen: false).user;
                    print("Provider username ${currentUser?.name}");
                    showCustomSnackBar(context, 'Clicked on ${user.name}');
                    // await logout(context);
                    // print(_user);
                    
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RemoteApp()));
                  },
                ),
              );
            }).toList(),
          ),
        );}else{
          showCustomSnackBar(context, "Something went wrong");
          return
          SizedBox();
        }}),
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