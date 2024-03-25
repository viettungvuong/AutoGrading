import 'package:flutter/cupertino.dart';

class Student{
  late String _name;
  late String _studentId;

  Student(this._name, this._studentId);
  Student.nameOnly(this._name);

  String getName(){
    return _name;
  }
}