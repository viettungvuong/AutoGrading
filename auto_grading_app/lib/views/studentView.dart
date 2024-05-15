import 'package:auto_grading_mobile/views/examView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Student.dart';
import 'View.dart';

import 'package:flutter/cupertino.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'View.dart';

class StudentView extends ObjectView<Student> {
  void _showPopup(BuildContext context, Student student) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
          child:Student.getExamsOfStudent(student).isNotEmpty?examsList(Student.getExamsOfStudent(student),true)
              :Center(child: Text("No exams")),
        );
      },
    );
  }


  StudentView({required super.t});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopup(context, t);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // You can customize the border color here
            width: 1.0, // You can adjust the border width here
          ),
          borderRadius: BorderRadius.circular(
              8.0), // You can adjust the border radius here
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.getName(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
