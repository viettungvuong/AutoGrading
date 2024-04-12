import 'Student.dart';

class Class{
  late String _name;
  late String _classId;

  List<Student> students=[];

  Class(this._name,this._classId);


  void setName(String name){
    _name=name;
  }

  String getName(){
    return _name;
  }

  void setId(String classId){
    _classId=classId;
  }

  String getId(){
    return _classId;
  }
}