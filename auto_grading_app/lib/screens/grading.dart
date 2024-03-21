import 'dart:io';

import 'package:auto_grading_mobile/controllers/backendGrade.dart';
import 'package:auto_grading_mobile/screens/resultScreen.dart';
import 'package:auto_grading_mobile/widgets/cameraScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GradingScreen extends StatefulWidget{
  // Define variables that you want to pass to the constructor
  final XFile image;
  final int availableChoices;

  // Constructor with named parameter
  GradingScreen({required this.image, required this.availableChoices});

  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  late XFile image;
  late int availableChoices;

  int? correctAnswers;
  int? score;
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
                    var json = await ConnectToGrade(image, availableChoices); // goi den backend

                    int correctAnswers = json?["correct_answers"];
                    int score=json?["score"];
                    // XFile resImage = json?["result_img"];

                    setState(() {
                      this.correctAnswers=correctAnswers;
                      // this.resultImage=resImage;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultScreen()),
                    );
                  },
                  child: const Text('Grade now'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  },
                  child: const Text('Retake'),
                ),

                Text("Correct answers: $correctAnswers", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
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