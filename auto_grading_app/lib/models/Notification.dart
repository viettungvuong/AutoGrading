import 'Exam.dart';

abstract class NotificationModel {
}

class ExamNotification implements NotificationModel{
  final Exam exam;

  ExamNotification({required this.exam});
}