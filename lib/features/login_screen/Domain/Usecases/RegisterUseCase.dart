import 'package:loginpage/features/login_screen/Domain/Entity/User.dart';
import 'package:loginpage/features/login_screen/Domain/Repository/AuthRepositry.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String mobile,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
      gender: gender,
      mobile: mobile,
    );
  }
}
