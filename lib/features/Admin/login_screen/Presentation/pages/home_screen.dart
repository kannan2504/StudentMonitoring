// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:loginpage/core/constants/Appcolor.dart';
// import 'package:loginpage/core/constants/ImageConversion.dart';
// import 'package:loginpage/core/widgets/CustomTextField.dart';
// import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
// import 'package:loginpage/features/Admin/login_screen/Presentation/pages/attendance_sheet.dart';
// import 'package:loginpage/features/Admin/login_screen/Presentation/pages/attendance_viewpage.dart';
// import 'package:loginpage/features/Admin/login_screen/Presentation/pages/teacher_list.dart';
// import 'package:loginpage/features/Admin/login_screen/Presentation/provider/themeprovider.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final namecntrl = TextEditingController();
//   final phonecntrl = TextEditingController();
//   final agecntrl = TextEditingController();
//   final datecntrl = TextEditingController();
//   final classcntrl = TextEditingController();
//   final expcntrl = TextEditingController();
//   final emailcntrl = TextEditingController();
//   final yearcntrl = TextEditingController();
//   DateTime? selectedJoinDate;

//   Future<void> pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         selectedJoinDate = pickedDate;
//         datecntrl.text = DateFormat('dd MMM yyyy').format(pickedDate);
//       });
//     }
//   }

//   void dispose() {}
//   File? _profileImage;

//   final ImagePicker _picker = ImagePicker();

//   void _showAdminAlert() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Select Admin Type"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const TeacherList(
//                       selectMode: true, // 👈 important
//                     ),
//                   ),
//                 );
//               },
//               child: const Text("Existing"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Navigate to Add New Admin Page
//               },
//               child: const Text("New"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDialog(bool type) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           actions: [
//             InkWell(onTap: () => Navigator.pop(context), child: Text("cancel")),
//             InkWell(
//               onTap: () {
//                 type
//                     ? GoogleAuthService().addTeacher(
//                         namecntrl.text.trim(),
//                         emailcntrl.text.trim(),
//                         agecntrl.text.trim(),
//                         phonecntrl.text.trim(),
//                         classcntrl.text.trim(),
//                         expcntrl.text.trim(),
//                         selectedJoinDate!,
//                         context,
//                       )
//                     : GoogleAuthService().addStudents(
//                         namecntrl.text.trim(),
//                         emailcntrl.text.trim(),
//                         agecntrl.text.trim(),
//                         phonecntrl.text.trim(),
//                         classcntrl.text.trim(),
//                         yearcntrl.text.trim(),
//                         selectedJoinDate!,
//                         context,
//                       );
//                 Navigator.pop(context);
//               },
//               child: Text("Save"),
//             ),
//           ],
//           content: SizedBox(
//             width: 900,

//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   UserTextField(
//                     label: "Name",
//                     controller: namecntrl,
//                     hint: 'Kannan M',
//                     prefixIcon: Icons.person,
//                   ),
//                   SizedBox(height: 5),
//                   UserTextField(
//                     label: "Email",
//                     controller: emailcntrl,
//                     hint: 'abc@gmail.com',
//                     prefixIcon: Icons.mail,
//                   ),

//                   SizedBox(height: 5),
//                   UserTextField(
//                     label: "Phone number",
//                     controller: phonecntrl,
//                     hint: '123456789',
//                     prefixIcon: Icons.phone,
//                     keyboardType: TextInputType.phone,
//                   ),
//                   SizedBox(height: 5),
//                   UserTextField(
//                     label: "Age",
//                     controller: agecntrl,
//                     hint: '22',
//                     prefixIcon: Icons.timer_outlined,
//                     keyboardType: TextInputType.phone,
//                   ),
//                   SizedBox(height: 5),
//                   SizedBox(
//                     child: UserTextField(
//                       label: type ? "Qualification" : "Dept",
//                       controller: classcntrl,
//                       hint: 'UG',
//                       prefixIcon: Icons.menu_book_sharp,
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                   ),
//                   type
//                       ? UserTextField(
//                           label: "experience",
//                           controller: expcntrl,
//                           hint: '2',
//                           prefixIcon: Icons.av_timer_outlined,
//                           keyboardType: TextInputType.number,
//                         )
//                       : UserTextField(
//                           label: "year",
//                           controller: yearcntrl,
//                           hint: '2',
//                           prefixIcon: Icons.av_timer_outlined,
//                           keyboardType: TextInputType.number,
//                         ),
//                   SizedBox(height: 5),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: TextField(
//                       controller: datecntrl,

//                       readOnly: true, // 🔒 disables typing
//                       onTap: pickDate, // 📅 opens date picker
//                       decoration: InputDecoration(
//                         labelText: "Join Date",
//                         hintText: "dd-mm-yyyy",
//                         prefixIcon: Icon(Icons.date_range),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(vertical: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> pickAndCropImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();

//       final XFile? pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//       );

//       if (pickedFile == null) {
//         // User cancelled image picking
//         return;
//       }

//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         uiSettings: [
//           AndroidUiSettings(toolbarTitle: 'Crop Image', lockAspectRatio: false),
//         ],
//       );

//       if (croppedFile == null) {
//         // User cancelled cropping
//         return;
//       }

//       if (!mounted) return;

//       setState(() {
//         _profileImage = File(croppedFile.path);
//       });
//       final url = await CloudinaryService.uploadImage(File(croppedFile.path));
//       print("CLOUDINARY URL => $url");
//     } catch (e) {
//       debugPrint("Image pick error: $e");
//     }
//   }

//   String? selectedSubjectId;
//   String? selectedSubjectName;
//   String? selectedYear;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('teachers')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(child: Text("No user data found"));
//         }

//         final data = snapshot.data!;

//         final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//         final teacherName = userData['name'] ?? 'Teacher';
//         final teacherDocId = teacherName.trim().toLowerCase().replaceAll(
//           " ",
//           "_",
//         );

//         // Safe read with default value
//         final name = userData.containsKey('name') && userData['name'] != null
//             ? userData['name']
//             : 'User';

//         final phone = userData.containsKey('phone') && userData['phone'] != null
//             ? userData['phone']
//             : 'N/A';

//         final photo =
//             userData.containsKey('photo') &&
//                 userData['photo'] != null &&
//                 userData['photo'].toString().isNotEmpty
//             ? userData['photo']
//             : null;

//         return Consumer<Themeprovider>(
//           builder: (context, theme, child) {
//             final userData =
//                 snapshot.data!.data() as Map<String, dynamic>? ?? {};

//             return Scaffold(
//               drawer: Drawer(
//                 child: ListView(
//                   children: [
//                     DrawerHeader(
//                       child: InkWell(
//                         onTap: pickAndCropImage,
//                         child: CircleAvatar(
//                           backgroundColor: theme.backgroundColor,
//                           radius: 70,
//                           backgroundImage: _profileImage != null
//                               ? FileImage(_profileImage!)
//                               : (userData.containsKey('photo') &&
//                                     photo != null &&
//                                     photo.toString().isNotEmpty)
//                               ? NetworkImage(photo)
//                               : null,
//                         ),
//                       ),
//                     ),
//                     ListTile(title: Text("Username:  ${name ?? 'User'}")),
//                     ListTile(title: Text("Mobile no: ${phone ?? 'N/A'}")),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, '/editpage');
//                           },
//                           child: Text("Edit Profile"),
//                         ),
//                         SizedBox(width: 20),
//                         ElevatedButton(
//                           onPressed: () async {
//                             await FirebaseAuth.instance.signOut();
//                             Navigator.pushReplacementNamed(context, '/login');
//                           },
//                           child: Text("Logout"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               appBar: AppBar(
//                 title: Text("Home"),
//                 actions: [
//                   IconButton(
//                     icon: Icon(Icons.logout),
//                     onPressed: () async {
//                       await FirebaseAuth.instance.signOut();
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                 ],
//               ),
//               body: Center(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showDialog(false),

//                       child: Card(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(child: Icon(Icons.add)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("Add Student"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     GestureDetector(
//                       onTap: () => _showAdminAlert(),

//                       child: Card(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(child: Icon(Icons.add)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("Add Admin"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Card(
//                       child: InkWell(
//                         onTap: () => _showDialog(true),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(child: Icon(Icons.add)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("Add Teacher"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () =>
//                           Navigator.pushNamed(context, '/subjectscreen'),

//                       child: Card(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(child: Icon(Icons.add)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("Add Subjects"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Card(
//                       child: InkWell(
//                         onTap: () =>
//                             Navigator.pushNamed(context, '/studentList'),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(
//                                 child: Icon(Icons.person_outline_outlined),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("View Students"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Card(
//                       child: InkWell(
//                         onTap: () =>
//                             Navigator.pushNamed(context, '/teacherList'),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(child: Icon(Icons.person)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("View Teachers"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     Card(
//                       child: InkWell(
//                         onTap: () => popAttendCard(teacherName),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: CircleAvatar(
//                                 child: Icon(Icons.my_library_books_rounded),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("Mark Attendance "),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Card(
//                       child: InkWell(
//                         onTap: () {
//                           if (selectedSubjectId == null ||
//                               selectedYear == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Select subject & year first"),
//                               ),
//                             );
//                             return;
//                           }

//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => AttendanceViewPage(
//                                 teacherName: teacherName,
//                                 subjectId: selectedSubjectId!,
//                                 year: selectedYear!,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           children: const [
//                             Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: CircleAvatar(
//                                 child: Icon(Icons.table_chart),
//                               ),
//                             ),
//                             Text("View Attendance"),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "Welcome ${name ?? 'User'}\n"
//                       "Mobile: ${phone ?? 'N/A'}",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void popAttendCard(String teacherName) {
//     final teacherDocId = teacherName.trim().toLowerCase().replaceAll(" ", "_");

//     // Step 1: Select Subject
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Select Subject"),
//           content: SizedBox(
//             width: double.maxFinite,
//             height: 300,
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('teachers')
//                   .doc(FirebaseAuth.instance.currentUser!.uid)
//                   .collection('subjects')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No subjects found"));
//                 }

//                 final subjects = snapshot.data!.docs;

//                 return GridView.builder(
//                   itemCount: subjects.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 2,
//                   ),
//                   itemBuilder: (context, index) {
//                     final subject = subjects[index];
//                     final subjectName = subject['name'];
//                     final subjectCode = subject['code'];

//                     return InkWell(
//                       onTap: () {
//                         Navigator.pop(context); // close subjects dialog
//                         selectYearAndOpenAttendance(
//                           teacherName,
//                           subject.id,
//                           subjectName,
//                         );
//                       },
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 subjectName,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 subjectCode,
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Step 2: Select Year and Open Attendance Sheet
//   // void selectYearAndOpenAttendance(
//   //   String teacherName,
//   //   String subjectId,
//   //   String subjectName,
//   // ) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: const Text("Select Year"),
//   //         content: SizedBox(
//   //           width: double.maxFinite,
//   //           height: 200,
//   //           child: GridView.builder(
//   //             itemCount: 4,
//   //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //               crossAxisCount: 2,
//   //               crossAxisSpacing: 10,
//   //               mainAxisSpacing: 10,
//   //               childAspectRatio: 2,
//   //             ),
//   //             itemBuilder: (context, index) {
//   //               final year = index + 1;
//   //               return ListTile(
//   //                 title: Text("Year $year"), // ✅ show year field
//   //                 onTap: () {
//   //                   Navigator.pop(context); // close year dialog
//   //                   Navigator.push(
//   //                     context,
//   //                     MaterialPageRoute(
//   //                       builder: (_) => DailyAttendanceTable(
//   //                         teacherName: teacherName,
//   //                         subjectId: subjectId,
//   //                         subjectName: subjectName,
//   //                         year: year.toString(), // selected year
//   //                       ),
//   //                     ),
//   //                   );
//   //                 },
//   //               );
//   //             },
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//   void selectYearAndOpenAttendance(
//     String teacherName,
//     String subjectId,
//     String subjectName,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Select Year"),
//           content: SizedBox(
//             width: double.maxFinite,
//             height: 200,
//             child: GridView.builder(
//               itemCount: 4, // show years 1 to 4
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 2,
//               ),
//               itemBuilder: (context, index) {
//                 final year = index + 1;

//                 return InkWell(
//                   onTap: () async {
//                     Navigator.pop(context); // close year dialog

//                     // Fetch students for this year
//                     final studentSnapshot = await FirebaseFirestore.instance
//                         .collection('students')
//                         .doc(year.toString()) // year as doc ID
//                         .collection('lists')
//                         .get();

//                     if (studentSnapshot.docs.isEmpty) {
//                       // No students for this year
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text("No Data Found"),
//                           content: Text("No students found for Year $year"),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text("OK"),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       // Students exist → open attendance sheet
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => DailyAttendanceTable(
//                             teacherName: teacherName,
//                             subjectId: subjectId,
//                             subjectName: subjectName,
//                             year: year.toString(),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: Card(
//                     color: Colors.blue.shade100,
//                     child: Center(
//                       child: Text(
//                         "Year $year",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class EditPage extends StatefulWidget {
//   const EditPage({super.key});

//   @override
//   State<EditPage> createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   final nameCntrl = TextEditingController();
//   final phoneCntrl = TextEditingController();
//   File? _profileImage;
//   String? imageUrl;
//   bool isUploading = false;

//   bool _isInitialized = false;

//   Future<void> pickAndCropImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();

//       final XFile? pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//       );

//       if (pickedFile == null) {
//         // User cancelled image picking
//         return;
//       }

//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         uiSettings: [
//           AndroidUiSettings(toolbarTitle: 'Crop Image', lockAspectRatio: false),
//         ],
//       );

//       if (croppedFile == null) {
//         // User cancelled cropping
//         return;
//       }
//       setState(() => isUploading = true);

//       final url = await CloudinaryService.uploadImage(File(croppedFile.path));

//       if (!mounted) return;
//       setState(() {
//         _profileImage = File(croppedFile.path);
//         imageUrl = url;
//         isUploading = false;
//       });
//     } catch (e) {
//       debugPrint("Image pick error: $e");
//     }
//   }

//   Future<void> updateUserDetails(Map<String, dynamic> data) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await GoogleAuthService().createUserIfNotExists(user);
//       }
//       ;

//       // 🔹 Update Firestore
//       await FirebaseFirestore.instance
//           .collection('teachers')
//           .doc(user?.uid)
//           .set({
//             'name': nameCntrl.text.trim(),
//             'phone': phoneCntrl.text.trim(),
//             if (imageUrl != null) 'photo': imageUrl,
//             'updatedAt': FieldValue.serverTimestamp(),
//           }, SetOptions(merge: true));
//       setState(() {
//         _profileImage = null; // ✅ THIS IS THE FIX
//       });
//       // 🔹 Success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile updated successfully")),
//       );
//     } catch (e) {
//       debugPrint("Update error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Update failed")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .snapshots(),

//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(child: Text("No user data found"));
//         }
//         final snapshotData = snapshot.data!;

//         final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

//         final name = data.containsKey('name') && data['name'] != null
//             ? data['name']
//             : 'User';

//         final phone = data.containsKey('phone') && data['phone'] != null
//             ? data['phone']
//             : 'N/A';
//         final photo =
//             (data.containsKey('photo') &&
//                 data['photo'] != null &&
//                 data['photo'].toString().isNotEmpty)
//             ? data['photo']
//             : null;

//         if (!_isInitialized) {
//           nameCntrl.text = name;
//           phoneCntrl.text = phone;
//           _isInitialized = true;
//         }
//         return Consumer<Themeprovider>(
//           builder: (context, theme, child) {
//             return Scaffold(
//               appBar: AppBar(title: Text("Update Profile")),
//               body: Center(
//                 child: Container(
//                   height: 400,
//                   child: Column(
//                     children: [
//                       InkWell(
//                         onTap: pickAndCropImage,
//                         child: CircleAvatar(
//                           backgroundColor: theme.backgroundColor,
//                           radius: 70,
//                           backgroundImage: _profileImage != null
//                               ? FileImage(_profileImage!)
//                               : (data.containsKey('photo') &&
//                                     "$photo" != null &&
//                                     "$photo".toString().isNotEmpty)
//                               ? NetworkImage("$photo")
//                               : null,
//                           child:
//                               (_profileImage == null &&
//                                   (!data.containsKey('photo') ||
//                                       photo == null ||
//                                       photo.toString().isEmpty))
//                               ? Icon(
//                                   Icons.person_2_sharp,
//                                   size: 50,
//                                   color: Appcolor.whiteColor,
//                                 )
//                               : null,
//                         ),
//                       ),

//                       SizedBox(height: 30),
//                       UserTextField(
//                         prefixIcon: Icons.person_2_outlined,
//                         hint: "name",
//                         controller: nameCntrl,
//                       ),
//                       SizedBox(height: 30),
//                       UserTextField(
//                         hint: "number",
//                         prefixIcon: Icons.numbers,
//                         controller: phoneCntrl,
//                         keyboardType: TextInputType.numberWithOptions(),
//                       ),
//                       ElevatedButton.icon(
//                         icon: Icon(Icons.update),
//                         label: Opacity(
//                           opacity: 0.7,
//                           child: isUploading
//                               ? const CircularProgressIndicator()
//                               : Text(
//                                   "Update Detials",
//                                   style: TextStyle(
//                                     color: theme.isDark
//                                         ? Appcolor.whiteColor
//                                         : Appcolor.blackColor,
//                                   ),
//                                 ),
//                         ),
//                         onPressed: isUploading
//                             ? null
//                             : () async {
//                                 await updateUserDetails(data);
//                                 Navigator.pushReplacementNamed(
//                                   context,
//                                   '/home',
//                                 );
//                               },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/core/constants/ImageConversion.dart';
import 'package:loginpage/core/widgets/CustomTextField.dart';
import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/attendance_sheet.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/attendance_viewpage.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/teacher_list.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/provider/themeprovider.dart';
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
  final expcntrl = TextEditingController();
  final emailcntrl = TextEditingController();
  final yearcntrl = TextEditingController();
  DateTime? selectedJoinDate;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String? selectedSubjectId;
  String? selectedSubjectName;
  String? selectedYear;

  @override
  void dispose() {
    namecntrl.dispose();
    phonecntrl.dispose();
    agecntrl.dispose();
    datecntrl.dispose();
    classcntrl.dispose();
    expcntrl.dispose();
    emailcntrl.dispose();
    yearcntrl.dispose();
    super.dispose();
  }

  void clearControllers() {
    namecntrl.clear();
    phonecntrl.clear();
    agecntrl.clear();
    datecntrl.clear();
    classcntrl.clear();
    expcntrl.clear();
    emailcntrl.clear();
    yearcntrl.clear();
    selectedJoinDate = null;
  }

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

  // Function to show view attendance dialog
  void _showViewAttendanceDialog(String teacherName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Subject"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('subjects')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No subjects found"));
                }

                final subjects = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final subjectName = subject['name'];
                    final subjectCode = subject['code'];

                    return ListTile(
                      title: Text(subjectName),
                      subtitle: Text("Code: $subjectCode"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.pop(context);
                        _showViewYearDialog(
                          teacherName,
                          subjectCode,
                          subjectName,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Function to show year selection for viewing attendance
  void _showViewYearDialog(
    String teacherName,
    String subjectCode,
    String subjectName,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                final year = index + 1;

                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to attendance view page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttendanceViewPage(
                          teacherName: teacherName,
                          subjectCode: subjectCode,
                          subjectName: subjectName,
                          year: year.toString(),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Center(
                      child: Text(
                        "Year $year",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAdminAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Admin Type"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TeacherList(selectMode: true),
                  ),
                );
              },
              child: const Text("Existing"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDialog(true);
              },
              child: const Text("New"),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(bool isTeacher) {
    clearControllers();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isTeacher ? "Add Teacher" : "Add Student"),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserTextField(
                        label: "Name",
                        controller: namecntrl,
                        hint: 'Enter name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      UserTextField(
                        label: "Email",
                        controller: emailcntrl,
                        hint: 'abc@gmail.com',
                        prefixIcon: Icons.mail,
                      ),
                      const SizedBox(height: 10),
                      UserTextField(
                        label: "Phone number",
                        controller: phonecntrl,
                        hint: '1234567890',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      UserTextField(
                        label: "Age",
                        controller: agecntrl,
                        hint: '22',
                        prefixIcon: Icons.timer_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      UserTextField(
                        label: isTeacher ? "Qualification" : "Department",
                        controller: classcntrl,
                        hint: isTeacher ? 'UG' : 'Computer Science',
                        prefixIcon: Icons.menu_book_sharp,
                      ),
                      const SizedBox(height: 10),
                      if (isTeacher)
                        UserTextField(
                          label: "Experience (years)",
                          controller: expcntrl,
                          hint: '2',
                          prefixIcon: Icons.av_timer_outlined,
                          keyboardType: TextInputType.number,
                        )
                      else
                        UserTextField(
                          label: "Year",
                          controller: yearcntrl,
                          hint: '2',
                          prefixIcon: Icons.av_timer_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                datecntrl.text.isEmpty
                                    ? "Select Join Date"
                                    : datecntrl.text,
                                style: TextStyle(
                                  color: datecntrl.text.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    clearControllers();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedJoinDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select join date"),
                        ),
                      );
                      return;
                    }

                    if (isTeacher) {
                      await GoogleAuthService().addTeacher(
                        namecntrl.text.trim(),
                        emailcntrl.text.trim(),
                        agecntrl.text.trim(),
                        phonecntrl.text.trim(),
                        classcntrl.text.trim(),
                        expcntrl.text.trim(),
                        selectedJoinDate!,
                        context,
                      );
                    } else {
                      await GoogleAuthService().addStudents(
                        namecntrl.text.trim(),
                        emailcntrl.text.trim(),
                        agecntrl.text.trim(),
                        phonecntrl.text.trim(),
                        classcntrl.text.trim(),
                        yearcntrl.text.trim(),
                        selectedJoinDate!,
                        context,
                      );
                    }

                    Navigator.pop(context);
                    clearControllers();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> pickAndCropImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile == null) return;

      if (!mounted) return;

      setState(() {
        _profileImage = File(croppedFile.path);
      });

      final url = await CloudinaryService.uploadImage(File(croppedFile.path));

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(user.uid)
            .update({'photo': url});
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  // Function for marking attendance
  void popAttendCard(String teacherName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Subject"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('subjects')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No subjects found"));
                }

                final subjects = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final subjectName = subject['name'];
                    final subjectCode = subject['code'];

                    return ListTile(
                      title: Text(subjectName),
                      subtitle: Text("Code: $subjectCode"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.pop(context);
                        selectYearAndOpenAttendance(
                          teacherName,
                          subject.id,
                          subjectName,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void selectYearAndOpenAttendance(
    String teacherName,
    String subjectId,
    String subjectName,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                final year = index + 1;

                return InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    final studentSnapshot = await FirebaseFirestore.instance
                        .collection('students')
                        .doc(year.toString())
                        .collection('lists')
                        .get();

                    if (studentSnapshot.docs.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("No Data Found"),
                          content: Text("No students found for Year $year"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DailyAttendanceTable(
                            teacherName: teacherName,
                            subjectId: subjectId,
                            subjectName: subjectName,
                            year: year.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Center(
                      child: Text(
                        "Year $year",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teachers')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: const Text("Home")),
            body: const Center(child: Text("No user data found")),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final name = userData['name'] ?? 'User';
        final phone = userData['phone'] ?? 'N/A';
        final photo = userData['photo'];

        return Consumer<Themeprovider>(
          builder: (context, theme, child) {
            return Scaffold(
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: pickAndCropImage,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : (photo != null &&
                                        photo.toString().isNotEmpty)
                                  ? NetworkImage(photo)
                                  : null,
                              child:
                                  _profileImage == null &&
                                      (photo == null ||
                                          photo.toString().isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("Name: $name"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text("Mobile: $phone"),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/editpage');
                            },
                            child: const Text("Edit Profile"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                title: const Text("Home"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    // Add Student Card
                    _buildFeatureCard(
                      icon: Icons.person_add,
                      label: "Add Student",
                      onTap: () => _showDialog(false),
                    ),

                    // Add Admin Card
                    _buildFeatureCard(
                      icon: Icons.admin_panel_settings,
                      label: "Add Admin",
                      onTap: _showAdminAlert,
                    ),

                    // Add Teacher Card
                    _buildFeatureCard(
                      icon: Icons.person_add_alt_1,
                      label: "Add Teacher",
                      onTap: () => _showDialog(true),
                    ),

                    // Add Subjects Card
                    _buildFeatureCard(
                      icon: Icons.subject,
                      label: "Add Subjects",
                      onTap: () =>
                          Navigator.pushNamed(context, '/subjectscreen'),
                    ),

                    // View Students Card
                    _buildFeatureCard(
                      icon: Icons.people,
                      label: "View Students",
                      onTap: () => Navigator.pushNamed(context, '/studentList'),
                    ),

                    // View Teachers Card
                    _buildFeatureCard(
                      icon: Icons.school,
                      label: "View Teachers",
                      onTap: () => Navigator.pushNamed(context, '/teacherList'),
                    ),

                    // Mark Attendance Card
                    _buildFeatureCard(
                      icon: Icons.assignment,
                      label: "Mark Attendance",
                      onTap: () => popAttendCard(name),
                    ),

                    // View Attendance Card
                    _buildFeatureCard(
                      icon: Icons.table_chart,
                      label: "View Attendance",
                      onTap: () => _showViewAttendanceDialog(name),
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

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, size: 30, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
