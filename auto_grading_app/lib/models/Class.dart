import 'Student.dart';

class Class{
  late String _name;

  List<Student> _students=[];

  Class(this._name);

  void addStudent(Student student){
    _students.add(student);
  }

  List<Student> getStudents(){
    return _students;
  }

  void setName(String name){
    _name=name;
  }

  String getName(){
    return _name;
  }
}