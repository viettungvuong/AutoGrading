import 'package:auto_grading_mobile/controllers/studentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Student.dart';

class StudentManagementScreen extends StatefulWidget {

  @override
  _StudentManagementScreenState createState() => _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  late List<Student> _students;

  @override
  void initState() {
    _students = StudentRepository.instance.getAllStudents().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(30),
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              Student student = _students[index];
              return /* Your item widget */;
            },
          ),
        ),
      ),
    );
  }


}