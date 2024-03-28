import 'package:flutter/cupertino.dart';

class Student{
  late String _name;
  late String _studentId;

  Student(this._name, this._studentId);
  Student.nameOnly(this._name);
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
}