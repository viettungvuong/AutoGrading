import 'package:flutter/material.dart';

import '../models/Notification.dart';
import '../views/examView.dart';
import '../views/notificationView.dart';

class ExamNotificationsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: ExamNotification.getNotificationsCount(),
        itemBuilder: (context, index) {
          final notification = ExamNotification.getNotifications()[index];
          return GestureDetector(
            onTap: () => showPopup(context, notification.exam), // hien thong tin bai ktra
            child: NotificationView(t: notification,)
          );
        },
      ),
    );
  }
}
