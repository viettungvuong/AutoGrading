import 'dart:convert';

import 'package:auto_grading_mobile/repositories/examSessionRepository.dart';
import 'package:auto_grading_mobile/repositories/studentRepository.dart';
import 'package:auto_grading_mobile/widgets/dropDownList.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../models/Class.dart';
import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/examSession.dart';
import '../structs/pair.dart';
import '../widgets/dropDownRepository.dart';
import 'cameraScreen.dart';

class ResultScreen extends StatefulWidget {
  int correct=0; // so cau dung
  String imagePath;
  ExamSession session;
  ResultScreen({required this.correct, required this.imagePath, required this.session});
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late CameraController? cameraController;

  double score=0;
  late int correct;

  Student? _selectedStudent;

  String? selectedClassId;

  @override
  void initState() {
    this.correct=widget.correct;
    score = correct/widget.session.getNumOfQuestions()*10;
    print(score);

    try{
      cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
      cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e){
      print(e);
    }

    super.initState();
  }

  List<Student> _eligibleStudentsForGrading(){ // bo nhung hoc sinh ma da cham bai roi
    Map<Student,bool> studentsInSession={};
    for (var exam in widget.session.exams) {
      studentsInSession[exam.getStudent()]=true; // danh dau student nay da co trong session roi
    }

    List<Student> res = [];
    widget.session.getClass().students.forEach((student) {
      if (studentsInSession[student]==null
      ||studentsInSession[student]==false){
        res.add(student);
      }
    });

    return res;
  }

  Future<void> _addExamToSession() async {
    if (_selectedStudent==null){
      return;
    }

    Exam exam=Exam(_selectedStudent!,score);
    exam.setGradedPaperLink(widget.imagePath);

    exam.setSession(widget.session.getName()); // lien ket voi session
    Student.linkExamToStudent(_selectedStudent!, exam); // them vao map

    widget.session.exams.add(exam); // them bai ktra cua hoc sinh nay vao
    ExamSessionRepository.instance.updateToDatabase(widget.session);
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(

        child: Container(
          margin: EdgeInsets.all(30),
            child: Column(
              children: [
                Text(
                  "$correct correct sentences",
                  style: TextStyle(color: Colors.green, fontSize: 25),
                ),

                Text(
                  "Final score: $score",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),

                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.network(
                    widget.imagePath,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null)
                        return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),


                DropdownListStudent(list: _eligibleStudentsForGrading(), onChanged: (student){
                  print(student.getStudentId());
                  _selectedStudent=student;
                }
                ), // nhung student da join class nay va chua cham bai trong session

                ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          width: 200, // Set the width of the AlertDialog
                          height: 150, // Set the height of the AlertDialog
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _addExamToSession();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CameraScreen(examSession: widget.session,)),
                                  ); // chup cai khac
                                },
                                child: const Text("Take more"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _addExamToSession();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainScreen()),
                                  ); // chup cai khac
                                },
                                child: const Text("Finish"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Add to the current test session'), // bam nay xong se co nut take more nua de chup tiep
                ),
              ],
            )
        ),
      )



    );
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }
}
