import 'package:auto_grading_mobile/repositories/studentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Student.dart';
import '../views/studentView.dart';
import '../views/viewFactory.dart';
import '../widgets/searchBar.dart';

class StudentManagementScreen extends StatefulWidget {
  @override
  _StudentManagementScreenState createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  Future<List<Student>>? _students;

  Future<void> _loadStudents() async {
    await StudentRepository.instance.initialize();
    setState(() {
      _students = Future.value(StudentRepository.instance.getAll());
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Search(
              onSearch: (query) {
                setState(() {
                  _students = Future.value(
                      StudentRepository.instance.filter(query));
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: _students,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No students available'),
                    );
                  } else {
                    final students = snapshot.data!;
                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return ObjectViewFactory.getView(students[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
