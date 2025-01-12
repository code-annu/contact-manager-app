import 'package:contact_manager/domain/entities/contact_entity.dart';
import 'package:contact_manager/domain/services/contact_service.dart';
import 'package:contact_manager/ui/screens/main/profile_screen.dart';
import 'package:flutter/material.dart';

import 'contact_screen.dart';
import 'favorite_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  ContactService contactService = ContactService();

  // List of screens for each bottom navigation item
  final List<Widget> _screens = [
    const ContactsScreen(),
    const FavoritesScreen(),
    ProfileScreen(),
  ];

  // List of titles for the AppBar
  final List<String> _titles = [
    'Contacts',
    'Favorites',
    'Profile',
  ];

  void createNewContact() async {
    ContactEntity contactEntity = ContactEntity(
      userid: '',
      name: "Anurag",
      phoneNumber: '9696348678',
      email: 'code.annu@gmail.com',
    );
    await contactService.createNewContact(contactEntity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                createNewContact();
              },
              tooltip: 'Add Contact',
              child: const Icon(Icons.add),
            )
          : null, // Show FAB only on the "Contacts" tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
