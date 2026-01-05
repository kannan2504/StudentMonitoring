import 'package:loginpage/features/login_screen/Domain/Entity/User.dart';

abstract class AuthRepository {
  Future<User> signInWithGoogle();
  Future<User> login(String email, String password);
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String mobile,
  });
}
