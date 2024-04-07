import 'dart:convert';

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/examSession.dart';
import 'package:http/http.dart' as http;

Future<List<ExamSession>> sessionsFromJson(Map<String, dynamic> json) async{
  Future<ExamSession?> sessionFromJson(Map<String, dynamic> json) async{
    const String serverUrl="https://autogradingbackend.onrender.com/exam/byId";
    List<String> examIds = json["exams"];
    List<Exam> exams = [];

    // get exam by id
    examIds.forEach((examId) async {
      final response = await http.get(Uri.parse("$serverUrl/$examId"));

      if (response.statusCode == 200) {
        dynamic json = jsonDecode(response.body) as Map<String, dynamic>;
        double score = json["score"];
        String studentName = json["student"]["name"];
        String studentId = json["student"]["studentId"];
        Student student = Student(studentName,studentId);
        Exam exam = Exam(student,score);
        exams.add(exam);
      } else {
        // Request failed
        print('Failed with status code: ${response.statusCode}');
      }
    });

    ExamSession session = ExamSession.examsOnly(exams);
    return session;
  }

  List<dynamic> jsonArray = json["sessions"];
  List<ExamSession> sessions = [];

  for (var element in jsonArray) {
    ExamSession? session = await sessionFromJson(element);
    if (session==null){
      continue;
    }
    sessions.add(session);
  }

  return sessions;
}

