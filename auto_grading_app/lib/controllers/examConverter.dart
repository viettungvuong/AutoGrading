import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/User.dart';
import 'package:sqflite/sqflite.dart';

import 'examRepository.dart';

Future<List<Exam>> examsFromJson(Map<String,dynamic> json, Transaction? txn) async {
  dynamic exams = json["exams"];
  List<Exam> res = [];
  for (var exam in exams) {
    double score = exam["score"].toDouble();
    Student? student = await User.instance.toStudent();
    if (student != null) {
      // khoi tao exam
      Exam current = Exam(student, score);
      current.setGradedPaperLink(exam["graded_paper_img"]);
      current.setSession(exam["session_name"]);

      if (txn!=null){ // cache
        await txn.insert(tableName, current.toMap()); // cache lai
      }

      res.add(current);
    }
  }

  return res;
}