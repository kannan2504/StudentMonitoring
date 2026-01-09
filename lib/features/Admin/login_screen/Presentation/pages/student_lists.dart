import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/student_list_editpage.dart';

class StudentLists extends StatefulWidget {
  const StudentLists({super.key});

  @override
  State<StudentLists> createState() => _StudentListsState();
}

class _StudentListsState extends State<StudentLists> {
  String searchQuery = '';
  String? selectedClass;
  int? selectedYear;

  List<String> classList = [];
  List<int> yearList = [];

  int sortColumnIndex = 0;
  bool isAscending = true;

  /// ✅ SAFE YEAR PARSER (handles String or int)
  int parseYear(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  void resetFilters() {
    setState(() {
      searchQuery = '';
      selectedClass = null;
      selectedYear = null;
    });
  }

  void showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Student"),
        content: const Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await GoogleAuthService().deleteStudent(docId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool matchesSearch(Map<String, dynamic> data) {
    final name = data['name'].toString().toLowerCase();
    final email = data['email'].toString().toLowerCase();
    return name.contains(searchQuery) || email.contains(searchQuery);
  }

  bool matchesFilter(Map<String, dynamic> data) {
    if (selectedClass != null && data['class'] != selectedClass) {
      return false;
    }
    if (selectedYear != null && parseYear(data['year']) != selectedYear) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        actions: [
          TextButton.icon(
            onPressed: resetFilters,
            icon: const Icon(
              Icons.refresh,
              color: Color.fromARGB(255, 29, 28, 28),
            ),
            label: const Text(
              "Reset Filters",
              style: TextStyle(color: Color.fromARGB(255, 17, 16, 16)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 SEARCH + FILTER BAR
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // SEARCH
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search by name or email",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // CLASS FILTER
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Appcolor.lightblack),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text("Class"),
                        value: selectedClass,
                        items: classList
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c,
                                child: Text(c),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // YEAR FILTER
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Appcolor.lightblack),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        hint: const Text("Year"),
                        value: selectedYear,
                        items: yearList
                            .map(
                              (y) => DropdownMenuItem<int>(
                                value: y,
                                child: Text("Year $y"),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📊 DATA TABLE
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final snapDocs = snapshot.data!.docs;

                // 🔹 Extract unique classes & years
                classList = snapDocs
                    .map(
                      (d) =>
                          (d.data() as Map<String, dynamic>)['class'] as String,
                    )
                    .toSet()
                    .toList();

                yearList = snapDocs
                    .map(
                      (d) =>
                          parseYear((d.data() as Map<String, dynamic>)['year']),
                    )
                    .where((y) => y != 0)
                    .toSet()
                    .toList();

                // 🔹 Convert docs
                var docs = snapDocs
                    .map(
                      (doc) => {
                        ...doc.data() as Map<String, dynamic>,
                        'id': doc.id,
                      },
                    )
                    .where((d) => matchesSearch(d) && matchesFilter(d))
                    .toList();

                // 🔃 SORTING
                docs.sort((a, b) {
                  final ay = parseYear(a['year']);
                  final by = parseYear(b['year']);

                  if (sortColumnIndex == 1) {
                    return isAscending
                        ? a['age'].compareTo(b['age'])
                        : b['age'].compareTo(a['age']);
                  }

                  if (sortColumnIndex == 2) {
                    return isAscending ? ay.compareTo(by) : by.compareTo(ay);
                  }
                  return 0;
                });

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: isAscending,
                    columns: [
                      const DataColumn(label: Text("Name")),
                      DataColumn(
                        label: const Text("Age"),
                        onSort: (i, asc) {
                          setState(() {
                            sortColumnIndex = i;
                            isAscending = asc;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text("Year"),
                        onSort: (i, asc) {
                          setState(() {
                            sortColumnIndex = i;
                            isAscending = asc;
                          });
                        },
                      ),
                      const DataColumn(label: Text("Class")),
                      const DataColumn(label: Text("Email")),
                      const DataColumn(label: Text("Phone")),
                      const DataColumn(label: Text("Actions")),
                    ],
                    rows: docs.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data['name'])),
                          DataCell(Text(data['age'].toString())),
                          DataCell(Text(parseYear(data['year']).toString())),
                          DataCell(Text(data['class'])),
                          DataCell(Text(data['email'])),
                          DataCell(Text(data['phone'].toString())),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditUserPage(
                                          docId: data['id'], userType: UserType.student,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      showDeleteDialog(context, data['id']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
// import 'package:flutter/material.dart';
// import 'package:loginpage/core/constants/Appcolor.dart';
// import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
// import 'package:loginpage/features/Admin/login_screen/Presentation/pages/student_list_editpage.dart';

// class StudentLists extends StatelessWidget {
//   const StudentLists({super.key});

//   void showDeleteDialog(BuildContext context, String docId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Delete Student"),
//           content: const Text("Are you sure you want to delete this student?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await GoogleAuthService().deleteStudent(docId);
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('students').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const CircularProgressIndicator();
//           }
//           return Column(
//             children: [
//               Row(children: [Text("Name"),Text("Age"),Text("year"),Text("class"),Text("email"),Text("phone")],)
//               ,
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final data =
//                         snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                     final docId = snapshot.data!.docs[index].id;
//                     return Container(
//                       decoration: BoxDecoration(
//                         border: BoxBorder.all(color: Appcolor.lightblack),
//                       ),
//                       child: Row(
//                         children: [
//                           Text(data['name']),
//                           Text(data["age"].toString()),
//                           Text(data['year'].toString()),
//                           Text(data['class']),
//                           Text(data['email']),
//                           Text(data['phone'].toString()),
//                           InkWell(
//                             onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     StudentListEditpage(docId: docId),
//                               ),
//                             ),
//                             child: Icon(Icons.edit),
//                           ),
//                           InkWell(
//                             onTap: () => showDeleteDialog(context, docId),
//                             child: Icon(Icons.delete),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),

//       //   body: StreamBuilder<DocumentSnapshot>(
//       //     stream: FirebaseFirestore.instance
//       //         .collection('students')
//       //         .doc(FirebaseAuth.instance.currentUser!.uid)
//       //         .snapshots(),
//       //     builder: (context, snapshot) {
//       //       // Loading state
//       //       if (snapshot.connectionState == ConnectionState.waiting) {
//       //         return CircularProgressIndicator();
//       //       }

//       //       // If document does not exist
//       //       if (!snapshot.hasData || !snapshot.data!.exists) {
//       //         return Text("User data not found");
//       //       }

//       //       // Convert snapshot to a Map
//       //       final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

//       //       // Safe read: check if 'name' exists
//       //       final name = userData.containsKey('name') && userData['name'] != null
//       //           ? userData['name']
//       //           : 'No Name';

//       //       // Display
//       //       return Text(
//       //         "Welcome, $name",
//       //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       //       );
//       //     },
//       //   ),
//     );
//   }
// }
