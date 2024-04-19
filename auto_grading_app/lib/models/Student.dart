import 'package:flutter/cupertino.dart';

import 'Class.dart';
import 'Exam.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'User.dart';

class Student{
  late String _name;
  late String _studentId;
  late String studentEmail; // email tài khoản của student
  List<Class> classes = [];

  Student(this._name, this._studentId);

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

}