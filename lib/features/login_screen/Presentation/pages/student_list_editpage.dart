// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:loginpage/core/widgets/CustomTextField.dart';

// class StudentListEditpage extends StatelessWidget {
//   final String docId;
//   StudentListEditpage({super.key, required this.docId});
//   final namecntrl = TextEditingController();
//   final agecntrl = TextEditingController();
//   final phonecntrl = TextEditingController();
//   final classcntrl = TextEditingController();
//   final pricecntrl = TextEditingController();

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

//         if(doc.exists){
//            namecntrl.text = doc['name'];
//       agecntrl.text = doc['age'].toString();
//       phonecntrl.text = doc['phone'];
//       classcntrl.text = doc['class'] ?? ''; 
//        pricecntrl.text = doc['price'].toString(); 
//         }


//   }

//   void _updateUser() async {
  
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.docId)
//           .update({
//         'name': namecntrl.text,
//         'age': int.parse(ageController.text),
//         'tech': techController.text,
//         'email': emailController.text, // new field added
//       });

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('User updated successfully')));
//       Navigator.pop(context);
    
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
//             label: "class",
//             controller: classcntrl,
//             hint: 'UG',
//             prefixIcon: Icons.menu_book_sharp,
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
//           ElevatedButton(onPressed: () {}, child: Text("update Detials")),
//         ],
//       ),
//     );
//   }
// }
