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

  // singleton
  static final ExamRepository _instance = ExamRepository._();

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

  @override
  Future<void> initialize() async {
    if (initialized){
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
          items.add(current);
        }

      }
      );

      initialized=true;
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