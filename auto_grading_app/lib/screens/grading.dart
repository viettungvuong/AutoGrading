import 'dart:io';

import 'package:auto_grading_mobile/controllers/backendService.dart';
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

  @override
  void initState() {
    super.initState();
    image=widget.image;
    availableChoices=widget.availableChoices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
          margin: EdgeInsets.all(50),
          child: Column(
              children: [
                Text("Test paper",style: TextStyle(fontSize: 20),),
                Image.file(File(widget.image.path)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () async {
                    ConnectToGrade(image, availableChoices);
                  },
                  child: const Text('Start grading'),
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