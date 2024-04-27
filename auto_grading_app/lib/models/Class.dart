import 'Student.dart';

class Class{
  late String _name;
  late String _classId; // ma lop (khong phai ma tren db)
  late String _code; // ma de join
  late String? dbId;

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

  void setCode(String code){
    _code=code;
  }

  String getCode(){
    return _code;
  }
}