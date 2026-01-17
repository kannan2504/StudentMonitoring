// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AttendanceSheet extends StatefulWidget {
//   final String teacherId;
//   final String subjectId;
//   final String subjectName;
//   const AttendanceSheet({
//     super.key,
//     required this.teacherId,
//     required this.subjectId,
//     required this.subjectName,
//   });

//   @override
//   State<AttendanceSheet> createState() => _AttendanceSheetState();
// }

// class _AttendanceSheetState extends State<AttendanceSheet> {
//   DateTime selectedDate = DateTime.now();
//   String? selectedSubjectId;

//   bool selectionMode = false;
//   Set<String> selectedStudents = {};
//   String dateId(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

//   /// studentId -> { date : P/A }
//   Map<String, Map<String, String>> attendanceCache = {};

//   String formatDate(DateTime d) => d.toIso8601String().substring(0, 10);

//   List<DateTime> last5Dates() {
//     return List.generate(5, (i) => selectedDate.subtract(Duration(days: i)));
//   }

//   String attendanceDocId(String studentId, String subjectId, DateTime date) {
//     return "${studentId}_${subjectId}_${formatDate(date)}";
//   }

//   Future<void> toggleAttendance(String rollNo, String studentName) async {
//     final ref = FirebaseFirestore.instance
//         .collection('attendance')
//         .doc(widget.teacherId)
//         .collection(widget.subjectId)
//         .doc(dateId(selectedDate))
//         .collection('students')
//         .doc(rollNo);

//     final snap = await ref.get();
//     final newStatus = snap.exists && snap['status'] == "P" ? "A" : "P";

//     await ref.set({
//       'rollNo': rollNo,
//       'name': studentName,
//       'status': newStatus,
//       'date': Timestamp.fromDate(selectedDate),
//     });
//   }

//   /// ✅ Selected → P, Remaining → A
//   Future<void> markPresentForSelected(List<String> allStudents) async {
//     final batch = FirebaseFirestore.instance.batch();

//     for (final id in allStudents) {
//       final status = selectedStudents.contains(id) ? "P" : "A";
//       final docId = attendanceDocId(id, selectedSubjectId!, selectedDate);

//       final ref = FirebaseFirestore.instance.collection('attendance').doc();

//       batch.set(ref, {
//         'studentId': id,
//         'subjectId': selectedSubjectId,
//         'date': Timestamp.fromDate(selectedDate),
//         'status': status,
//       });

//       attendanceCache.putIfAbsent(id, () => {});
//       attendanceCache[id]![formatDate(selectedDate)] = status;
//     }

//     await batch.commit();
//     clearSelection();
//   }

//   /// ❌ Selected → A
//   Future<void> markAbsentForSelected() async {
//     final batch = FirebaseFirestore.instance.batch();

//     for (final id in selectedStudents) {
//       final docId = attendanceDocId(id, selectedSubjectId!, selectedDate);

//       final ref = FirebaseFirestore.instance
//           .collection('attendance')
//           .doc(docId);

//       batch.set(ref, {
//         'studentId': id,
//         'subjectId': selectedSubjectId,
//         'date': Timestamp.fromDate(selectedDate),
//         'status': "A",
//       });

//       attendanceCache.putIfAbsent(id, () => {});
//       attendanceCache[id]![formatDate(selectedDate)] = "A";
//     }

//     await batch.commit();
//     clearSelection();
//   }

//   void clearSelection() {
//     setState(() {
//       selectionMode = false;
//       selectedStudents.clear();
//     });
//   }

//   Future<void> pickDate() async {
//     final d = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2024),
//       lastDate: DateTime.now(),
//     );
//     if (d != null) setState(() => selectedDate = d);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           selectionMode ? "${selectedStudents.length} Selected" : "Attendance",
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: pickDate,
//           ),
//           if (selectionMode) ...[
//             IconButton(
//               icon: const Icon(Icons.check, color: Colors.green),
//               onPressed: () async {
//                 final snap = await FirebaseFirestore.instance
//                     .collection('students')
//                     .where('subjectId', isEqualTo: selectedSubjectId)
//                     .get();
//                 markPresentForSelected(snap.docs.map((e) => e.id).toList());
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.close, color: Colors.red),
//               onPressed: markAbsentForSelected,
//             ),
//           ],
//         ],
//       ),
//       body: Column(
//         children: [
//           /// SUBJECT SELECT
//           StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('subjects')
//                 .snapshots(),
//             builder: (context, snap) {
//               if (!snap.hasData) return const SizedBox();

//               return DropdownButton<String>(
//                 hint: const Text("Select Subject"),
//                 value: selectedSubjectId,
//                 items: snap.data!.docs
//                     .map(
//                       (d) =>
//                           DropdownMenuItem(value: d.id, child: Text(d['name'])),
//                     )
//                     .toList(),
//                 onChanged: (v) => setState(() => selectedSubjectId = v),
//               );
//             },
//           ),

//           if (selectedSubjectId == null)
//             const Expanded(child: Center(child: Text("Select subject"))),

//           if (selectedSubjectId != null)
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('students')
//                     .where('subjectId', isEqualTo: selectedSubjectId)
//                     .snapshots(),
//                 builder: (context, snap) {
//                   if (!snap.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final students = snap.data!.docs;
//                   final dates = last5Dates();

//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: [
//                         const DataColumn(label: Text("Student")),
//                         ...dates.map(
//                           (d) => DataColumn(label: Text(formatDate(d))),
//                         ),
//                       ],
//                       rows: students.map((doc) {
//                         final id = doc.id;
//                         final name = doc['name'];

//                         return DataRow(
//                           selected: selectedStudents.contains(id),
//                           onSelectChanged: (v) {
//                             setState(() {
//                               selectionMode = true;
//                               v!
//                                   ? selectedStudents.add(id)
//                                   : selectedStudents.remove(id);
//                             });
//                           },
//                           cells: [
//                             DataCell(
//                               Text(name),
//                               onLongPress: () {
//                                 setState(() {
//                                   selectionMode = true;
//                                   selectedStudents.add(id);
//                                 });
//                               },
//                             ),
//                             ...dates.map((d) {
//                               final key = formatDate(d);
//                               final value = attendanceCache[id]?[key] ?? "A";

//                               return DataCell(
//                                 Container(
//                                   padding: const EdgeInsets.all(6),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     color: value == "P"
//                                         ? Colors.green.shade100
//                                         : Colors.red.shade100,
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Text(value),
//                                 ),
//                                 onTap: () =>
//                                     toggleAttendance(id, selectedSubjectId!),
//                               );
//                             }),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyAttendanceTable extends StatefulWidget {
  final String teacherName;
  final String subjectId;
  final String subjectName;
  final String year;

  const DailyAttendanceTable({
    super.key,
    required this.teacherName,
    required this.subjectId,
    required this.subjectName,
    required this.year,
  });

  @override
  State<DailyAttendanceTable> createState() => _DailyAttendanceTableState();
}

class _DailyAttendanceTableState extends State<DailyAttendanceTable> {
  List<Map<String, dynamic>> studentsList = [];
  Map<String, String> todayAttendance = {}; // rollNo -> P/A/L
  DateTime selectedDate = DateTime.now();

  String dateId(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    loadStudentsAndAttendance();
  }

  Future<void> loadStudentsAndAttendance() async {
    // 1️⃣ Load students
    final snapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.year)
        .collection('lists')
        .orderBy('rollno')
        .get();

    studentsList = snapshot.docs.map((s) {
      return {'rollNo': s['rollno'].toString(), 'name': s['name']};
    }).toList();

    await loadAttendanceForDate(selectedDate);

    setState(() {});
  }

  // Future<void> loadAttendanceForDate(DateTime date) async {
  //   final teacherDoc = widget.teacherName.trim().toLowerCase().replaceAll(
  //     " ",
  //     "_",
  //   );
  //   todayAttendance.clear();
  //   for (var student in studentsList) {
  //     final rollNo = student['rollNo'];
  //     final doc = await FirebaseFirestore.instance
  //         .collection('attendance')
  //         .doc(teacherDoc)
  //         .collection(widget.subjectId)
  //         .doc(dateId(date))
  //         .collection('students')
  //         .doc(rollNo)
  //         .get();

  //     todayAttendance[rollNo] = doc.exists ? doc['status'] : "N"; // default P
  //   }
  //   setState(() {});
  // }

  //
  //
  Future<void> loadAttendanceForDate(DateTime date) async {
    final teacherDoc = widget.teacherName.trim().toLowerCase().replaceAll(
      " ",
      "_",
    );

    todayAttendance.clear();

    final snapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(teacherDoc)
        .collection(widget.subjectId)
        .doc(dateId(date))
        .collection('students')
        .get();

    // Map existing attendance
    for (var doc in snapshot.docs) {
      todayAttendance[doc.id] = doc['status'];
    }

    // Mark remaining students as Not Marked
    for (var student in studentsList) {
      final rollNo = student['rollNo'];
      todayAttendance.putIfAbsent(rollNo, () => "N");
    }

    setState(() {});
  }

  void toggleStatus(String rollNo) {
    setState(() {
      final current = todayAttendance[rollNo] ?? "P";
      if (current == "P") {
        todayAttendance[rollNo] = "A";
      } else if (current == "A") {
        todayAttendance[rollNo] = "L";
      } else {
        todayAttendance[rollNo] = "P";
      }
    });
  }

  Future<void> submitAttendance() async {
    final teacherDoc = widget.teacherName.trim().toLowerCase().replaceAll(
      " ",
      "_",
    );
    final batch = FirebaseFirestore.instance.batch();

    for (var student in studentsList) {
      final rollNo = student['rollNo'];
      final status = todayAttendance[rollNo] ?? "P";

      final docRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(teacherDoc)
          .collection(widget.subjectId)
          .doc(dateId(selectedDate))
          .collection('students')
          .doc(rollNo);

      batch.set(docRef, {
        'rollNo': rollNo,
        'name': student['name'],
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Attendance updated!")));
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate = picked;
      await loadAttendanceForDate(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (studentsList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subjectName} Attendance"),
        actions: [
          TextButton(
            onPressed: pickDate,
            child: Text(
              "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: submitAttendance,
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Roll No")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Status")),
          ],
          rows: studentsList.map((student) {
            final rollNo = student['rollNo'];
            final name = student['name'];
            final status = todayAttendance[rollNo] ?? "P";

            Color bgColor;
            if (status == "P") {
              bgColor = Colors.green.shade200;
            } else if (status == "A") {
              bgColor = Colors.red.shade200;
            } else {
              bgColor = Colors.orange.shade200; // L for late
            }

            return DataRow(
              cells: [
                DataCell(Text(rollNo)),
                DataCell(Text(name)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: bgColor,
                    child: GestureDetector(
                      onTap: () => toggleStatus(rollNo),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
