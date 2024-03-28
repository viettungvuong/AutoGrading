import '../models/Exam.dart';



Exam examFromJson(Map<String, dynamic> json) {
  return Exam(
    studentId: json['studentId'],
    score: json['score'],
  );
}

Map<String, dynamic> examToJson(Exam exam) {
    return {
      'studentId': exam.getStudent().getStudentId(),
      'score': exam.getScore(),
    };
}
