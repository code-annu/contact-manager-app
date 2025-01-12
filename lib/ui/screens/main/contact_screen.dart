import 'package:flutter/material.dart';
import 'package:contact_manager/domain/entities/contact_entity.dart';
import '../contact/contact_view_screen.dart';
import 'package:contact_manager/domain/services/contact_service.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactService _contactService = ContactService();
  final TextEditingController _searchController = TextEditingController();
  late Stream<List<ContactEntity>> _contactsStream;

  List<ContactEntity>? _filteredContacts;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _contactsStream = _contactService.listenToContacts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ContactEntity> _filterContacts(List<ContactEntity> contacts) {
    if (_searchQuery.isEmpty) return contacts;
    return contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(_searchQuery) ||
            contact.phoneNumber.contains(_searchQuery))
        .toList();
  }

  List<ContactEntity> _getFavoriteContacts(List<ContactEntity> contacts) {
    return contacts.where((contact) => contact.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        StreamBuilder<List<ContactEntity>>(
          stream: _contactsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Error loading contacts')),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(); // Skip if no contacts
            }

            final favoriteContacts = _getFavoriteContacts(snapshot.data!);

            if (favoriteContacts.isEmpty) {
              return const SizedBox(); // Skip if no favorites
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildFavoritesSection(favoriteContacts),
              ],
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Align(
            alignment: Alignment.centerLeft, // Aligns the text to the left
            child: Text(
              'All Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ContactEntity>>(
            stream: _contactsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No contacts found'));
              }

              _filteredContacts = _filterContacts(snapshot.data!);

              if (_filteredContacts!.isEmpty) {
                return const Center(
                    child: Text('No contacts match your search'));
              }

              return ListView.separated(
                itemCount: _filteredContacts!.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final contact = _filteredContacts![index];
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
                          builder: (context) =>
                              ContactViewScreen(contact: contact),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search contacts',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(List<ContactEntity> favoriteContacts) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favoriteContacts.length,
        itemBuilder: (context, index) {
          final contact = favoriteContacts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactViewScreen(contact: contact),
                ),
              );
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Text(
                      contact.name.isNotEmpty
                          ? contact.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contact.name,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
