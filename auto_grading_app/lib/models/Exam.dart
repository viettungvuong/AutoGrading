import 'Student.dart';

class Exam{
  late final Student _student;
  late double _score;
  late String _gradedPaperLink;

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

  void setGradedPaperLink(String gradedPaperLink){
    _gradedPaperLink = gradedPaperLink;
  }

  String getGradedPaperLink(){
    return _gradedPaperLink;
  }
}