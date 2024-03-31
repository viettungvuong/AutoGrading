import 'dart:convert';

import 'package:auto_grading_mobile/models/examSession.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

import '../models/User.dart';

const String serverUrl="https://viettungvuong.pythonanywhere.com/grade";

Future<Map<String, dynamic>?> GetExamsFromDatabase() async {
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Request failed
      print('Failed with status code: ${response.statusCode}');
    }
}

Future<Map<String, dynamic>?> GetStudentsFromDatabase() async {
  final response = await http.get(Uri.parse(serverUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>?> GetExamSessionsFromDatabase() async {
  final response = await http.get(Uri.parse(serverUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>?> updateExamToDatabase(Exam exam) async {
  var url = Uri.parse(serverUrl);
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'studentId': exam.getStudent().getStudentId(), // de map student id tim student trong backend
        'score': exam.getScore().toString(),
      }),
    );

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return jsonResponse;
}

Future<Map<String, dynamic>?> updateExamSessionsToDatabase(ExamSession session) async {
  var url = Uri.parse(serverUrl);
  Map<String, dynamic>? jsonResponse;

  List<Map<String,dynamic>> exams=[];
  int n=session.exams.length;
  for (int i=0; i<n; i++){
    String studentId = session.exams[i].getStudent().getStudentId();
    dynamic score = session.exams[i].getScore();
    exams.add({
      'studentId': studentId,
      'score': score,
    });
  } // luu cac bai thi cua session vao trong json

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'exams': exams,
        'userId': User.instance.username
      }),
    );

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return jsonResponse;
}