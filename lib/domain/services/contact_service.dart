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
}
