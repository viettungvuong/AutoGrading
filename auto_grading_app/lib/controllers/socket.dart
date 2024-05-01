import 'dart:async';
import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/examRepository.dart';
import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/User.dart';
import 'examConverter.dart';

class SocketController {
  final IO.Socket _socket = IO.io(databaseUrl);

  // Singleton
  static final SocketController _instance = SocketController._();

  static SocketController get instance => _instance;

  // stream nay de nhan nhung exam moi trong nen
  final _examController = StreamController<Exam>.broadcast();

  // getter cua stream de dung tren UI
  Stream<Exam> get examStream => _examController.stream;

  // Private constructor
  SocketController._() {
    if (User.instance.isStudent==false){
      return;
    }
    _socket.on('exam', (data) async {
      if (data["studentId"] == User.instance.email) {
        double score = data["exam"]["score"].toDouble();
        Student? student = await User.instance.toStudent();
        if (student==null){
          return;
        }
        Exam exam = Exam(student,score);
        _examController.add(exam);
        ExamRepository.instance.add(exam); // them vao repository

      }
    });
  }

  void emitLogin(String email) {
    _socket.emit('login', email);
  }

  void emitNewExam(Exam exam) {
    _socket.emit('exam', {'studentId': exam.getStudent().studentEmail, 'exam': examToJson(exam)});
  }

}
