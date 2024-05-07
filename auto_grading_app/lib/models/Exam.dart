import 'package:auto_grading_mobile/controllers/examConverter.dart';

import 'Student.dart';

import 'User.dart';
import 'examSession.dart';

class Exam{
  late final Student _student;
  late double _score;
  late String _gradedPaperLink;
  late final String _sessionName;

  Exam(this._student,this._score);

  Exam.studentOnly(this._student);

  Exam.scoreOnly(this._score);

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

  // void notifyStudent(){ // observer
  //   // thông báo điểm số học sinh qua socket
  //   SocketController.instance.emitNewExam(this);
  // }
  void setSession(String sessionName){
    _sessionName=sessionName;
  }

  String getSession(){
    return _sessionName;
  }

  bool operator==(Object other) =>
      other is Exam && _student == other._student && _sessionName == other._sessionName && _score == other._score;

  int get hashCode => Object.hash(_student,_sessionName,_score);

  Map<String, dynamic> toMap() {
    return {
      'student': _student.toMap(),
      'score': _score,
      'graded_paper_img': _gradedPaperLink,
      'session': _sessionName
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    String gradedPaperImg = map["graded_paper_image"];
    String sessionName = map["session_name"];
    double score = map["score"];

    Student findStudent = Student.fromMap(map["student"]);

    Exam current = Exam(findStudent, score);
    current.setGradedPaperLink(gradedPaperImg);
    current.setSession(sessionName);

    return current;

  }
}