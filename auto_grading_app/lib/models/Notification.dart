import 'Exam.dart';

abstract class NotificationModel {
}

class ExamNotification implements NotificationModel{
  final Exam exam;
  final DateTime dateTime;

  ExamNotification({required this.exam, required this.dateTime});

  static List<ExamNotification> _notifications=[];

  static void addNotifications(List<ExamNotification> notifications){ // them notification
    _notifications.addAll(notifications);
  }

  static List<ExamNotification> getNotifications(){
    return _notifications;
  }
}