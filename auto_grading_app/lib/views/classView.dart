import 'package:auto_grading_mobile/views/studentView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'View.dart';

class ClassView extends ObjectView<Class> {
  ClassView({required super.t});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
          ),
          builder: (BuildContext context) {
            return Container(
              height: 200, // Adjust the height as needed
              child: ListView.builder(
                itemCount: t.students.length,
                itemBuilder: (context, index) {
                  return StudentView(t: t.students[index]);
                },
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // You can customize the border color here
            width: 1.0, // You can adjust the border width here
          ),
          borderRadius: BorderRadius.circular(8.0), // You can adjust the border radius here
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
