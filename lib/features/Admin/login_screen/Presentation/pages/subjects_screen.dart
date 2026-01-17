import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/core/widgets/CustomTextField.dart';
import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final subjectcntrl = TextEditingController();
  final subjectccntrl = TextEditingController();

  void showDeleteDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Subject"),
          content: const Text("Are you sure you want to delete this subject?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await GoogleAuthService().deletesubject(code);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the tree
    subjectcntrl.dispose();
    subjectccntrl.dispose();

    // Always call super.dispose() at the end
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text("Add Subjects")),
      body: Column(
        children: [
          UserTextField(
            controller: subjectcntrl,
            hint: "Enter subject code or name",
            prefixIcon: Icons.notes,
            label: "Subject Name",
          ),
          SizedBox(height: 10),
          UserTextField(
            controller: subjectccntrl,
            hint: "Enter subject code or name",
            prefixIcon: Icons.notes,
            label: "Subject Code",
          ),

          MaterialButton(
            onPressed: () {
              GoogleAuthService().addSubject(
                subjectcntrl.text.trim(),
                subjectccntrl.text.trim(),
                context,
              );
              subjectccntrl.clear();
              subjectcntrl.clear();
            },
            child: Text("Add Subject"),
          ),
          Divider(),

          Text("Subjects:"),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(uid)
                  .collection("subjects")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                // 3️⃣ No data state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No subjects found"));
                }

                final subjects = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: subjects.length,

                  itemBuilder: (BuildContext context, int index) {
                    final data = subjects[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(data['name']),
                        subtitle: Text("Code: ${data['code']}"),
                        trailing: IconButton(
                          onPressed: () =>
                              showDeleteDialog(context, data['code']),

                          color: Appcolor.redColor,
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
