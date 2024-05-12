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
      body: ExamNotification.getNotificationsCount()>0?ListView.builder(
        itemCount: ExamNotification.getNotificationsCount(),
        itemBuilder: (context, index) {
          final notification = ExamNotification.getNotifications()[index];
          return GestureDetector(
            onTap: (){
              notification.setRead(); // danh dau la da doc
              showPopup(context, notification.exam); // hien thong tin bai ktra
            },
            child: NotificationView(t: notification,)
          );
        },
      ):Center(child: Text("No notifications")),
    );
  }
}
