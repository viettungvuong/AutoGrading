import 'Exam.dart';

abstract class NotificationModel {
}

class ExamNotification implements NotificationModel{
  final Exam exam;
  final DateTime dateTime;

  bool _read = false;

  static int _count = 0; // tong so luong noti

  ExamNotification({required this.exam, required this.dateTime});

  static List<ExamNotification> _notifications=[];

  static void addNotifications(List<ExamNotification> notifications){ // them notification
    _notifications.addAll(notifications);
    _count = _notifications.length;
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
  }

  bool getRead(){
    return _read;
  }
}