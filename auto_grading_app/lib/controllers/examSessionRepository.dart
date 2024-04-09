import 'package:auto_grading_mobile/controllers/examSessionConverter.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../structs/pair.dart';
import 'backendDatabase.dart';

class ExamSessionRepository {
  late List<ExamSession> _sessions;
  late String _lastId;

  // private constructor
  ExamSessionRepository._() {
    _sessions = [];
  }

  // singleton
  static final ExamSessionRepository _instance = ExamSessionRepository._();

  static ExamSessionRepository get instance => _instance;

  void addSession(ExamSession session) async {

    Pair res = await createExamSessionToDatabase(session); // update len database
    if (res.a==null){
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
    else{
      String id = res.a;
      _sessions.add(session);
      _lastId=id; // luu id cua session moi add (de update sau nay)
    }


  }

  List<ExamSession> getAllSessions() {
    return _sessions;
  }

  void updateLatestSession(ExamSession session) async {
    _sessions.removeLast();
    _sessions.add(session);

    Pair res = await updateExamSessionToDatabase(session,_lastId); // update len database
    if (res.a==null){
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
    else{
      _lastId=res.a;
    }
  }

  void resetAll(){
    _sessions.clear();
  }

  List<ExamSession> filter(String query){
    return _sessions.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }

  void addFromList(List<ExamSession> sessions) async{
    _sessions.addAll(sessions);
  }



}
