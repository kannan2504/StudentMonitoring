import 'package:loginpage/features/login_screen/Domain/Entity/User.dart';
import 'package:loginpage/features/login_screen/Domain/Repository/AuthRepositry.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<User> call() {
    return repository.signInWithGoogle();
  }
}
