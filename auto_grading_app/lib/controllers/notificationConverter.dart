import 'dart:convert';

import 'package:auto_grading_mobile/controllers/examConverter.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../api_url.dart';
import '../models/Exam.dart';
import '../models/Notification.dart';
import 'authController.dart';

Future<List<ExamNotification>> notificationsFromJson(Map<String,dynamic> json) async {
  dynamic notifications = json["notifications"];
  List<ExamNotification> res = [];

  for (var notification in notifications) {

    // lay thong tin day cua exam
    const String serverUrl = "$backendUrl/exam/byId";
    final response = await http.get(
      Uri.parse("$serverUrl/${notification["exam"]}"),
      headers: AuthController.instance.getHeader(),
    );

    if (response.statusCode == 200) {
      dynamic jsonFor = jsonDecode(response.body) as Map<String, dynamic>;
      Exam? exam = await examFromJsonStudentMode(jsonFor, null);
      if (exam==null){
        continue;
      }
      DateTime dateTime = DateTime.parse(notification["dateTime"]);

      ExamNotification noti = ExamNotification(exam: exam, dateTime: dateTime);

      res.add(noti);
    } else {
      print('Failed with status code: ${response.statusCode}');
    }

  }

  return res;
}