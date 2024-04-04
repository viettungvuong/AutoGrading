import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../structs/pair.dart';
import 'backendDatabase.dart';

class ExamSessionRepository {
  late List<ExamSession> _sessions;

  // private constructor
  ExamSessionRepository._() {
    _sessions = [];
  }

  // singleton
  static final ExamSessionRepository _instance = ExamSessionRepository._();

  static ExamSessionRepository get instance => _instance;

  void addSession(ExamSession session) async {
    _sessions.add(session);

    Pair res = await updateExamSessionToDatabase(session); // update len database
    if (!res.a){
      Fluttertoast.showToast(
        msg: res.b,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  List<ExamSession> getAllSessions() {
    return _sessions;
  }

  void updateLatestSession(ExamSession session) async {
    _sessions.last=session;

    Pair res = await updateExamSessionToDatabase(_sessions.last); // update len database
    if (!res.a){
      Fluttertoast.showToast(
        msg: res.b,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void resetAll(){
    _sessions = [];
  }

}
