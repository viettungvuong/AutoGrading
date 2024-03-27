import 'dart:convert';

import '../models/Exam.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

const String serverUrl="https://viettungvuong.pythonanywhere.com/grade";

Future<Map<String, dynamic>?> GetExamsFromDatabase() async {
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      // Request failed
      print('Failed with status code: ${response.statusCode}');
    }
}

Future<Map<String, dynamic>?> GetStudentsFromDatabase() async {
  final response = await http.get(Uri.parse(serverUrl));

  if (response.statusCode == 200) {
    return responseBody;
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
        'studentId': exam.getStudent().getStudentId(),
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

Future<Map<String, dynamic>?> updateStudentToDatabase(Student student) async {
  var url = Uri.parse(serverUrl);
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'studentId': student.getStudentId(),
        'name': student.getName(),
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