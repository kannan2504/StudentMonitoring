import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> addStudents(
    String name,
    String age,
    String phone,
    String standard,
    DateTime date,
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) return;
      await FirebaseFirestore.instance.collection('students').add({
        'name': name,
        'phone': phone,
        'age': int.tryParse(age) ?? 0,
        'class': standard,
        'joinDate': Timestamp.fromDate(date),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': user.uid,
      });

      print(
        "Firebase Created44444444444444444444444444444444444455555555555555566666666666666666666666111111111111122222 ",
      );

      Navigator.pop(context); // close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student added successfully")),
      );
    } catch (e) {
      debugPrint("Student save error: $e");
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter email")));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent to email")),
      );

      Navigator.pop(context); // back to login
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
    }
  }

  Future<User?> signInWithGoogle() async {
    // 1️⃣ Select Google Account
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return null;

    // 2️⃣ Get Auth Details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // 3️⃣ Firebase Credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // 4️⃣ Firebase Sign-In
    final UserCredential userCred = await _auth.signInWithCredential(
      credential,
    );

    final User user = userCred.user!;

    // 5️⃣ Auto Register in Firestore
    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        "uid": user.uid,
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "photo": user.photoURL ?? "",
        "provider": "google",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  Future<void> createUserIfNotExists(User user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? '',
        'phone': '',
        'photo': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    String uid = user.uid;
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      // Create document if it doesn't exist
      await docRef.set({
        'name': user.displayName ?? 'User',
        'email': user.email ?? '',
        'mobile': '',
        'photo': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {
        'name': user.displayName ?? 'User',
        'email': user.email ?? '',
        'mobile': '',
        'photo': user.photoURL ?? '',
      };
    }
    return doc.data()!;
  }
}


// Cloud name
// dvus6u6im

// Folder mode
// Dynamic folders


