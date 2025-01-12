class ContactEntity {
  String id; // Unique document ID
  String userid, name, phoneNumber, email;
  DateTime timestamp;
  bool isFavorite;

  ContactEntity({
    required this.id, // Initialize the document ID
    required this.userid,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.timestamp,
    this.isFavorite = false,
  });

  // Factory constructor to create an instance from a map
  factory ContactEntity.fromMap(Map<String, dynamic> map, {required String id}) {
    return ContactEntity(
      id: id,
      userid: map['userid'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      timestamp: DateTime.parse(map['timestamp']),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  // Method to convert an instance to a map (excluding the ID)
  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
