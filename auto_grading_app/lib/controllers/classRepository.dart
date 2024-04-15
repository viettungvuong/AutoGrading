import 'package:auto_grading_mobile/controllers/Repository.dart';
import 'package:auto_grading_mobile/structs/pair.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/Class.dart';
import 'backendDatabase.dart';
import 'classConverter.dart';

class ClassRepository extends BaseRepository<Class>{
  // private constructor
  ClassRepository._() : super();

  // singleton
  static final ClassRepository _instance = ClassRepository._();

  static ClassRepository get instance => _instance;

  @override
  add(Class item) async {
    super.items.add(item);

    Pair res = await updateClassToDatabase(item);

    if (res.a) {
      return res.b;
    } else {
      return null;
    }
  }

  @override
  List<Class> filter(String query) {
    return items.where((element) => element.getName().toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Future<void> initialize() async {
    if (initialized){
      return;
    }
    dynamic map = await GetClassesFromDatabase();
    items = await classesFromJson(map);
    initialized=true;
  }

  @override
  List<Pair> convertForDropdown(){
    List<Pair> res=[];
    items.forEach((element) {
      String name = element.getName();
      String id = element.getId();
      res.add(Pair(name,id));
    });

    return res;

  }

  Class? findById(String classId) {
    return items.firstWhereOrNull((element) => element.getId() == classId);

  }

}