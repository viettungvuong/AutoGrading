import 'package:auto_grading_mobile/controllers/studentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Student.dart';
import '../views/studentView.dart';

class StudentManagementScreen extends StatefulWidget {

  @override
  _StudentManagementScreenState createState() => _StudentManagementScreenState();
}
class _StudentManagementScreenState extends State<StudentManagementScreen> {
  Future<List<Student>>? _students;

  Future<void> _loadStudents() async {
    await StudentRepository.instance.initialize();
    setState(() {
      _students = Future.value(StudentRepository.instance.getAllStudents());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStudents(); // Call _loadStudents() in initState to initialize _students
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(30),
          child: FutureBuilder<List<Student>>(
            future: _students,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(), // Show a loading indicator while waiting for data
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'), // Show error message if fetching data fails
                );
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                // Handle the case where snapshot.data is null or empty
                return Center(
                  child: Text('No students available'), // Show a message indicating no students available
                );
              } else {
                final students = snapshot.data!;
                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            students[index].getName(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

