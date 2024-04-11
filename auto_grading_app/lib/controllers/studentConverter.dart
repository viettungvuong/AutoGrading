import '../models/Student.dart';

List<Student> studentsFromJson(Map<String, dynamic> json){
  Student studentFromJson(Map<String, dynamic> json) {
    return Student(json['name'], json['studentId'],
    );
  }

  List<dynamic> students = json["students"];
  List<Student> res = [];

  students.forEach((student) async {
   res.add(studentFromJson(student));
  });

  return res;
}


Map<String, dynamic> studentToJson(Student student) {
  return {
    'studentId': student.getStudentId(),
    'name': student.getName()
  };
}
