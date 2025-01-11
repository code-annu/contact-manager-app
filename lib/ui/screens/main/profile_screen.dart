import 'package:contact_manager/domain/services/user_authentication.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserAuthService _userAuthService = UserAuthService();

  void showUserInfo() async {
    final user = _userAuthService.getCurrentUser();
    if (user != null) {
      print('User ID: ${user.uid}');
      print('User Name: ${user.displayName}');
      print('User Email: ${user.email}');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: (){showUserInfo();}, child: Text("Click me")),
    );
  }
}
