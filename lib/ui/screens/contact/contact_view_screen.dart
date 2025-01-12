import 'package:contact_manager/domain/services/contact_service.dart';// Import the dialog
import 'package:contact_manager/ui/screens/contact/update_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:contact_manager/domain/entities/contact_entity.dart';

import '../../widgets/custom_dialogs.dart';

class ContactViewScreen extends StatefulWidget {
  final ContactEntity contact;

  const ContactViewScreen({super.key, required this.contact});

  @override
  State<ContactViewScreen> createState() => _ContactViewScreenState();
}

class _ContactViewScreenState extends State<ContactViewScreen> {
  final ContactService _contactService = ContactService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Update Contact',
            onPressed: () {
              _navigateToUpdateScreen(context);
            },
          ),
          IconButton(
            icon: Icon(
              widget.contact.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.contact.isFavorite
                  ? Theme.of(context).primaryColor
                  : null,
            ),
            tooltip: 'Toggle Favorite',
            onPressed: () {
              _toggleFavoriteStatus();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Contact',
            onPressed: () {
              _confirmDeleteContact(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  widget.contact.name.isNotEmpty
                      ? widget.contact.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              icon: Icons.person,
              label: "Name",
              value: widget.contact.name,
            ),
            _buildDetailCard(
              icon: Icons.phone,
              label: "Phone Number",
              value: widget.contact.phoneNumber,
            ),
            _buildDetailCard(
              icon: Icons.email,
              label: "Email",
              value: widget.contact.email,
            ),
            _buildDetailCard(
              icon: Icons.calendar_today,
              label: "Added On",
              value: _formatTimestamp(widget.contact.timestamp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  void _navigateToUpdateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateContactScreen(contact: widget.contact),
      ),
    ).then((updatedContact) {
      if (updatedContact != null && updatedContact is ContactEntity) {
        setState(() {
          widget.contact.name = updatedContact.name;
          widget.contact.phoneNumber = updatedContact.phoneNumber;
          widget.contact.email = updatedContact.email;
        });
      }
    });
  }


  void _toggleFavoriteStatus() async {
    setState(() {
      widget.contact.isFavorite = !widget.contact.isFavorite;
    });

    try {
      await _contactService.updateContact(widget.contact.id, widget.contact);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.contact.isFavorite
                ? 'Added to favorites'
                : 'Removed from favorites',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating favorite status')),
      );
      setState(() {
        widget.contact.isFavorite = !widget.contact.isFavorite; // Revert state
      });
    }
  }

  void _confirmDeleteContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDeleteDialog(
          title: "Delete Contact",
          content: "Are you sure you want to delete this contact?",
          onConfirm: _deleteContact,
        );
      },
    );
  }

  void _deleteContact() async {
    try {
      await _contactService.deleteContact(widget.contact.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact deleted successfully')),
      );
      Navigator.of(context).pop(); // Navigate back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting contact')),
      );
    }
  }



  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }
}
