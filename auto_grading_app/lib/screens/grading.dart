import 'dart:io';

import 'package:auto_grading_mobile/controllers/backendGrade.dart';
import 'package:auto_grading_mobile/screens/resultScreen.dart';
import 'package:auto_grading_mobile/screens/cameraScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../models/examSession.dart';

class GradingScreen extends StatefulWidget{
  final ExamSession session;
  final XFile image;
  final int availableChoices;

  // Constructor with named parameter
  GradingScreen({required this.session, required this.image, required this.availableChoices});

  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  late XFile image;
  late int availableChoices;

  int? correctAnswers;
  double? score;
  XFile? resultImage;

  @override
  void initState() {
    super.initState();
    image=widget.image;
    availableChoices=widget.availableChoices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.all(50),
          child: Column(
              children: [
                const Text("Test paper: ",style: TextStyle(fontSize: 20),),
                Image.file(File(resultImage==null?image.path:resultImage!.path)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () async {
                    var json = await ConnectToGrade(image, widget.session); // goi den backend

                    if (json==null||json["correctAnswers"]==null){
                      Fluttertoast.showToast(
                        msg: "Error when grading",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GradingScreen(session:  widget.session, image: widget.image, availableChoices: widget.availableChoices,),
                        )); // reload màn hình hiện tại
                        return;
                    }

                    int correctAnswers = json?["correct_answers"];
                    // XFile resImage = json?["result_img"];

                    setState(() {
                      this.correctAnswers=correctAnswers;
                      // this.resultImage=resImage;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultScreen(session: widget.session,)),
                    );
                  },
                  child: const Text('Grade now'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen(examSession: widget.session,)),
                    );
                  },
                  child: const Text('Retake'),
                ),

              ]
          )
      )
    );


  }

  @override
  void dispose() {
    super.dispose();
  }
}