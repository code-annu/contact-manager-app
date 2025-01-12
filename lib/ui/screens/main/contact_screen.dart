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
  String _sortOption = 'Name'; // Default sort option

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
    List<ContactEntity> filtered = contacts;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((contact) =>
              contact.name.toLowerCase().contains(_searchQuery) ||
              contact.phoneNumber.contains(_searchQuery))
          .toList();
    }

    if (_sortOption == 'Name') {
      filtered
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_sortOption == 'Date Added') {
      filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: _sortOption,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _sortOption = newValue;
                    });
                  }
                },
                items: ['Name', 'Date Added']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  );
                }).toList(),
              ),
            ],
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
}
