
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Exam.dart';
import 'View.dart';

class ExamView extends ObjectView<Exam> { // hien bai ktra cua hoc sinh
  ExamView({required super.t});

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( // You can use any type of Dialog widget here
          title: Text("Exam Details"),
          content: Column(
            children: [
              Text("Student: ${t.getStudent().getName()}\nScore: ${t.getScore()}"),

              CachedNetworkImage(
                  imageUrl: t.getGradedPaperLink(), // URL of the image to load
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Placeholder widget while the image is loading
                  errorWidget: (context, url, error) => Icon(Icons.error), // Widget to display if there's an error loading the image
                ),

            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap the widget with GestureDetector
      onTap: () {
        _showPopup(context); // Function to show the popup
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.getStudent().getName(), // Use exam object to access student name
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              t.getScore().toString(), // Use exam object to access score
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}