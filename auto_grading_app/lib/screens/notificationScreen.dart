import 'package:flutter/material.dart';

import '../models/Notification.dart';
import '../views/examView.dart';

class ExamNotificationsScreen extends StatelessWidget {
  final List<ExamNotification> notifications;

  const ExamNotificationsScreen({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () => showPopup(context, notification.exam), // hien thong tin bai ktra
            child: ListTile(
              title: Text(notification.exam.getSession()),
            ),
          );
        },
      ),
    );
  }
}
