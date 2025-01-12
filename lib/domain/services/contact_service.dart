import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_manager/domain/entities/contact_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNewContact(ContactEntity contactEntity) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    contactEntity.userid = user.uid;
    await _firestore.collection('contacts').add(contactEntity.toMap());
  }

  // Function to fetch all contacts for the logged-in user
  Future<List<ContactEntity>> fetchUserContacts() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final querySnapshot = await _firestore
        .collection('contacts')
        .where('userid', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs
        .map((doc) => ContactEntity.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  // Function to update a contact
  Future<void> updateContact(
      String documentId, ContactEntity updatedContact) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Ensure the contact belongs to the current user
    if (updatedContact.userid != user.uid) {
      throw Exception(
          'Cannot update a contact that does not belong to the logged-in user');
    }

    // Update the contact in Firestore
    await _firestore
        .collection('contacts')
        .doc(documentId)
        .update(updatedContact.toMap());
  }

  // Function to delete a contact
  Future<void> deleteContact(String documentId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Fetch the contact document to ensure it belongs to the logged-in user
    final documentSnapshot =
        await _firestore.collection('contacts').doc(documentId).get();

    if (!documentSnapshot.exists) {
      throw Exception('Contact does not exist');
    }

    final contactData = documentSnapshot.data() as Map<String, dynamic>;
    if (contactData['userid'] != user.uid) {
      throw Exception(
          'Cannot delete a contact that does not belong to the logged-in user');
    }

    // Delete the contact document
    await _firestore.collection('contacts').doc(documentId).delete();
  }

  Stream<List<ContactEntity>> listenToContacts() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return _firestore
        .collection('contacts')
        .where('userid', isEqualTo: user.uid) // Filter by user ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ContactEntity.fromMap(doc.data(), id: doc.id);
      }).toList();
    });
  }
}
