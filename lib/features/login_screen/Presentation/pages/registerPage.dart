import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/features/login_screen/Presentation/provider/loginProvider.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/loginPage.dart';
import 'package:loginpage/core/widgets/CustomTextField.dart';
import 'package:loginpage/features/login_screen/Presentation/provider/themeprovider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();

  bool obscurePassword = true;
  String gender = "Male";

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<Themeprovider>().backgroundColor;
    return Scaffold(
      //appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Container(
            height: 600,
            child: Consumer<LoginProvider>(
              builder: (context, auth, _) {
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70),
                    Text(
                      "Register Now",
                      style: TextStyle(
                        fontSize: 35,
                        color: theme,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            UserTextField(
                              controller: nameCtrl,
                              hint: "Name",
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 12),

                            UserTextField(
                              controller: emailCtrl,
                              hint: "Email",
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),

                            UserTextField(
                              controller: passCtrl,
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
                            const SizedBox(height: 12),

                            // _genderDropdown(context),
                            const SizedBox(height: 12),

                            UserTextField(
                              controller: mobileCtrl,
                              hint: "Mobile Number",
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 24),

                            auth.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme,
                                    ),
                                    onPressed: () async {
                                      final success = await auth
                                          .registerUserFire(
                                            name: nameCtrl.text,
                                            email: emailCtrl.text,
                                            password: passCtrl.text,

                                            mobile: mobileCtrl.text,
                                          );

                                      if (success && context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LoginPage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Appcolor.whiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Already have an account?",
                                      style: TextStyle(
                                        color: auth.isDark
                                            ? Appcolor.whiteColor
                                            : Appcolor.blackColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Login Now",
                                      style: TextStyle(color: theme),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Widget _genderDropdown(BuildContext context) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;

  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: DropdownButtonFormField<String>(
  //       value: gender,
  //       dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
  //       decoration: const InputDecoration(border: InputBorder.none),
  //       items: const [
  //         DropdownMenuItem(value: "Male", child: Text("Male")),
  //         DropdownMenuItem(value: "Female", child: Text("Female")),
  //         DropdownMenuItem(value: "Other", child: Text("Other")),
  //       ],
  //       onChanged: (val) => setState(() => gender = val!),
  //     ),
  //   );
  // }
}
