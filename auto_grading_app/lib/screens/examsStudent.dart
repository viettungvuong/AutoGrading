import 'package:auto_grading_mobile/controllers/examRepository.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/Exam.dart';
import '../views/examView.dart';

class ExamStudentScreen extends StatefulWidget {

  @override
  ExamStudentState createState() => ExamStudentState();
}

class ExamStudentState extends State<ExamStudentScreen> {
  Future<List<Exam>>? _exams;

  @override
  void initState() {
    // _loadInitialize();
    super.initState();
    setState(() {
      _exams = Future.value(ExamRepository.instance.getAll());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<Exam>>(
                future: _exams,
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
                      child: Text('No exams graded'), // Show a message indicating no sessions available
                    );
                  } else {
                    final exams = snapshot.data!;
                    return ListView.builder(
                      itemCount: exams.length,
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
                                child: ExamView(t: exams[index]
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
          ],
        ),
      ),
    );
  }
}