import 'package:flutter/material.dart';

import '../models/Exam.dart';
import '../models/Notification.dart';
import '../views/examView.dart';
import '../views/notificationView.dart';

class ExamNotificationsScreen extends StatefulWidget {
  @override
  _ExamNotificationsScreenState createState() => _ExamNotificationsScreenState();
}

class _ExamNotificationsScreenState extends State<ExamNotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ExamNotification.getNotificationsCount() > 0
          ? ListView.builder(
        itemCount: ExamNotification.getNotificationsCount(),
        itemBuilder: (context, index) {
          final notification = ExamNotification.getNotifications()[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                notification.setRead();
                ExamNotification.getNotifications().removeAt(index);
              });
              showPopup(context, notification.exam); // Show exam info
            },
            child: NotificationView(t: notification),
          );
        },
      )
          : Center(child: Text("No notifications")),
    );
  }
}
