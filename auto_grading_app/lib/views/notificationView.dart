import 'package:auto_grading_mobile/models/Notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Student.dart';
import 'View.dart';

import 'package:flutter/cupertino.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'View.dart';

class NotificationView extends ObjectView<ExamNotification> {
  NotificationView({required super.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // You can customize the border color here
          width: 1.0, // You can adjust the border width here
        ),
        borderRadius: BorderRadius.circular(8.0), // You can adjust the border radius here
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.exam.getSession(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Text(
              t.dateTime.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
