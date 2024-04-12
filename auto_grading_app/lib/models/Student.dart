import 'package:flutter/cupertino.dart';

class Student{
  late String _name;
  late String _studentId;
  late String _uniqueId;

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

}