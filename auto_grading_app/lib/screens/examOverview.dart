import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../views/examView.dart';

class ExamOverviewScreen extends StatefulWidget {
  final ExamSession session;

  ExamOverviewScreen({required this.session});

  @override
  ExamOverviewState createState() => ExamOverviewState();
}

class ExamOverviewState extends State<ExamOverviewScreen> {
  late ExamSession _session;
  @override
  void initState() {
    super.initState();
    _session=widget.session;
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Text("${_session.getName()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            ListView.builder(
              itemCount: _session.exams.length, // danh sách các bài kiểm tra
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: ExamView(t: _session.exams[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}