import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/features/Admin/login_screen/Data/Entity/UserModal.dart';
import 'package:loginpage/features/Admin/login_screen/Domain/Entity/User.dart';
import 'package:loginpage/features/Admin/login_screen/Domain/Usecases/GoogleSIgninUsecase.dart';

class LoginProvider extends ChangeNotifier {
  final GoogleSignInUseCase googleSignInUseCase;
  bool isDark = false;
  bool isLoading = false;
  UserModel? user;
  String? error;

  Future<bool> registerUserFire({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required String role,
    required String qualify,
    required String experience,
  }) async {
    try {
      String collectionName = role.toLowerCase() == 'teacher'
          ? 'teachers'
          : 'students';

      isLoading = true;
      notifyListeners();

      // 1️⃣ Firebase Auth
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2️⃣ Firestore save
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(cred.user!.uid)
          .set({
            'uid': cred.user!.uid,
            'name': name,
            'email': email,
            'mobile': mobile,
            'role': role,
            'class':qualify,
            'experience':experience,
            

            'createdAt': FieldValue.serverTimestamp(),
          });

      // 3️⃣ Email verification
      await cred.user!.sendEmailVerification();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("REGISTER ERROR: $e");
      return false;
    }
  }

  LoginProvider(this.googleSignInUseCase);

  // Future<bool> registerUser({
  //   required String name,
  //   required String email,
  //   required String password,
  //   required String gender,
  //   required String mobile,
  // }) async {
  //   isLoading = true;
  //   notifyListeners();

  //   await Future.delayed(const Duration(seconds: 2)); // API call simulation

  //   isLoading = false;
  //   notifyListeners();

  //   return true;
  // }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userk = (await googleSignInUseCase());
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
