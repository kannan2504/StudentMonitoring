import 'package:loginpage/features/login_screen/Domain/Entity/User.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  factory UserModel.fromGoogle({
    required String email,
    required String name,
    required String token,
  }) {
    return UserModel(
      id: 'google_${email.hashCode}',
      name: name,
      email: email,
      token: token,
    );
  }
}
