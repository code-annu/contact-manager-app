class ContactEntity {
  String userid, name, phoneNumber, email;

  ContactEntity({
    required this.userid,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  factory ContactEntity.fromMap(Map<String, dynamic> map) {
    return ContactEntity(
      userid: map['userid'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}
