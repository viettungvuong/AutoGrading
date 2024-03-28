import '../models/Student.dart';

Student studentFromJson(Map<String, dynamic> json) {
  return Student(json['name'], json['studentId'],
  );
}

Map<String, dynamic> studentToJson(Student student) {
  return {
    'studentId': student.getStudentId(),
    'name': student.getName()
  };
}
