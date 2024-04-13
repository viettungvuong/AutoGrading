import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../structs/pair.dart';

import 'Repository.dart';
import 'examSessionConverter.dart';


class ExamSessionRepository extends BaseRepository<ExamSession> {
  late String _lastId;

  // private constructor
  ExamSessionRepository._() : super();

  // singleton
  static final ExamSessionRepository _instance = ExamSessionRepository._();

  static ExamSessionRepository get instance => _instance;

  @override
  Future<void> initialize() async {
    dynamic map = await GetExamSessionsFromDatabase();
    items = await sessionsFromJson(map);

    print(items);
  }

  @override
  dynamic add(ExamSession item) async {
    Pair res = await createExamSessionToDatabase(item);
    if (res.a == null) {
      Fluttertoast.showToast(
        msg: res.b,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      String id = res.a;
      items.add(item);
      _lastId = id;
    }
  }

  @override
  List<Pair> convertForDropdown(){ // session khong nam trong dropdown
    throw UnimplementedError();
  }


  @override
  Future<Pair> updateToDatabase(ExamSession item) async {
    items.remove(item);
    items.add(item);

    Pair res = await updateExamSessionToDatabase(item, _lastId);
    if (res.a == null) {
      Fluttertoast.showToast(
        msg: res.b,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      _lastId = res.a;
    }

    return res;
  }

  void updateLatestSession(ExamSession session) async {
    items.removeLast();
    items.add(session);

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

  List<ExamSession> filter(String query){
    return items.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }
}
