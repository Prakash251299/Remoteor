import 'package:flutter/material.dart';
import 'package:remoteor/modal/user_info.dart';
// import 'user_model.dart'; // Import the user model

class UserProvider with ChangeNotifier {
  MyUserInfo? _user;

  MyUserInfo? get user => _user; // Getter for user info

  // Method to set user data after login/signup
  void setUser(MyUserInfo user) {
    _user = user;
    notifyListeners(); // Notify UI of changes
  }

  // Clear user data on logout
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}