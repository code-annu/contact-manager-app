import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Contacts Screen',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
