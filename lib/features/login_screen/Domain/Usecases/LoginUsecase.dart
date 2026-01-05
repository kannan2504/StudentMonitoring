import 'package:loginpage/features/login_screen/Domain/Entity/User.dart';
import 'package:loginpage/features/login_screen/Domain/Repository/AuthRepositry.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
