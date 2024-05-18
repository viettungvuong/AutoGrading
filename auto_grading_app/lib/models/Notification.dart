import 'package:auto_grading_mobile/logic/notificationController.dart';

import 'Exam.dart';

abstract class NotificationModel {
}

class ExamNotification implements NotificationModel{
  final String dbId;

  final Exam exam;
  final DateTime dateTime;

  bool _read = false;

  static int _count = 0; // tong so luong noti

  ExamNotification({required this.dbId, required this.exam, required this.dateTime});

  static List<ExamNotification> _notifications=[];

  static void addNotifications(List<ExamNotification> notifications){ // them notification
    _notifications.addAll(notifications);
    _count = _notifications.length;
  }

  static void removeNotification(ExamNotification notification){
    _notifications.remove(notification);
  }

  static List<ExamNotification> getNotifications(){
    return _notifications;
  }

  static int getNotificationsCount(){
    // return _notifications.length;
    return _count;
  }

  static void clear(){
    _notifications.clear();
  }

  void setRead(){
    _read = true;
    _count--; // giam so luong noti chua doc

    ExamNotification.removeNotification(this); // xoá khỏi danh sách notification
    NotificationController.setRead(this);
  }

  bool getRead(){
    return _read;
  }
}