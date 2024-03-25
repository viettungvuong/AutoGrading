import 'package:auto_grading_mobile/models/examInformation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestOverviewScreen extends StatefulWidget {
  final ExamSession session;

  TestOverviewScreen({required this.session});

  @override
  TestOverviewState createState() => TestOverviewState();
}

class TestOverviewState extends State<TestOverviewScreen> {
  late ExamSession _session;
  @override
  void initState() {
    super.initState();
    _session=widget.session;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("${_session.getName()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),


          ],
        ),
      ),
    );
  }
}