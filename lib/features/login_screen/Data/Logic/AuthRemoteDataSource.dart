import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginpage/features/login_screen/Data/Entity/UserModal.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(Map<String, dynamic> data);
  Future<UserModel> signInWithGoogle();
}

class AuthRemoteDataSourceimpl implements AuthRemoteDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  @override
  Future<UserModel> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();

    if (account == null) {
      throw Exception("User cancelled login");
    }

    final auth = await account.authentication;
    final String token = auth.idToken ?? '';

    return UserModel.fromGoogle(
      email: account.email,
      name: account.displayName ?? "",
      token: token,
    );
  }

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      id: 'user_${email.hashCode}',
      name: 'Demo User',
      email: email,
      token: 'login_token_from_server',
    );
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      id: 'user_${data['email'].hashCode}',
      name: data['name'],
      email: data['email'],
      token: 'register_token_from_server',
    );
  }
}
