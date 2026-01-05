class UserModel {
  final String uid;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    this.createdAt,
  });

  // 🔥 Firestore → Dart
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      mobile: map['mobile'],
      gender: map['gender'],
      createdAt: map['createdAt']?.toDate(),
    );
  }

  // 🔥 Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'createdAt': createdAt,
    };
  }
}
