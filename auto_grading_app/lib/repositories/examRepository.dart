import 'package:auto_grading_mobile/repositories/Repository.dart';
import 'package:auto_grading_mobile/logic/backendDatabase.dart';
import 'package:auto_grading_mobile/logic/examConverter.dart';
import 'package:auto_grading_mobile/structs/pair.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import '../models/User.dart';
import '../logic/localPreferences.dart';


class ExamRepository extends BaseRepository<Exam> {
  ExamRepository._() : super();

  final int _cachedTime = 20;
  // late DateTime _lastUpdated;

  late Database _database; // cache trong sqlite


  // Singleton
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
    if (initialized==false) {
      if (User.instance.isStudent == false || User.instance.isSignedIn() == false) {
        return;
      }


      try {
        dynamic json = await GetExamsFromDatabase(User.instance.email!);
        items.addAll(await examsFromJson(json));

        initialized = true;
      } catch (err) {
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
}
