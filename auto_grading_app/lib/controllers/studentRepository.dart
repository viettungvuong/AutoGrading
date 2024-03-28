import '../models/Student.dart';

class StudentRepository {
  late Set<Student> _students;

  // private constructor
  StudentRepository._() {
    _students = Set();
  }

  // singleton
  static final StudentRepository _instance = StudentRepository._();

  static StudentRepository get instance => _instance;

  void addStudent(Student student) {
    _students.add(student);
  }

  Set<Student> getAllStudents() {
    return _students;
  }

  Student? findStudent(String studentId) {
    for (var student in _students) {
      if (student.getStudentId() == studentId) {
        return Student.copy(student);
      }
    }
    return null;
  }
}
