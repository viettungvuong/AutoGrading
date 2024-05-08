import 'package:auto_grading_mobile/controllers/examRepository.dart';
import 'package:auto_grading_mobile/controllers/newExamNotification.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:auto_grading_mobile/screens/notificationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/Exam.dart';
import '../models/Notification.dart';
import '../views/examView.dart';
import '../views/notificationView.dart';

class ExamStudentScreen extends StatefulWidget {
  @override
  ExamStudentState createState() => ExamStudentState();
}

class ExamStudentState extends State<ExamStudentScreen> {
  Future<List<Exam>>? _exams;
  int _notificationCount = 3; // For example, replace this with the actual number of notifications

  @override
  void initState() {
    super.initState();
    setState(() {
      _exams = Future.value(ExamRepository.instance.getAll());
    });
  }

  void _showNotificationsDialog(BuildContext context) {
    // hien notification
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: ListView.builder(
            itemCount: ExamNotification.getNotifications().length,
            itemBuilder: (context, index) {
              return NotificationView(t: ExamNotification.getNotifications()[index],);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.notifications),
                  _notificationCount > 0
                      ? Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$_notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                ],
              ),
              onPressed: () {
                _showNotificationsDialog(context);
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<Exam>>(
                future: _exams,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No exams graded'),
                    );
                  } else {
                    final exams = snapshot.data!;
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
                              child: ExamView(t: exams[index]),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
