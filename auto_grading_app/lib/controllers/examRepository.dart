// cai nay chi danh cho Student user
import 'package:auto_grading_mobile/controllers/Repository.dart';
import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/structs/pair.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/User.dart';

class ExamRepository extends BaseRepository<Exam>{
  ExamRepository._() : super();

  int _cachedTime = 30;
  late DateTime _lastUpdated;

  // singleton
  static final ExamRepository _instance = ExamRepository._();

  ExamRepository.copy(ExamRepository other): super.copy(other);

  @override
  ExamRepository clone() {
    return ExamRepository.copy(this);
  }


  static ExamRepository get instance => _instance;
  @override
  add(Exam item) {
    items.add(item);
  }

  @override
  List<Pair> convertForDropdown() {
    throw UnimplementedError();
  }

  @override
  List<Exam> filter(String query) {
    throw UnimplementedError();
  }

  bool needToRefresh(){
    if (initialized==false){ // chua initialize lan nao
      return true;
    }

    return (DateTime.now().difference(_lastUpdated).inMinutes>=_cachedTime); // quá thời gian

  }

  @override
  Future<void> initialize() async {
    if (needToRefresh()==false){
      return;
    }
    if (User.instance.isStudent==false||User.instance.isSignedIn()==false){
      return;
    }

    dynamic exams = await GetExamsFromDatabase(User.instance.email!);
    exams = exams["exams"];

    try{
      exams.forEach((exam) async {
        double score = exam["score"].toDouble();
        // load student tuong ung vao
        Student? student = await User.instance.toStudent();
        if (student!=null){
          Exam  current = Exam(student,score);
          current.setGradedPaperLink(exam["graded_paper_img"]);
          current.setSession(exam["session_name"]);
          items.add(current);
        }

      }
      );

      initialized=true;
      _lastUpdated=DateTime.now();
    }
    catch (err){
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

}