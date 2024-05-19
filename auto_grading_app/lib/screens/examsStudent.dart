import 'package:auto_grading_mobile/repositories/examRepository.dart';
import 'package:auto_grading_mobile/logic/notificationController.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:auto_grading_mobile/screens/notificationScreen.dart';
import 'package:auto_grading_mobile/views/viewFactory.dart';
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
  int _notificationCount = ExamNotification.getNotificationsCount(); // For example, replace this with the actual number of notifications

  @override
  void initState() {
    super.initState();
    setState(() {
      _exams = Future.value(ExamRepository.instance.getAll());
    });
  }

  void _showNotificationsDialog(BuildContext context) {
    // hien notification
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
          child:ExamNotification.getNotificationsCount()>0?ListView.builder(
            itemCount: ExamNotification.getNotificationsCount(),
            itemBuilder: (context, index) {
              final notification = ExamNotification.getNotifications()[index];
              return GestureDetector(
                  onTap: (){
                    setState(() {
                      notification.setRead(); // danh dau la da doc
                      _notificationCount--;
                      // print(_notificationCount);
                    });
                    showPopup(context, notification.exam); // hien thong tin bai ktra
                  },
                  child: ObjectViewFactory.getView(notification)
              );
            },
          ):Center(child: Text("No notifications")),
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ExamNotificationsScreen()),
                // );
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
                    return examsList(exams, true);
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
