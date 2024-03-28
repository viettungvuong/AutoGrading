import '../models/Student.dart';

class StudentRepository {
  late List<Student> _students;

  // private constructor
  StudentRepository._() {
    _students = [];
  }

  // singleton
  static final StudentRepository _instance = StudentRepository._();

  static StudentRepository get instance => _instance;

  void addStudent(Student student) {
    _students.add(student);
  }

  List<Student> getAllStudents() {
    return _students;
  }

  Student? findStudent(String studentId) {
    for (int i = 0; i < _students.length; i++) {
      if (_students[i].getStudentId() == studentId) {
        return _students[i];
      }
    }
    return null;
  }
}
