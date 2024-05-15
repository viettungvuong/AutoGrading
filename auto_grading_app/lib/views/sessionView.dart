import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';
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
                  content:
                  Container(
                    width: double.maxFinite,
                    child: t.exams.isEmpty ? Center(
                      child: Text("No exams"),
                    ):ListView.builder(
                      shrinkWrap: true,
                      itemCount: t.exams.length+1, // lam the nay de co the hien diem trung binh ma kh bi loi has size
                      itemBuilder: (context, indexExam) {
                        if (indexExam==0){
                          return Container(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: Text("Average score ${t.calculateAvg()}", style: TextStyle(fontSize: 15),),
                            ),
                          );
                        }
                        else{
                          return ExamView(t: t.exams[indexExam-1], sessionShown: User.instance.isStudent);
                        }

                      },
                    ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.getName(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraScreen(examSession: t,))
                      );

                    },
                    icon: Icon(Icons.play_arrow), label: Text("Continue"),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}