import 'package:auto_grading_mobile/controllers/examConverter.dart';
import 'package:flutter/cupertino.dart';

import '../models/Exam.dart';
import '../models/Notification.dart';

Future<List<ExamNotification>> notificationsFromJson(Map<String,dynamic> json) async {
  dynamic notifications = json["notifications"];
  List<ExamNotification> res = [];
  for (var notification in notifications) {
    Exam? exam = await examFromJson(notification["exam"], null);
    if (exam==null){
      continue;
    }
    DateTime dateTime = DateTime.parse(notification["dateTime"]);

    ExamNotification noti = ExamNotification(exam: exam, dateTime: dateTime);

    res.add(noti);
  }

  return res;
}