import 'package:loginpage/features/login_screen/Data/Logic/AuthRemoteDataSource.dart';
import 'package:loginpage/features/login_screen/Domain/Entity/User.dart';
import 'package:loginpage/features/login_screen/Domain/Repository/AuthRepositry.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> signInWithGoogle() async {
    final model = await remote.signInWithGoogle();
    return model;
  }

  @override
  Future<User> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String mobile,
  }) {
    return remote.register({
      "name": name,
      "email": email,
      "password": password,
      "gender": gender,
      "mobile": mobile,
    });
  }
}
