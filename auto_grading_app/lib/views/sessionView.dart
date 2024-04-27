import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/examSession.dart';
import '../screens/cameraScreen.dart';
import 'View.dart';
import 'examView.dart';

class ExamSessionView extends ObjectView<ExamSession> { // hien bai ktra cua hoc sinh
  ExamSessionView({required super.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exams'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                        itemCount: t.exams.length,
                        itemBuilder: (context, indexExam) {
                          return ExamView(t: t.exams[indexExam]);
                        },
                      ),
                    ),
                    IconButton(onPressed: () {
                      MaterialPageRoute(builder: (context) => CameraScreen(examSession: t));

                    }, icon: Icon(Icons.play_arrow))
                  ],
                )
              );
            },
          );
        },
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              t.getName(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}