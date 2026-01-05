import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

class StudentLists extends StatelessWidget {
  const StudentLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          print("ALL students count: ${snapshot.data!.docs.length}");

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name']),
                trailing: Text(data["age"].toString()),
              );
            },
          );
        },
      ),

      //   body: StreamBuilder<DocumentSnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection('students')
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       // Loading state
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return CircularProgressIndicator();
      //       }

      //       // If document does not exist
      //       if (!snapshot.hasData || !snapshot.data!.exists) {
      //         return Text("User data not found");
      //       }

      //       // Convert snapshot to a Map
      //       final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

      //       // Safe read: check if 'name' exists
      //       final name = userData.containsKey('name') && userData['name'] != null
      //           ? userData['name']
      //           : 'No Name';

      //       // Display
      //       return Text(
      //         "Welcome, $name",
      //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //       );
      //     },
      //   ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:loginpage/core/widgets/CustomTextField.dart';
// import 'package:intl/intl.dart';

// class Studentform extends StatefulWidget {
//   const Studentform({super.key});

//   @override
//   State<Studentform> createState() => _StudentformState();
// }

// class _StudentformState extends State<Studentform> {
//   final namecntrl = TextEditingController();
//   final phonecntrl = TextEditingController();
//   final agecntrl = TextEditingController();
//   final datecntrl = TextEditingController();
//   final classcntrl = TextEditingController();

//   Future<void> pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       String formattedDate = DateFormat(
//         'dd MMM yyyy',
//       ).format(pickedDate); // 25 Apr 2026

//       setState(() {
//         datecntrl.text = formattedDate;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return AlertDialog(
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             UserTextField(
//               label: "Name",
//               controller: namecntrl,
//               hint: 'Kannan M',
//               prefixIcon: Icons.person,
//             ),
//             SizedBox(height: 5),
//             UserTextField(
//               label: "Phone number",
//               controller: phonecntrl,
//               hint: '123456789',
//               prefixIcon: Icons.phone,
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 5),
//             UserTextField(
//               label: "Age",
//               controller: agecntrl,
//               hint: '22',
//               prefixIcon: Icons.timer_outlined,
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 5),
//             UserTextField(
//               label: "class",
//               controller: classcntrl,
//               hint: 'UG',
//               prefixIcon: Icons.menu_book_sharp,
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 5),
//             Container(
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextField(
//                 controller: datecntrl,

//                 readOnly: true, // 🔒 disables typing
//                 onTap: pickDate, // 📅 opens date picker
//                 decoration: InputDecoration(
//                   labelText: "Join Date",
//                   hintText: "dd-mm-yyyy",
//                   prefixIcon: Icon(Icons.date_range),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(vertical: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
