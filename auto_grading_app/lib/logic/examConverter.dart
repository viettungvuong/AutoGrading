import 'package:auto_grading_mobile/repositories/studentRepository.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/User.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/examRepository.dart';

Future<Exam?> examFromJsonStudentMode(Map<String,dynamic> exam, Transaction? txn) async {
  double score = exam["score"].toDouble();
  Student? student = await User.instance.toStudent();
  if (student != null) {
    // khoi tao exam
    Exam current = Exam(student, score);
    current.setGradedPaperLink(exam["graded_paper_img"]);
    current.setSession(exam["session_name"]);

    if (txn != null) { // cache
      txn.insert(tableName, current.toMap()); // cache lai
    }
    return current;
  }

  return null;
}

Future<Exam?> examFromJsonTeacherMode(Map<String,dynamic> exam) async {
  double score = exam["score"].toDouble();
  String studentId = exam["student"]["studentId"];
  Student? student = StudentRepository.instance.findById(studentId);

  if (student != null) {
    Exam current = Exam(student, score);
    current.setGradedPaperLink(exam["graded_paper_img"]);

    // lien ket voi student trong map
    Student.linkExamToStudent(student, current);

    return current;
  }
  else{
    return null;
  }
}

Future<List<Exam>> examsFromJson(Map<String,dynamic> json, Transaction? txn) async {
  dynamic exams = json["exams"];
  List<Exam> res = [];
  for (var exam in exams) {
      Exam? current = await examFromJsonStudentMode(exam, txn);

      if (current == null) {
        continue;
      }

      res.add(current);
  }

  return res;
}