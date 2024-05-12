import 'dart:convert';

import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/examConverter.dart';
import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/examSession.dart';
import 'package:http/http.dart' as http;

import 'authController.dart';
import 'classRepository.dart';
import 'examSessionRepository.dart';
Future<ExamSession?> sessionFromJson(Map<String, dynamic> json) async {
  List<dynamic> examIds = json["exams"];
  List<Exam> exams = [];

  ExamSession session = ExamSession();
  session.setName(json["name"]);
  session.id = json["_id"];
  session.setAvailableChoices(json["available_choices"]);
  session.setNumOfQuestions(json["questions"]);
  session.setClass(ClassRepository.instance.findByDbId(json['schoolClass'])!);

  Map<int, int> intKeyAnswers = {
    for (var entry in json["answers"].entries) int.tryParse(entry.key) ?? 0: entry.value,
  };
  session.setAnswers(intKeyAnswers);

  const String serverUrl = "$backendUrl/exam/byId";

  // tao list future (nhung ham bat dong bo)
  List<Future<void>> futures = [];

  examIds.forEach((examId) {
    futures.add(() async {
      final response = await http.get(
        Uri.parse("$serverUrl/$examId"),
        headers: AuthController.instance.getHeader(),
      );

      if (response.statusCode == 200) {
        dynamic jsonFor = jsonDecode(response.body) as Map<String, dynamic>;
        Exam? exam = await examFromJsonTeacherMode(jsonFor);
        if (exam!=null){
          exam.setSession(session.getName());
          exams.add(exam);
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    }());
  });

  // doi xong moi future
  await Future.wait(futures);

  session.exams.addAll(exams.toSet());

  return session;
}

Future<List<ExamSession>> sessionsFromJson(Map<String, dynamic> json) async{
  // print("Sessions");
  List<dynamic> jsonArray = json["sessions"];
  // print(jsonArray);
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

