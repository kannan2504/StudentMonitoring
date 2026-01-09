// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:loginpage/core/widgets/CustomTextField.dart';

// class StudentListEditpage extends StatefulWidget {
//   final String docId;
//   StudentListEditpage({super.key, required this.docId});

//   @override
//   State<StudentListEditpage> createState() => _StudentListEditpageState();
// }

// class _StudentListEditpageState extends State<StudentListEditpage> {
//   final namecntrl = TextEditingController();

//   final agecntrl = TextEditingController();

//   final phonecntrl = TextEditingController();
//   final yearcntrl = TextEditingController();

//   final classcntrl = TextEditingController();

//   final pricecntrl = TextEditingController();
//   final emailcntrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadUserdata();
//   }

//   void loadUserdata() async {
//     DocumentSnapshot doc = await FirebaseFirestore.instance
//         .collection('students')
//         .doc(widget.docId)
//         .get();

//     if (doc.exists) {
//       namecntrl.text = doc['name'];
//       emailcntrl.text = doc['email'];
//       agecntrl.text = doc['age'].toString();
//       yearcntrl.text = doc['year'].toString();
//       phonecntrl.text = doc['phone'];
//       classcntrl.text = doc['class'] ?? '';
//       pricecntrl.text = doc['price'].toString();
//     }
//   }

//   void _updateUser() async {
//     await FirebaseFirestore.instance
//         .collection('students')
//         .doc(widget.docId)
//         .update({
//           'email': emailcntrl.text,
//           'name': namecntrl.text,
//           'age': int.parse(agecntrl.text),
//           'phone': phonecntrl.text,
//           'class': classcntrl.text,
//           'fees': int.parse(pricecntrl.text),
//           'year': int.parse(yearcntrl.text),
//           // new field added
//         });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('student updated successfully')));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           UserTextField(
//             label: "Name",
//             controller: namecntrl,
//             hint: 'kannan',
//             prefixIcon: Icons.person,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           UserTextField(
//             label: "Email",
//             controller: phonecntrl,
//             hint: 'abc@gmail.com',
//             prefixIcon: Icons.mail,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           UserTextField(
//             label: "Phone number",
//             controller: phonecntrl,
//             hint: '123456789',
//             prefixIcon: Icons.phone,
//             keyboardType: TextInputType.phone,
//           ),
//           SizedBox(height: 5),
//           UserTextField(
//             label: "Age",
//             controller: agecntrl,
//             hint: '22',
//             prefixIcon: Icons.timer_outlined,
//             keyboardType: TextInputType.phone,
//           ),
//           SizedBox(height: 5),
//           UserTextField(
//             label: "Dept",
//             controller: classcntrl,
//             hint: 'UG',
//             prefixIcon: Icons.menu_book_sharp,
//             keyboardType: TextInputType.phone,
//           ),
//           UserTextField(
//             label: "year",
//             controller: yearcntrl,
//             hint: '2',
//             prefixIcon: Icons.date_range,
//             keyboardType: TextInputType.phone,
//           ),
//           UserTextField(
//             label: "Fees",
//             controller: pricecntrl,
//             hint: '1000',
//             prefixIcon: Icons.attach_money,
//             keyboardType: TextInputType.phone,
//           ),

//           SizedBox(height: 5),
//           ElevatedButton(onPressed: _updateUser, child: Text("update Detials")),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/CustomTextField.dart';

enum UserType { student, teacher }

class EditUserPage extends StatefulWidget {
  final String docId;
  final UserType userType;

  const EditUserPage({super.key, required this.docId, required this.userType});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  // COMMON
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  // STUDENT
  final classCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final feesCtrl = TextEditingController();

  // TEACHER
  final qualificationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();

  int parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final collection = widget.userType == UserType.student
        ? 'students'
        : 'teachers';

    final doc = await FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.docId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    nameCtrl.text = data['name'] ?? '';
    emailCtrl.text = data['email'] ?? '';
    phoneCtrl.text = data['phone'] ?? '';
    ageCtrl.text = parseInt(data['age']).toString();

    if (widget.userType == UserType.student) {
      classCtrl.text = data['class'] ?? '';
      yearCtrl.text = parseInt(data['year']).toString();
      feesCtrl.text = parseInt(data['fees']).toString();
    } else {
      qualificationCtrl.text = data['qualification'] ?? '';
      experienceCtrl.text = data['experience']?.toString() ?? '';
    }
  }

  Future<void> updateUser() async {
    final collection = widget.userType == UserType.student
        ? 'students'
        : 'teachers';

    Map<String, dynamic> updateData = {
      'name': nameCtrl.text,
      'email': emailCtrl.text,
      'phone': phoneCtrl.text,
      'age': int.parse(ageCtrl.text),
    };

    if (widget.userType == UserType.student) {
      updateData.addAll({
        'class': classCtrl.text,
        'year': int.parse(yearCtrl.text),
        'fees': int.parse(feesCtrl.text),
      });
    } else {
      updateData.addAll({
        'qualification': qualificationCtrl.text,
        'experience': experienceCtrl.text,
      });
    }

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.docId)
        .update(updateData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Updated successfully")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userType == UserType.student ? "Edit Student" : "Edit Teacher",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            UserTextField(
              label: "Name",
              controller: nameCtrl,
              hint: 'qualificaton',
              prefixIcon: Icons.time_to_leave,
            ),
            UserTextField(
              label: "Email",
              controller: emailCtrl,
              hint: 'qualificaton',
              prefixIcon: Icons.time_to_leave,
            ),
            UserTextField(
              label: "Phone",
              controller: phoneCtrl,
              hint: 'qualificaton',
              prefixIcon: Icons.time_to_leave,
            ),
            UserTextField(
              label: "Age",
              controller: ageCtrl,
              hint: 'qualificaton',
              prefixIcon: Icons.time_to_leave,
            ),

            if (widget.userType == UserType.student) ...[
              UserTextField(
                label: "Class",
                controller: classCtrl,
                hint: 'qualificaton',
                prefixIcon: Icons.time_to_leave,
              ),
              UserTextField(
                label: "Year",
                controller: yearCtrl,
                hint: 'qualificaton',
                prefixIcon: Icons.time_to_leave,
              ),
              UserTextField(
                label: "Fees",
                controller: feesCtrl,
                hint: 'qualificaton',
                prefixIcon: Icons.time_to_leave,
              ),
            ],

            if (widget.userType == UserType.teacher) ...[
              UserTextField(
                label: "Qualification",
                controller: qualificationCtrl,
                hint: 'qualificaton',
                prefixIcon: Icons.time_to_leave,
              ),
              UserTextField(
                label: "Experience",
                controller: experienceCtrl,
                hint: '',
                prefixIcon: Icons.person,
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUser,
              child: const Text("Update Details"),
            ),
          ],
        ),
      ),
    );
  }
}
