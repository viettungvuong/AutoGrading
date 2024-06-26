import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/logic/examConverter.dart';
import 'package:auto_grading_mobile/logic/notificationConverter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Exam.dart';
import '../models/Notification.dart';
import '../models/User.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'authController.dart';
import 'mapDb.dart';

const notifyUrl = "$backendUrl/exam/notify";


class NotificationController{
  static Future<void> getNotifications() async {
    final json = await _fetchNotificationExams(); // lay tu server

    if (json==null){
      return;
    }

    List<ExamNotification> notifications = await notificationsFromJson(json); // doi tu json qua exam
    ExamNotification.addNotifications(notifications); // them vao danh sach notification
  }

  static Future<Map<String, dynamic>?> _fetchNotificationExams() async{
    final url = "$notifyUrl/${User.instance.email}";

    try {
      final response = await http.get(Uri.parse(url), headers: AuthController.instance.getHeader());


      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: '$error. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<bool> setRead(ExamNotification notification) async {
    final url = "$notifyUrl/${MapDatabase.instance.ids[notification]}";

    try {
      final response = await http.put(Uri.parse(url), headers: AuthController.instance.getHeader());

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {

      Fluttertoast.showToast(
        msg: '$error. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}
