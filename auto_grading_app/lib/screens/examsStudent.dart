import 'package:auto_grading_mobile/controllers/examRepository.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../views/examView.dart';

class ExamStudentScreen extends StatefulWidget {

  @override
  ExamStudentState createState() => ExamStudentState();
}

class ExamStudentState extends State<ExamStudentScreen> {
  late ExamSession _session;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child:
          ExamRepository.instance.getAll().isEmpty
              ? Text("No exams graded")
              : Expanded(
            child: ListView.builder(
              itemCount: ExamRepository.instance.getAll().length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: ExamView(t: _session.exams[index]),
                );
              },
            ),
          ),
          ),
        ),


    );
  }
}