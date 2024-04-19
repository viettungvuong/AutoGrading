import 'package:auto_grading_mobile/controllers/examConverter.dart';
import 'package:auto_grading_mobile/controllers/socket.dart';

import 'Student.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'User.dart';

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

  // void notifyStudent(){ // observer
  //   // thông báo điểm số học sinh qua socket
  //   SocketController.instance.emitNewExam(this);
  // }
}