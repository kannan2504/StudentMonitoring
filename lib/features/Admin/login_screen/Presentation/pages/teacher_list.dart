// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:loginpage/core/constants/Appcolor.dart';
// // import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';

// // class teacherList extends StatefulWidget {
// //   const teacherList({super.key});

// //   @override
// //   State<teacherList> createState() => _teacherListState();
// // }

// // class _teacherListState extends State<teacherList> {
// //   void showDeleteDialog(BuildContext context, String docId) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("Delete Teacher"),
// //         content: const Text("Are you sure you want to delete this teacher?"),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("Cancel"),
// //           ),
// //           TextButton(
// //             onPressed: () async {
// //               await GoogleAuthService().deleteTeacher(docId);
// //               Navigator.pop(context);
// //             },
// //             child: const Text("Delete", style: TextStyle(color: Colors.red)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   String searchQuery = '';
// //   String? selectedExp;
// //   int? selectedQuali;

// //   List<String> expList = [];
// //   List<int> qualiList = [];

// //   int sortColumnIndex = 0;
// //   bool isAscending = true;
// //   int parseYear(dynamic value) {
// //     if (value is int) return value;
// //     if (value is String) return int.tryParse(value) ?? 0;
// //     return 0;
// //   }

// //   bool matchesSearch(Map<String, dynamic> data) {
// //     final name = data['name'].toString().toLowerCase();
// //     final email = data['email'].toString().toLowerCase();
// //     return name.contains(searchQuery) || email.contains(searchQuery);
// //   }

// //   bool matchesFilter(Map<String, dynamic> data) {
// //     if (selectedQuali != null && data['class'] != selectedQuali) {
// //       return false;
// //     }
// //     if (selectedExp != null && parseYear(data['experience']) != selectedExp) {
// //       return false;
// //     }
// //     return true;
// //   }

// //   void resetFilters() {
// //     setState(() {
// //       searchQuery = '';
// //       selectedExp = null;
// //       selectedQuali = null;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //    return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Teachers List"),
// //         actions: [
// //           TextButton.icon(
// //             onPressed: resetFilters,
// //             icon: const Icon(
// //               Icons.refresh,
// //               color: Color.fromARGB(255, 29, 28, 28),
// //             ),
// //             label: const Text(
// //               "Reset Filters",
// //               style: TextStyle(color: Color.fromARGB(255, 17, 16, 16)),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // 🔍 SEARCH + FILTER BAR
// //           Padding(
// //             padding: const EdgeInsets.all(8),
// //             child: Row(
// //               children: [
// //                 // SEARCH
// //                 Expanded(
// //                   child: TextField(
// //                     decoration: const InputDecoration(
// //                       hintText: "Search by name or email",
// //                       prefixIcon: Icon(Icons.search),
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         searchQuery = value.toLowerCase();
// //                       });
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),

// //                 // CLASS FILTER
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: Appcolor.lightblack),
// //                     borderRadius: BorderRadius.circular(5),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(left: 5.0),
// //                     child: DropdownButtonHideUnderline(
// //                       child: DropdownButton<String>(
// //                         hint: const Text("Class"),
// //                         value: selectedExp,
// //                         items: expList
// //                             .map(
// //                               (c) => DropdownMenuItem<String>(
// //                                 value: c,
// //                                 child: Text(c),
// //                               ),
// //                             )
// //                             .toList(),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             selectedExp = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),

// //                 // YEAR FILTER
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: Appcolor.lightblack),
// //                     borderRadius: BorderRadius.circular(5),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(left: 5.0),
// //                     child: DropdownButtonHideUnderline(
// //                       child: DropdownButton<int>(
// //                         hint: const Text("Year"),
// //                         value: selectedQuali,
// //                         items: selectedQuali
// //                             .map(
// //                               (y) => DropdownMenuItem<int>(
// //                                 value: y,
// //                                 child: Text("Year $y"),
// //                               ),
// //                             )
// //                             .toList(),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             selectedQuali = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           // 📊 DATA TABLE
// //           Expanded(
// //             child: StreamBuilder<QuerySnapshot>(
// //               stream: FirebaseFirestore.instance
// //                   .collection('teachers')
// //                   .snapshots(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 final snapDocs = snapshot.data!.docs;

// //                 // 🔹 Extract unique classes & years
// //                 expList = snapDocs
// //                     .map(
// //                       (d) =>
// //                           (d.data() as Map<String, dynamic>)['experience'] as String,
// //                     )
// //                     .toSet()
// //                     .toList();

// //                 qualiList = snapDocs
// //                     .map(
// //                       (d) =>
// //                           parseYear((d.data() as Map<String, dynamic>)['class']),
// //                     )
// //                     .where((y) => y != 0)
// //                     .toSet()
// //                     .toList();

// //                 // 🔹 Convert docs
// //                 var docs = snapDocs
// //                     .map(
// //                       (doc) => {
// //                         ...doc.data() as Map<String, dynamic>,
// //                         'id': doc.id,
// //                       },
// //                     )
// //                     .where((d) => matchesSearch(d) && matchesFilter(d))
// //                     .toList();

// //                 // 🔃 SORTING
// //                 docs.sort((a, b) {
// //                   final ay = parseYear(a['year']);
// //                   final by = parseYear(b['year']);

// //                   if (sortColumnIndex == 1) {
// //                     return isAscending
// //                         ? a['age'].compareTo(b['age'])
// //                         : b['age'].compareTo(a['age']);
// //                   }

// //                   if (sortColumnIndex == 2) {
// //                     return isAscending ? ay.compareTo(by) : by.compareTo(ay);
// //                   }
// //                   return 0;
// //                 });

// //                 return SingleChildScrollView(
// //                   scrollDirection: Axis.horizontal,
// //                   child: DataTable(
// //                     sortColumnIndex: sortColumnIndex,
// //                     sortAscending: isAscending,
// //                     columns: [
// //                       const DataColumn(label: Text("Name")),
// //                       DataColumn(
// //                         label: const Text("Age"),
// //                         onSort: (i, asc) {
// //                           setState(() {
// //                             sortColumnIndex = i;
// //                             isAscending = asc;
// //                           });
// //                         },
// //                       ),
// //                       DataColumn(
// //                         label: const Text("Year"),
// //                         onSort: (i, asc) {
// //                           setState(() {
// //                             sortColumnIndex = i;
// //                             isAscending = asc;
// //                           });
// //                         },
// //                       ),
// //                       const DataColumn(label: Text("Class")),
// //                       const DataColumn(label: Text("Email")),
// //                       const DataColumn(label: Text("Phone")),
// //                       const DataColumn(label: Text("Actions")),
// //                     ],
// //                     rows: docs.map((data) {
// //                       return DataRow(
// //                         cells: [
// //                           DataCell(Text(data['name'])),
// //                           DataCell(Text(data['age'].toString())),
// //                           DataCell(Text(parseYear(data['year']).toString())),
// //                           DataCell(Text(data['class'])),
// //                           DataCell(Text(data['email'])),
// //                           DataCell(Text(data['phone'].toString())),
// //                           DataCell(
// //                             Row(
// //                               children: [
// //                                 IconButton(
// //                                   icon: const Icon(Icons.edit),
// //                                   onPressed: () {
// //                                     Navigator.push(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                         builder: (_) => StudentListEditpage(
// //                                           docId: data['id'],
// //                                         ),
// //                                       ),
// //                                     );
// //                                   },
// //                                 ),
// //                                 IconButton(
// //                                   icon: const Icon(
// //                                     Icons.delete,
// //                                     color: Colors.red,
// //                                   ),
// //                                   onPressed: () =>
// //                                       showDeleteDialog(context, data['id']),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       );
// //                     }).toList(),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //   }
// // }import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loginpage/core/constants/Appcolor.dart';
// import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
// import 'package:loginpage/features/Admin/login_screen/Presentation/pages/student_list_editpage.dart';

// class TeacherList extends StatefulWidget {
//   const TeacherList({super.key});

//   @override
//   State<TeacherList> createState() => _TeacherListState();
// }

// class _TeacherListState extends State<TeacherList> {
//   String searchQuery = '';

//   // ✅ BOTH STRING (matches Firestore)
//   String? selectedExperience;
//   String? selectedClass;

//   List<String> experienceList = [];
//   List<String> classList = [];

//   void resetFilters() {
//     setState(() {
//       searchQuery = '';
//       selectedExperience = null;
//       selectedClass = null;
//     });
//   }

//   void showDeleteDialog(BuildContext context, String docId) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Delete Teacher"),
//         content: const Text("Are you sure you want to delete this teacher?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               await GoogleAuthService().deleteTeacher(docId);
//               Navigator.pop(context);
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   bool matchesSearch(Map<String, dynamic> data) {
//     return data['name'].toString().toLowerCase().contains(searchQuery) ||
//         data['email'].toString().toLowerCase().contains(searchQuery);
//   }

//   bool matchesFilter(Map<String, dynamic> data) {
//     if (selectedExperience != null &&
//         data['experience'] != selectedExperience) {
//       return false;
//     }
//     if (selectedClass != null && data['class'] != selectedClass) {
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Teachers List"),
//         actions: [
//           TextButton.icon(
//             onPressed: resetFilters,
//             icon: const Icon(Icons.refresh, color: Colors.black),
//             label: const Text(
//               "Reset Filters",
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 🔍 SEARCH & FILTER BAR
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: const InputDecoration(
//                       hintText: "Search name or email",
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (v) =>
//                         setState(() => searchQuery = v.toLowerCase()),
//                   ),
//                 ),
//                 const SizedBox(width: 10),

//                 // EXPERIENCE DROPDOWN
//                 dropdownBox(
//                   hint: "Experience",
//                   value: selectedExperience,
//                   items: experienceList,
//                   onChanged: (v) => setState(() => selectedExperience = v),
//                 ),

//                 const SizedBox(width: 10),

//                 // CLASS DROPDOWN
//                 dropdownBox(
//                   hint: "Class",
//                   value: selectedClass,
//                   items: classList,
//                   onChanged: (v) => setState(() => selectedClass = v),
//                 ),
//               ],
//             ),
//           ),

//           // 📊 TABLE
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('teachers')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final docs = snapshot.data!.docs;

//                 // 🔹 UNIQUE VALUES FROM FIRESTORE
//                 experienceList = docs
//                     .map((d) => (d['experience']).toString())
//                     .toSet()
//                     .toList();

//                 classList = docs
//                     .map((d) => (d['class']).toString())
//                     .toSet()
//                     .toList();

//                 final filteredDocs = docs
//                     .map(
//                       (doc) => {
//                         ...doc.data() as Map<String, dynamic>,
//                         'id': doc.id,
//                       },
//                     )
//                     .where((d) => matchesSearch(d) && matchesFilter(d))
//                     .toList();

//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columns: const [
//                       DataColumn(label: Text("Name")),
//                       DataColumn(label: Text("Age")),
//                       DataColumn(label: Text("Experience")),
//                       DataColumn(label: Text("Class")),
//                       DataColumn(label: Text("Email")),
//                       DataColumn(label: Text("Phone")),
//                       DataColumn(label: Text("Action")),
//                     ],
//                     rows: filteredDocs.map((d) {
//                       return DataRow(
//                         cells: [
//                           DataCell(Text(d['name'])),
//                           DataCell(Text(d['age'].toString())),
//                           DataCell(Text(d['experience'])),
//                           DataCell(Text(d['class'])),
//                           DataCell(Text(d['email'])),
//                           DataCell(Text(d['phone'].toString())),
//                           DataCell(
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.edit,
//                                     color: Colors.blue,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => EditUserPage(
//                                           docId: data['id'],
//                                           userType: UserType.teacher,
//                                         ),
//                                       ),
//                                     );

//                                     // edit action
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                   ),
//                                   onPressed: () =>
//                                       showDeleteDialog(context, d['id']),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔧 COMMON DROPDOWN WIDGET
//   Widget dropdownBox({
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Appcolor.lightblack),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           hint: Text(hint),
//           value: value,
//           items: items
//               .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
//               .toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/core/constants/Appcolor.dart';
import 'package:loginpage/features/Admin/login_screen/Data/Service/google_auth_service.dart';
import 'package:loginpage/features/Admin/login_screen/Presentation/pages/student_list_editpage.dart';

class TeacherList extends StatefulWidget {
  final bool selectMode;
  const TeacherList({super.key, this.selectMode = false});

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  String searchQuery = '';

  String? selectedExperience;
  String? selectedClass;

  List<String> experienceList = [];
  List<String> classList = [];

  void resetFilters() {
    setState(() {
      searchQuery = '';
      selectedExperience = null;
      selectedClass = null;
    });
  }

  void showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Teacher"),
        content: const Text("Are you sure you want to delete this teacher?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await GoogleAuthService().deleteTeacher(docId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool matchesSearch(Map<String, dynamic> data) {
    return data['name'].toString().toLowerCase().contains(searchQuery) ||
        data['email'].toString().toLowerCase().contains(searchQuery);
  }

  bool matchesFilter(Map<String, dynamic> data) {
    if (selectedExperience != null &&
        data['experience'].toString() != selectedExperience) {
      return false;
    }
    if (selectedClass != null && data['class'].toString() != selectedClass) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teachers List"),
        actions: [
          TextButton.icon(
            onPressed: resetFilters,
            icon: const Icon(Icons.refresh, color: Colors.black),
            label: const Text(
              "Reset Filters",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 SEARCH & FILTER BAR
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search name or email",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) =>
                        setState(() => searchQuery = v.toLowerCase()),
                  ),
                ),
                const SizedBox(width: 10),

                dropdownBox(
                  hint: "Experience",
                  value: selectedExperience,
                  items: experienceList,
                  onChanged: (v) => setState(() => selectedExperience = v),
                ),

                const SizedBox(width: 10),

                dropdownBox(
                  hint: "Class",
                  value: selectedClass,
                  items: classList,
                  onChanged: (v) => setState(() => selectedClass = v),
                ),
              ],
            ),
          ),

          // 📊 TABLE
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teachers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                // UNIQUE FILTER VALUES
                experienceList = docs
                    .map((d) => d['experience'].toString())
                    .toSet()
                    .toList();

                classList = docs
                    .map((d) => d['class'].toString())
                    .toSet()
                    .toList();

                final filteredDocs = docs
                    .map(
                      (doc) => {
                        ...doc.data() as Map<String, dynamic>,
                        'id': doc.id,
                      },
                    )
                    .where((d) => matchesSearch(d) && matchesFilter(d))
                    .toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Age")),
                      DataColumn(label: Text("Experience")),
                      DataColumn(label: Text("Class")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Phone")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows: filteredDocs.map((d) {
                      return DataRow(
                        cells: [
                          DataCell(Text(d['name'])),
                          DataCell(Text(d['age'].toString())),
                          DataCell(Text(d['experience'].toString())),
                          DataCell(Text(d['class'].toString())),
                          DataCell(Text(d['email'])),
                          DataCell(Text(d['phone'].toString())),
                          DataCell(
                            widget.selectMode
                                ? ElevatedButton(
                                    onPressed: () => GoogleAuthService()
                                        .makeAdmin(context, d),
                                    child: const Text("Make Admin"),
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            showDeleteDialog(context, d['id']),
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

  // 🔧 COMMON DROPDOWN
  Widget dropdownBox({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Appcolor.lightblack),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint),
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
