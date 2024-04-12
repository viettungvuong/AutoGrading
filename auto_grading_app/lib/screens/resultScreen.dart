import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/controllers/studentRepository.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/examSession.dart';
import '../structs/pair.dart';
import '../widgets/dropDown.dart';
import 'cameraScreen.dart';

class ResultScreen extends StatefulWidget {

  int correct=0; // so cau dung
  ExamSession session;
  ResultScreen({required this.correct, required this.session});
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late CameraController? cameraController;

  double score=0;
  late int correct;

  TextEditingController _nameController=TextEditingController();
  TextEditingController _idController=TextEditingController();

  @override
  void initState() {
    super.initState();

    this.correct=widget.correct;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter the student name here",
                  ),
                ),

                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: "Enter the student ID here",
                  ),
                ),

                SizedBox(
                  width: 500.0,
                  height: 500.0,
                  child: Dropdown(classes: [],),
                ),

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
                                  //tinh diem
                                  score = correct/widget.session.getNumOfQuestions()*10;
                                  print(score);
                                  Student student=Student(_nameController.text,_idController.text);
                                  String? id = await StudentRepository.instance.add(student); //them vao repository

                                  if (id==null){
                                    Fluttertoast.showToast(
                                      msg: "Error when adding student",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black45,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    return;
                                  }
                                  student.setUniqueId(id);
                                  Exam exam=Exam(student,score);

                                  widget.session.exams.add(exam); // them bai ktra cua hoc sinh nay vao
                                  ExamSessionRepository.instance.updateLatestSession(widget.session); // cap nhat trong repo

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CameraScreen(examSession: widget.session,)),
                                  ); // chup cai khac
                                },
                                child: const Text("Take more"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  score = correct/widget.session.getNumOfQuestions()*10;
                                  print(score);
                                  Student student=Student(_nameController.text,_idController.text);
                                  String? id = await StudentRepository.instance.add(student); //them vao repository

                                  if (id==null){
                                    Fluttertoast.showToast(
                                      msg: "Error when adding student",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black45,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    return;
                                  }
                                  student.setUniqueId(id);
                                  Exam exam=Exam(student,score);


                                  widget.session.exams.add(exam); // them bai ktra cua hoc sinh nay vao
                                  ExamSessionRepository.instance.updateLatestSession(widget.session); // cap nhat trong repo

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainScreen()),
                                  ); // ve trang chu
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
