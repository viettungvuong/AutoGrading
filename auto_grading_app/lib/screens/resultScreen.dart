import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ResultScreen extends StatefulWidget {
  int score; // so diem
  int correct; // so cau dung
  ResultScreen({required this.score, required this.correct});
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late CameraController? controller;

  late int score;
  late int correct;

  TextEditingController _controller=TextEditingController();

  @override
  void initState() {
    super.initState();

    this.score=widget.score;
    this.correct=widget.correct;

    try{
      controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
      controller?.initialize().then((_) {
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
      body: Center(
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
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter the student name here",
              ),
            ),
          ],
        )


      ),


    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
