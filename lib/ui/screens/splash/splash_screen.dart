import 'package:contact_manager/util/user_credential_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/welcome_screen.dart';
import '../main/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserCredentialUtil _credentialsUtil = UserCredentialUtil();

  @override
  void initState() {
    super.initState();
    _checkCredentials();
  }

  /// Checks saved credentials and attempts automatic login.
  Future<void> _checkCredentials() async {
    try {
      // Retrieve saved credentials
      final credentials = await _credentialsUtil.getCredentials();
      final String? email = credentials['email'];
      final String? password = credentials['password'];

      if (email != null && password != null) {
        // Attempt to log in with saved credentials
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Navigate to HomeScreen if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Navigate to WelcomeScreen if no credentials are found
        _navigateToWelcomeScreen();
      }
    } on FirebaseAuthException catch (_) {
      // Navigate to WelcomeScreen if login fails
      _navigateToWelcomeScreen();
    }
  }

  /// Navigates to the WelcomeScreen.
  void _navigateToWelcomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png', // Replace with your actual asset path
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
