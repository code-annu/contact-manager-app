import 'package:contact_manager/ui/screens/auth/login_screen.dart';
import 'package:contact_manager/ui/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to Contact Manager',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Manage your contacts efficiently and securely.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Buttons Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                  CustomOutlinedButton(
                    label: 'Signup',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => SignUpScreen()));
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    label: 'Login',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => LoginScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
