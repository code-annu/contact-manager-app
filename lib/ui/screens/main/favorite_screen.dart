import 'package:flutter/material.dart';
import 'package:contact_manager/domain/entities/contact_entity.dart';
import '../contact/contact_view_screen.dart';
import 'package:contact_manager/domain/services/contact_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ContactService _contactService = ContactService();
  late Stream<List<ContactEntity>> _contactsStream;

  @override
  void initState() {
    super.initState();
    _contactsStream = _contactService.listenToContacts();
  }

  List<ContactEntity> _getFavoriteContacts(List<ContactEntity> contacts) {
    return contacts.where((contact) => contact.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ContactEntity>>(
        stream: _contactsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found'));
          }

          final favoriteContacts = _getFavoriteContacts(snapshot.data!);

          if (favoriteContacts.isEmpty) {
            return const Center(child: Text('No favorite contacts'));
          }

          return ListView.separated(
            itemCount: favoriteContacts.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final contact = favoriteContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    contact.name.isNotEmpty
                        ? contact.name[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(contact.name),
                subtitle: Text(contact.phoneNumber),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactViewScreen(contact: contact),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
