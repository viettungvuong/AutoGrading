import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/Exam.dart';
import '../models/Student.dart';


Map<String, dynamic> examToJson(Exam exam) {
    return {
      'studentId': exam.getStudent().getStudentId(),
      'score': exam.getScore(),
      'graded_paper_link': exam.getGradedPaperLink(),
    };
}
