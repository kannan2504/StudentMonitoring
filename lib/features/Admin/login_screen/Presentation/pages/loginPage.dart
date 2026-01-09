import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/home_screen.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/provider/loginProvider.dart';
import 'package:loginpage/core/widgets/CustomTextField.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/provider/themeprovider.dart';
import 'package:loginpage/features/Students/Screens/DashBoard.dart';
import 'package:loginpage/features/Students/StudentBottomNav.dart';
import 'package:loginpage/main.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  Future<void> navToHomePage(String emailid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String uid = user.uid;

    final studentDoc = await FirebaseFirestore.instance
        .collection("students")
        .where("email", isEqualTo: emailid)
        .get();

    if (studentDoc.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashBoard()),
      );
      return;
    }
    final teacherDoc = await FirebaseFirestore.instance
        .collection("teachers")
        .where("email", isEqualTo: emailid)
        .get();

    if (teacherDoc.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfilePage()),
      );
      return;
    }
    final usersDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: emailid)
        .get();

    if (usersDoc.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
      return;
    }

    // ❌ Not found in any collection
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("User role not found")));

    await FirebaseAuth.instance.signOut();
  }

  Future<void> loginUSer() async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      if (!cred.user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please verify your email and login again"),
          ),
        );
        await FirebaseAuth.instance.signOut();
        return;
      }
      print("Email verified: ${cred.user!.emailVerified}");

      await navToHomePage(cred.user!.email!);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Themeprovider>(
      builder: (context, theme, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome ",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: theme.backgroundColor,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    "Login Now",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),

                SizedBox(height: 30),

                /// 📧 Email Field
                UserTextField(
                  label: "Email",
                  controller: emailController,
                  hint: "abc@gmail.com",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 20),

                /// 🔐 Password Field
                UserTextField(
                  label: "Password",
                  controller: passwordController,
                  hint: "Password",
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  obscureText: obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.reset);
                      },
                      child: Text(
                        "Forget password?",
                        style: TextStyle(
                          color: theme.isDark
                              ? Appcolor.whiteColor
                              : Appcolor.lightblack,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                /// 🔘 Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.backgroundColor,
                    ),
                    onPressed: () async {
                      if (emailController.text.isEmpty &&
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email and password are required"),
                          ),
                        );
                        return;
                      }
                      loginUSer();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Appcolor.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                Text("or"),
                ElevatedButton.icon(
                  icon: Icon(Icons.g_mobiledata),
                  label: Opacity(
                    opacity: 0.7,
                    child: Text(
                      "Continue with Google",
                      style: TextStyle(
                        color: theme.isDark
                            ? Appcolor.whiteColor
                            : Appcolor.blackColor,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final user = await GoogleAuthService().signInWithGoogle();

                    if (user != null && context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/admindashboard',
                      );
                    }
                  },
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't have an account?",
                          style: TextStyle(
                            color: theme.isDark
                                ? Appcolor.whiteColor
                                : Appcolor.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: "Register Now",
                          style: TextStyle(color: theme.backgroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ResetScreen extends StatelessWidget {
  ResetScreen({super.key});
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<Themeprovider>(
      builder: (context, theme, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password ",
                  style: TextStyle(
                    fontSize: 35,
                    color: theme.backgroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 50),
                UserTextField(
                  controller: emailController,
                  hint: "Enter Email",
                  prefixIcon: Icons.mail,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.backgroundColor,
                    ),
                    onPressed: () async {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter Email address")),
                        );
                        return;
                      }

                      await GoogleAuthService().resetPassword(
                        emailController.text.trim(),
                        context,
                      );
                    },
                    child: Text(
                      "Sent Verification Link",
                      style: TextStyle(
                        color: Appcolor.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
