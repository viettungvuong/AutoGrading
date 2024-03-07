import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GradingScreen extends StatefulWidget{
  // Define variables that you want to pass to the constructor
  final XFile image;

  // Constructor with named parameter
  GradingScreen({required this.image});

  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(50),
        child: Column(
            children: [
              Text("Test paper",style: TextStyle(fontSize: 20),),
              Image.file(File(widget.image.path)),
            ]
        )
    );

  }

  @override
  void dispose() {
    super.dispose();
  }
}