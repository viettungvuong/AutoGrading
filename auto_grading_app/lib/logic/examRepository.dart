import 'package:auto_grading_mobile/logic/Repository.dart';
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
import 'localPreferences.dart';

const String lastUpdateKey = "last_updated_exam";
const String tableName = 'exams';

class ExamRepository extends BaseRepository<Exam> {
  ExamRepository._() : super();

  final int _cachedTime = 20;
  // late DateTime _lastUpdated;

  late Database _database; // cache trong sqlite


  // Singleton
  static final ExamRepository _instance = ExamRepository._();

  ExamRepository.copy(ExamRepository other) : super.copy(other);

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

  Future<void> clearCache() async{
    await _database.transaction((txn) async {
      await txn.delete(tableName); // xoa cache cu
    });

    await Preferences.instance.initPreferences();
    if (Preferences.instance[lastUpdateKey]!=null){
      Preferences.instance[lastUpdateKey]=null;
    }
  }

  Future<bool> needToRefresh() async {
    // if (initialized==false){
    //   return true;
    // }
    await Preferences.instance.initPreferences();
    if (Preferences.instance[lastUpdateKey]==null){
      return true;
    }
    else{
      return DateTime.now().difference(Preferences.instance[lastUpdateKey]).inMinutes >= _cachedTime;
    }

  }

  Future<void> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'exam_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the table for caching exams
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            student TEXT,
            score REAL,
            graded_paper_img TEXT,
            session TEXT
          )
        ''');
      },
    );
  }

  void triggerReinitialize(){ // bat buoc refresh lai
    initialized=false;
    initialize();
  }

  @override
  Future<void> initialize() async {
    bool refresh = await needToRefresh();
    // se luon phai load khi moi mo app lai
    // refresh la de khi dang dung app co gi no se refresh

    items.clear();

    if (initialized==false||refresh) {
      if (User.instance.isStudent == false || User.instance.isSignedIn() == false) {
        return;
      }


      await _openDatabase();

      try {
        dynamic json = await GetExamsFromDatabase(User.instance.email!);

        await _database.transaction((txn) async {
          clearCache();

          items.addAll(await examsFromJson(json, txn));
        });
        initialized = true;
        Preferences.instance[lastUpdateKey]=DateTime.now();
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
    } else {
      //  load tu cache
      await _openDatabase();
      List<Map<String, dynamic>> maps = await _database.query(tableName);
      items.addAll(List.generate(maps.length, (i) {
        Exam current = Exam.fromMap(maps[i]);
        return current;
      }).where((current) {
        // loc nhung item thao dieu kien
        return current.getStudent().studentEmail == User.instance.email;
      }));
    }
  }
}
