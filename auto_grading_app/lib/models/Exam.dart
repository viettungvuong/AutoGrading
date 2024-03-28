import 'Student.dart';

class Exam{
  late Student _student;
  late double _score;

  Exam(this._student,this._score);

  Exam.studentOnly(this._student);

  Student getStudent(){
    return _student;
  }

  void setScore(double score){
    _score=score;
  }

  double getScore(){
    return _score;
  }
}