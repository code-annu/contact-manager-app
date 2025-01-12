import 'package:contact_manager/domain/services/user_authentication.dart';
import 'package:contact_manager/ui/screens/auth/welcome_screen.dart';
import 'package:contact_manager/util/user_credential_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserAuthService _authService = UserAuthService();
  final UserCredentialUtil _credentialUtil = UserCredentialUtil();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'You are not logged in.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ),
                  ); // Navigate to login screen
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    // If the user is logged in, show their profile information
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                currentUser?.displayName?[0].toUpperCase() ?? "G",
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${currentUser?.displayName ?? "Guest"}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${currentUser?.email ?? "Not Available"}',
              style: const TextStyle(fontSize: 16),
            ),
            // You can display other user details here if needed
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                // Perfmorm logout
                await _authService.signOut();
                await _credentialUtil.clearCredentials();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (builder) => WelcomeScreen()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
