import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> makeAdmin(
    BuildContext context,
    Map<String, dynamic> teacher,
  ) async {
    final teacherId = teacher['id'];

    try {
      // 1️⃣ Update TEACHER role
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .update({"role": "admin"});

      // 2️⃣ Save / Update USER collection
      await FirebaseFirestore.instance.collection('users').doc(teacherId).set({
        "name": teacher['name'],
        "email": teacher['email'],
        "role": "admin",
        "from": "teacher",
      }, SetOptions(merge: true));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin created successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> saveNewAdmin(Map<String, dynamic> data) async {
    final doc = FirebaseFirestore.instance.collection('users').doc();

    // users
    await doc.set({...data, "role": "admin"});

    // teachers
    await FirebaseFirestore.instance.collection('teachers').doc(doc.id).set({
      ...data,
      "role": "admin",
    });
  }

  Future<void> addTeacher(
    String name,
    String email,
    String age,
    String phone,
    String Qualification,
    String experience,
    DateTime Joineddate,
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) return;
      await FirebaseFirestore.instance.collection('teachers').add({
        'name': name,
        'email': email,
        'phone': phone,
        'age': int.tryParse(age) ?? 0,
        'class': Qualification,
        'experience': experience,
        'joinDate': Timestamp.fromDate(Joineddate),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': user.uid,
      });

      Navigator.pop(context); // close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teacher added successfully")),
      );
    } catch (e) {
      debugPrint("Teacher save error: $e");
    }
  }

  Future<void> deleteTeacher(String docid) async {
    await _firestore.collection('teachers').doc(docid).delete();
  }

  Future<void> deletesubject(String scode) async {
    await _firestore.collection('subjects').doc(scode).delete();
  }

  Future<void> addSubject(
    String sname,
    String scode,
    BuildContext context,
  ) async {
    final sub = FirebaseAuth.instance.currentUser;

    try {
      if (sub == null) return;
      await FirebaseFirestore.instance.collection('subjects').doc(scode).set({
        'name': sname,
        'code': scode,
      });

      //Navigator.pop(context); // close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("subject  added successfully")),
      );
    } catch (e) {
      debugPrint("subject save error: $e");
    }
  }

  Future<void> addStudents(
    String name,
    String email,
    String age,
    String phone,
    String classc,
    String year,
    DateTime date,

    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) return;
      await FirebaseFirestore.instance.collection('students').add({
        'name': name,
        'email': email,
        'phone': phone,
        'age': int.tryParse(age) ?? 0,
        'class': classc,
        'year': year,
        'type': 'student',

        'joinDate': Timestamp.fromDate(date),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': user.uid,
      });

      // close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student added successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Student save error: $e");
    }
  }

  Future<void> deleteStudent(String docid) async {
    await _firestore.collection('students').doc(docid).delete();
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


