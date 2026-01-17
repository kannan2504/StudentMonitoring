import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceViewPage extends StatefulWidget {
  final String teacherName;
  final String subjectCode;
  final String subjectName;
  final String year;

  const AttendanceViewPage({
    Key? key,
    required this.teacherName,
    required this.subjectCode,
    required this.subjectName,
    required this.year,
  }) : super(key: key);

  @override
  State<AttendanceViewPage> createState() => _AttendanceViewPageState();
}

class _AttendanceViewPageState extends State<AttendanceViewPage> {
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    if (_selectedDate == null) return;

    setState(() => _isLoading = true);

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final teacherDocId = widget.teacherName.trim().toLowerCase().replaceAll(
        " ",
        "_",
      );

      // Get attendance for the selected date
      final attendanceSnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(teacherDocId)
          .collection('subjects')
          .doc(widget.subjectCode )
          .collection('dates')
          .doc(dateStr)
          .get();

      if (attendanceSnapshot.exists) {
        final data = attendanceSnapshot.data() as Map<String, dynamic>;

        // Get all students for this year
        final studentsSnapshot = await FirebaseFirestore.instance
            .collection('students')
            .doc(widget.year)
            .collection('lists')
            .get();

        _attendanceRecords.clear();

        for (var studentDoc in studentsSnapshot.docs) {
          final studentData = studentDoc.data();
          final studentId = studentDoc.id;

          // Check attendance status for this student
          final attendanceStatus = data[studentId] ?? 'Absent';

          _attendanceRecords.add({
            'id': studentId,
            'name': studentData['name'] ?? 'Unknown',
            'rollNo': studentData['rollNo'] ?? 'N/A',
            'status': attendanceStatus,
            'timestamp': data['${studentId}_timestamp'] ?? 'N/A',
          });
        }
      } else {
        _attendanceRecords.clear();
      }
    } catch (e) {
      print("Error fetching attendance: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _fetchAttendanceData();
    }
  }

  Future<void> _viewMonthlyReport() async {
    final month = DateFormat(
      'MMM yyyy',
    ).format(_selectedDate ?? DateTime.now());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Monthly Report - $month"),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: FutureBuilder(
            future: _fetchMonthlyReport(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final monthlyData =
                  snapshot.data as Map<String, Map<String, dynamic>>? ?? {};

              if (monthlyData.isEmpty) {
                return const Center(
                  child: Text("No attendance records for this month"),
                );
              }

              return ListView.builder(
                itemCount: monthlyData.length,
                itemBuilder: (context, index) {
                  final studentId = monthlyData.keys.elementAt(index);
                  final studentData = monthlyData[studentId]!;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(studentData['name']),
                      subtitle: Text(
                        "Present: ${studentData['present']} days | "
                        "Absent: ${studentData['absent']} days | "
                        "Percentage: ${studentData['percentage'].toStringAsFixed(1)}%",
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<Map<String, Map<String, dynamic>>> _fetchMonthlyReport() async {
    final month = DateFormat('yyyy-MM').format(_selectedDate ?? DateTime.now());
    final teacherDocId = widget.teacherName.trim().toLowerCase().replaceAll(
      " ",
      "_",
    );

    final attendanceSnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(teacherDocId)
        .collection('subjects')
        .doc(widget.subjectCode)
        .collection('years')
        .doc(widget.year)
        .collection('dates')
        .where('date', isGreaterThanOrEqualTo: '${month}-01')
        .where('date', isLessThanOrEqualTo: '${month}-31')
        .get();

    final Map<String, Map<String, dynamic>> studentStats = {};

    // Initialize all students
    final studentsSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.year)
        .collection('lists')
        .get();

    for (var student in studentsSnapshot.docs) {
      studentStats[student.id] = {
        'name': student.data()['name'] ?? 'Unknown',
        'present': 0,
        'absent': 0,
        'total': 0,
        'percentage': 0.0,
      };
    }

    // Count attendance
    for (var day in attendanceSnapshot.docs) {
      final dayData = day.data();
      for (var studentId in studentStats.keys) {
        final status = dayData[studentId];
        if (status == 'P') {
          studentStats[studentId]!['present']++;
        } else {
          studentStats[studentId]!['absent']++;
        }
        studentStats[studentId]!['total']++;
      }
    }

    // Calculate percentages
    for (var studentId in studentStats.keys) {
      final stats = studentStats[studentId]!;
      if (stats['total'] > 0) {
        stats['percentage'] = (stats['present'] / stats['total']) * 100;
      }
    }

    return studentStats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance - ${widget.subjectName} (Year ${widget.year})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _viewMonthlyReport,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text("Change Date"),
                ),
              ],
            ),
          ),

          // Summary Stats
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  "Total",
                  _attendanceRecords.length.toString(),
                  Colors.blue,
                ),
                _buildStatCard(
                  "Present",
                  _attendanceRecords
                      .where((r) => r['status'] == 'Present')
                      .length
                      .toString(),
                  Colors.green,
                ),
                _buildStatCard(
                  "Absent",
                  _attendanceRecords
                      .where((r) => r['status'] == 'Absent')
                      .length
                      .toString(),
                  Colors.red,
                ),
              ],
            ),
          ),

          // Attendance List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _attendanceRecords.isEmpty
                ? const Center(
                    child: Text(
                      "No attendance records for this date",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = _attendanceRecords[index];
                      final isPresent = record['status'] == 'Present';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isPresent
                                ? Colors.green
                                : Colors.red,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(record['name']),
                          subtitle: Text("Roll No: ${record['rollNo']}"),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isPresent ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              record['status'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
