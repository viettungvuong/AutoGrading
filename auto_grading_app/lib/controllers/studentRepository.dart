import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/studentConverter.dart';
import 'package:auto_grading_mobile/models/Student.dart';


import '../structs/pair.dart';

import 'Repository.dart';

class StudentRepository extends BaseRepository<Student> {
  // private constructor
  StudentRepository._() : super();

  // singleton
  static final StudentRepository _instance = StudentRepository._();

  static StudentRepository get instance => _instance;

  @override
  Future<void> initialize() async {
    dynamic map = await GetStudentsFromDatabase();
    print(map);
    items = studentsFromJson(map);
  }

  @override
  dynamic add(Student item) async {
    items.add(item);
    Pair res = await updateStudentToDatabase(item);

    if (res.a) {
      return res.b;
    } else {
      return null;
    }
  }



  Student? find(String id) {
    for (var item in items) {
      if (item.getStudentId() == id) {
        return Student.copy(item);
      }
    }
    return null;
  }

  @override
  Future<Pair> updateToDatabase(Student item) async {
    // Implement update logic specific to StudentRepository
    return Pair(false, "Not implemented");
  }

  @override
  List<Student> filter(String query) {
    return items.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }

}
