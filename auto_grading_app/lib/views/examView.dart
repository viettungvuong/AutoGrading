
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Exam.dart';
import '../models/User.dart';
import 'View.dart';

Widget examsList(List<Exam> exams, bool sessionShown){
  return ListView.builder(
    itemCount: exams.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ExamView(t: exams[index], sessionShown: sessionShown),
          ),
        ),
      );
    },
  );
}

void showPopup(BuildContext context, Exam t) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog( // You can use any type of Dialog widget here
        title: Text("Exam Details"),
        content: Column(
          children: [
            User.instance.isStudent==false ? Text("Student: ${t.getStudent().getName()}\nScore: ${t.getScore()}") : Text("Session: ${t.getSession()}\nScore: ${t.getScore()}"),

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

class ExamView extends ObjectView<Exam> { // hien bai ktra cua hoc sinh
  bool sessionShown;

  ExamView({required super.t, required this.sessionShown});


  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap the widget with GestureDetector
      onTap: () {
        showPopup(context,t); // Function to show the popup
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sessionShown==false ? "Student: ${t.getStudent().getName()}" : "Session: ${t.getSession()}",
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