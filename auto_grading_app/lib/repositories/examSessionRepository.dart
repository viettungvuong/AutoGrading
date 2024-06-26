import 'package:auto_grading_mobile/logic/backendDatabase.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../logic/mapDb.dart';
import '../structs/pair.dart';

import 'Repository.dart';
import '../logic/examSessionConverter.dart';


class ExamSessionRepository extends BaseRepository<ExamSession> {
  // late String _lastId;

  // private constructor
  ExamSessionRepository._() : super();


  // singleton
  static final ExamSessionRepository _instance = ExamSessionRepository._();

  static ExamSessionRepository get instance => _instance;

  @override
  Future<void> initialize() async {
    if (initialized){
      return;
    }
    try {
      dynamic map = await GetExamSessionsFromDatabase();
      dynamic sessions = await sessionsFromJson(map);
      items = sessions.toSet();
      initialized = true;
    }catch (err){
      Fluttertoast.showToast(
        msg: err.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
      return false;
    } else {
      String id = res.a;
      MapDatabase.instance.ids[item]=id;
      items.add(item);
      // _lastId = id;
      return true;
    }
  }

  @override
  List<Pair> convertForDropdown(){ // session khong nam trong dropdown
    throw UnimplementedError();
  }


  @override
  Future<Pair?> updateToDatabase(ExamSession item) async {
    try{
      if (MapDatabase.instance.ids[item]==null){
        throw Exception("Not initialized on database yet");
      }
      Pair res = await updateExamSessionToDatabase(item, MapDatabase.instance.ids[item]!);
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
        MapDatabase.instance.ids[item]=res.a;
        // _lastId = res.a;
        items.remove(item);
        items.add(item);
      }


      return res;
    }
    catch (e){
      Fluttertoast.showToast(
        msg: e as String,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return null;
    }
  }


  List<ExamSession> filter(String query){
    return items.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }
  //
  // String getLastId(){
  //   return _lastId;
  // }
}
