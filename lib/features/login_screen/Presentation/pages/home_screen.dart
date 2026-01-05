import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/core/constants/ImageConversion.dart';
import 'package:loginpage/core/widgets/CustomTextField.dart';
import 'package:loginpage/features/login_screen/Data/Service/google_auth_service.dart';
import 'package:loginpage/features/login_screen/Presentation/provider/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final namecntrl = TextEditingController();
  final phonecntrl = TextEditingController();
  final agecntrl = TextEditingController();
  final datecntrl = TextEditingController();
  final classcntrl = TextEditingController();
  DateTime? selectedJoinDate;

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedJoinDate = pickedDate;
        datecntrl.text = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndCropImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        // User cancelled image picking
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Crop Image', lockAspectRatio: false),
        ],
      );

      if (croppedFile == null) {
        // User cancelled cropping
        return;
      }

      if (!mounted) return;

      setState(() {
        _profileImage = File(croppedFile.path);
      });
      final url = await CloudinaryService.uploadImage(File(croppedFile.path));
      print("CLOUDINARY URL => $url");
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No user data found"));
        }

        final data = snapshot.data!;

        final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        // Safe read with default value
        final name = userData.containsKey('name') && userData['name'] != null
            ? userData['name']
            : 'User';

        final phone = userData.containsKey('phone') && userData['phone'] != null
            ? userData['phone']
            : 'N/A';

        final photo =
            userData.containsKey('photo') &&
                userData['photo'] != null &&
                userData['photo'].toString().isNotEmpty
            ? userData['photo']
            : null;

        return Consumer<Themeprovider>(
          builder: (context, theme, child) {
            final userData =
                snapshot.data!.data() as Map<String, dynamic>? ?? {};

            return Scaffold(
              drawer: Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: InkWell(
                        onTap: pickAndCropImage,
                        child: CircleAvatar(
                          backgroundColor: theme.backgroundColor,
                          radius: 70,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (userData.containsKey('photo') &&
                                    photo != null &&
                                    photo.toString().isNotEmpty)
                              ? NetworkImage(photo)
                              : null,
                        ),
                      ),
                    ),
                    ListTile(title: Text("Username:  ${name ?? 'User'}")),
                    ListTile(title: Text("Mobile no: ${phone ?? 'N/A'}")),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editpage');
                          },
                          child: Text("Edit Profile"),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              appBar: AppBar(
                title: Text("Home"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Text("cancel"),
                                ),
                                InkWell(
                                  onTap: () {
                                    GoogleAuthService().addStudents(
                                      namecntrl.text.trim(),
                                      agecntrl.text.trim(),
                                      phonecntrl.text.trim(),
                                      classcntrl.text.trim(),
                                      selectedJoinDate!,
                                      context,
                                    );
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    UserTextField(
                                      label: "Name",
                                      controller: namecntrl,
                                      hint: 'Kannan M',
                                      prefixIcon: Icons.person,
                                    ),
                                    SizedBox(height: 5),
                                    UserTextField(
                                      label: "Phone number",
                                      controller: phonecntrl,
                                      hint: '123456789',
                                      prefixIcon: Icons.phone,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    SizedBox(height: 5),
                                    UserTextField(
                                      label: "Age",
                                      controller: agecntrl,
                                      hint: '22',
                                      prefixIcon: Icons.timer_outlined,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    SizedBox(height: 5),
                                    UserTextField(
                                      label: "class",
                                      controller: classcntrl,
                                      hint: 'UG',
                                      prefixIcon: Icons.menu_book_sharp,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey.shade900
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: datecntrl,

                                        readOnly: true, // 🔒 disables typing
                                        onTap: pickDate, // 📅 opens date picker
                                        decoration: InputDecoration(
                                          labelText: "Join Date",
                                          hintText: "dd-mm-yyyy",
                                          prefixIcon: Icon(Icons.date_range),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16,
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
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(child: Icon(Icons.add)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add Student"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, '/studentList'),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: Icon(Icons.person_outline_outlined),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("View Students"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Welcome ${name ?? 'User'}\n"
                      "Mobile: ${phone ?? 'N/A'}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final nameCntrl = TextEditingController();
  final phoneCntrl = TextEditingController();
  File? _profileImage;
  String? imageUrl;
  bool isUploading = false;

  bool _isInitialized = false;

  Future<void> pickAndCropImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        // User cancelled image picking
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Crop Image', lockAspectRatio: false),
        ],
      );

      if (croppedFile == null) {
        // User cancelled cropping
        return;
      }
      setState(() => isUploading = true);

      final url = await CloudinaryService.uploadImage(File(croppedFile.path));

      if (!mounted) return;
      setState(() {
        _profileImage = File(croppedFile.path);
        imageUrl = url;
        isUploading = false;
      });
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Future<void> updateUserDetails(Map<String, dynamic> data) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await GoogleAuthService().createUserIfNotExists(user);
      }
      ;

      // 🔹 Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': nameCntrl.text.trim(),
        'phone': phoneCntrl.text.trim(),
        if (imageUrl != null) 'photo': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      setState(() {
        _profileImage = null; // ✅ THIS IS THE FIX
      });
      // 🔹 Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      debugPrint("Update error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Update failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No user data found"));
        }
        final snapshotData = snapshot.data!;

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        final name = data.containsKey('name') && data['name'] != null
            ? data['name']
            : 'User';

        final phone = data.containsKey('phone') && data['phone'] != null
            ? data['phone']
            : 'N/A';
        final photo =
            (data.containsKey('photo') &&
                data['photo'] != null &&
                data['photo'].toString().isNotEmpty)
            ? data['photo']
            : null;

        if (!_isInitialized) {
          nameCntrl.text = name;
          phoneCntrl.text = phone;
          _isInitialized = true;
        }
        return Consumer<Themeprovider>(
          builder: (context, theme, child) {
            return Scaffold(
              appBar: AppBar(title: Text("Update Profile")),
              body: Center(
                child: Container(
                  height: 400,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: pickAndCropImage,
                        child: CircleAvatar(
                          backgroundColor: theme.backgroundColor,
                          radius: 70,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (data.containsKey('photo') &&
                                    "$photo" != null &&
                                    "$photo".toString().isNotEmpty)
                              ? NetworkImage("$photo")
                              : null,
                          child:
                              (_profileImage == null &&
                                  (!data.containsKey('photo') ||
                                      photo == null ||
                                      photo.toString().isEmpty))
                              ? Icon(
                                  Icons.person_2_sharp,
                                  size: 50,
                                  color: Appcolor.whiteColor,
                                )
                              : null,
                        ),
                      ),

                      SizedBox(height: 30),
                      UserTextField(
                        prefixIcon: Icons.person_2_outlined,
                        hint: "name",
                        controller: nameCntrl,
                      ),
                      SizedBox(height: 30),
                      UserTextField(
                        hint: "number",
                        prefixIcon: Icons.numbers,
                        controller: phoneCntrl,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.update),
                        label: Opacity(
                          opacity: 0.7,
                          child: isUploading
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Update Detials",
                                  style: TextStyle(
                                    color: theme.isDark
                                        ? Appcolor.whiteColor
                                        : Appcolor.blackColor,
                                  ),
                                ),
                        ),
                        onPressed: isUploading
                            ? null
                            : () async {
                                await updateUserDetails(data);
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
