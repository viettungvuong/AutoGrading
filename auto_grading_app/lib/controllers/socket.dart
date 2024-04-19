import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/Exam.dart';
import 'examConverter.dart';

class SocketController{
  final IO.Socket _socket = IO.io('https://autogradingbackend.onrender.com');
  SocketController._() : super();

  // singleton
  static final SocketController _instance = SocketController._();

  static SocketController get instance => _instance;

  void emitLogin(String email){
    _socket.emit('login',email);
  }

  void emitNewExam(Exam exam){
    _socket.emit('score', { 'studentId': exam.getStudent().studentEmail, 'exam': examToJson(exam) });
  }
}



