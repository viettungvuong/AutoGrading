import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/Exam.dart';
import '../models/Student.dart';



Exam? examFromJson(Map<String, dynamic> json) {
  Student? student =StudentRepository.instance.find(json['studentId']);
  if (student==null){
    return null; // exam phai co student
  }
  return Exam(student, json['score'],
  );
}

Map<String, dynamic> examToJson(Exam exam) {
    return {
      'studentId': exam.getStudent().getStudentId(),
      'score': exam.getScore(),
      'graded_paper_link': exam.getGradedPaperLink()
    };
}
