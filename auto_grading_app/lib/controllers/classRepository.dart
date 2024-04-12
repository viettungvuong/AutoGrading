import 'package:auto_grading_mobile/controllers/Repository.dart';
import 'package:auto_grading_mobile/structs/pair.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/Class.dart';

class ClassRepository extends BaseRepository<Class>{
  // private constructor
  ClassRepository._() : super();

  // singleton
  static final ClassRepository _instance = ClassRepository._();

  static ClassRepository get instance => _instance;

  @override
  add(Class item) {
    super.items.add(item);
  }

  @override
  List<Class> filter(String query) {
    return items.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Future<void> initialize() async {
    dynamic map = await GetClassesFromDatabase();
    items = await classesFromJson(map);

  }

  Class? findById(String classId) {
    return items.firstWhereOrNull((element) => element.getId() == classId);

  }

}