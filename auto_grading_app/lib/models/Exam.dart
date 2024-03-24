import 'Student.dart';

class Exam{
  late Student _student;

  late int _score;

  Exam(this._student,this._score);

  Exam.studentOnly(this._student);

  Student getStudent(){
    return _student;
  }

  void setScore(int score){
    _score=score;
  }

  int getScore(){
    return _score;
  }
}