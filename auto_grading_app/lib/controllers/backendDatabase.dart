import 'dart:convert';

import '../models/Exam.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

const String serverUrl="https://viettungvuong.pythonanywhere.com/grade";

Future<Map<String, dynamic>?> GetExamsFromDatabase() async {

  return json;
}

Future<Map<String, dynamic>?> GetStudentsFromDatabase() async {

  return json;
}

Future<Map<String, dynamic>?> UpdateExamToDatabase(Exam exam) async{
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? json;

  final request = http.MultipartRequest("POST", url); // update len database
  request.fields['studentId'] = exam.getStudent().getStudentId();
  request.fields['score']=exam.getScore().toString();

  try {
    final streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      final response = await http.Response.fromStream(streamedResponse);
      json = jsonDecode(response.body) as Map<String, dynamic>;
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return json;
}

Future<Map<String, dynamic>?> UpdateStudentToDatabase(Student student) async{
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? json;

  final request = http.MultipartRequest("POST", url); // update len database
  request.fields['studentId'] =student.getStudentId();
  request.fields['name']=student.getName();

  try {
    final streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      final response = await http.Response.fromStream(streamedResponse);
      json = jsonDecode(response.body) as Map<String, dynamic>;
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return json;
}