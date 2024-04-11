import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/studentConverter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Student.dart';
import '../structs/pair.dart';

class StudentRepository {
  late List<Student> _students;

  // private constructor
  StudentRepository._() {
    _students = [];
  }

  // singleton
  static final StudentRepository _instance = StudentRepository._();

  static StudentRepository get instance => _instance;

  Future<void> initialize() async {
    dynamic map = await GetStudentsFromDatabase();
    print(map);
    _students = studentsFromJson(map);
  }


  Future<String?> addStudent(Student student) async {
    _students.add(student);
    Pair res = await updateStudentToDatabase(student); // update len database

    if (res.a){
      return res.b; // tra ra id tren mongodb
    }
    else{
      return null;
    }
  }

  List<Student> getAllStudents() {
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


  void resetAll(){
    _students = [];
  }

}
