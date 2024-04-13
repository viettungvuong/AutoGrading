import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/studentConverter.dart';
import 'package:auto_grading_mobile/models/Student.dart';
import 'package:collection/collection.dart';

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
  List<Student> filter(String query) {
    return items.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  List<Pair> convertForDropdown(){
    List<Pair> res=[];
    items.forEach((element) {
      String name = element.getName();
      String id = element.getStudentId();
      res.add(Pair(name,id));
    });

    return res;

  }

  Student? findById(String studentId) {
    return items.firstWhereOrNull((element) => element.getStudentId() == studentId);

  }

}
