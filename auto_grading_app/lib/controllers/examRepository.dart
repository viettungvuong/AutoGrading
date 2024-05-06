import 'package:auto_grading_mobile/controllers/Repository.dart';
import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
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

class ExamRepository extends BaseRepository<Exam> {
  ExamRepository._() : super();

  final int _cachedTime = 20;
  // late DateTime _lastUpdated;

  late Database _database; // cache trong sqlite
  static const String tableName = 'exams';

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

  Future<bool> needToRefresh() async {
    if (initialized == false) {
      return true; // Not initialized yet, need to refresh
    }
    await Preferences.instance.initPreferences();
    if (Preferences.instance[lastUpdateKey]==null){
      return true;
    }
    return DateTime.now().difference(Preferences.instance[lastUpdateKey]).inMinutes >= _cachedTime;
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
            student_id INTEGER,
            score REAL,
            graded_paper_img TEXT,
            session_name TEXT
          )
        ''');
      },
    );
  }


  @override
  Future<void> initialize() async {
    bool refresh = await needToRefresh();
    if (refresh) {
      if (User.instance.isStudent == false || User.instance.isSignedIn() == false) {
        return;
      }

      await _openDatabase();

      try {
        dynamic exams = await GetExamsFromDatabase(User.instance.email!);
        exams = exams["exams"];

        await _database.transaction((txn) async {
          await txn.delete(tableName); // xoa cache cu

          for (var exam in exams) {
            double score = exam["score"].toDouble();
            Student? student = await User.instance.toStudent();
            if (student != null) {
              // khoi tao exam
              Exam current = Exam(student, score);
              current.setGradedPaperLink(exam["graded_paper_img"]);
              current.setSession(exam["session_name"]);
              await txn.insert(tableName, current.toMap()); // cache lai
            }
          }
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
      // Load exams from local database
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
