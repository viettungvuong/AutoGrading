import 'dart:convert';

import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/examSession.dart';
import 'package:http/http.dart' as http;

import 'examSessionRepository.dart';
Future<ExamSession?> sessionFromJson(Map<String, dynamic> json) async{
  const String serverUrl="https://autogradingbackend.onrender.com/exam/byId";
  List<dynamic> examIds = json["exams"];
  List<Exam> exams = [];

  // get exam by id
  examIds.forEach((examId) async {
    final response = await http.get(Uri.parse("$serverUrl/$examId"));

    if (response.statusCode == 200) {
      dynamic jsonFor = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonFor);
      double score = jsonFor["score"].toDouble();
      String studentId = jsonFor["student"]["studentId"];
      // find student by id (studentid)
      Student? student = StudentRepository.instance.findById(studentId);
      print(student);
      if (student!=null){
        Exam exam = Exam(student,score);
        exams.add(exam);
      }

    } else {
      // Request failed
      print('Failed with status code: ${response.statusCode}');
    }
  });
  print(exams.length);
  ExamSession session = ExamSession.examsOnly(exams);
  session.setName(json["name"]);
  session.id = json["_id"];
  return session;
}
Future<List<ExamSession>> sessionsFromJson(Map<String, dynamic> json) async{
  List<dynamic> jsonArray = json["sessions"];
  List<ExamSession> sessions = [];

  for (var element in jsonArray) {
    ExamSession? session = await sessionFromJson(element);
    if (session==null){
      continue;
    }
    sessions.add(session);
  }
  // ExamSessionRepository.instance.addAll(sessions);

  return sessions;
}

