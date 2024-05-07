import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'Class.dart';
import 'Exam.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'User.dart';

class Student{
  late String _name;
  late String _studentId;
  String? studentEmail; // email tài khoản của student
  List<Class> classes = [];

  Student(this._name, this._studentId);

  Student.blank();

  Student.copy(Student other){
    this._name=other._name;
    this._studentId=other._studentId;
  }

  String getName(){
    return _name;
  }

  String getStudentId(){
    return _studentId;
  }

  void updateScore(Exam exam){ // observer here
    // thông báo điểm số ra
  }

  bool operator==(Object other) =>
      other is Student && _name == other._name && _studentId == other._studentId;

  int get hashCode => Object.hash(_name,_studentId);



  Map<String, dynamic> toMap() {
    print(jsonEncode({'email': studentEmail}));
    return {
      'name': _name,
      'studentId': _studentId,
      'user': jsonEncode({'email': studentEmail}),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    String name = map["name"];
    String studentId = map["studentId"];
    late String studentEmail;
    if (map["user"]["email"]!=null){
      studentEmail = map["user"]["email"];
    }
    else{
      Map<String, dynamic> userMap = jsonDecode(map["user"]);
      studentEmail = userMap["email"];
    }


    Student student = Student(name,studentId);
    student.studentEmail=studentEmail;

    return student;

  }
}