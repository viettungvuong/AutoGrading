import 'dart:convert';

import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/examRepository.dart';
import 'package:auto_grading_mobile/models/Notification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/Exam.dart';
import '../models/User.dart';
import 'localPreferences.dart';


List<ExamNotification> notifications=[];

WebSocketChannel? _channel;

void initializeSocket(){
  if (User.instance.isStudent==false){
    return;
  }


  if (_channel == null) {
    print("Connecting socket");
    _channel = WebSocketChannel.connect(
      Uri.parse(socketUrl),
    );

    _channel!.stream.listen((message) {
      // Decode the received message
      Map<String, dynamic> data = jsonDecode(message);

      if (data['event'] == 'newExam') {
        final exam = data['exam'];
        print('New exam received from server: $exam');

        if (exam["student"]['user'] != User.instance.email) {
          return; // Skip if the exam doesn't belong to this user
        }
        ExamRepository.instance.triggerReinitialize(); // Reload exams
        notifications.add(exam.fromMap()); // Add exam to notifications
      }
    });
  }
}