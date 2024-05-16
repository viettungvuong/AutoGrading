import 'package:auto_grading_mobile/logic/Repository.dart';
import 'package:auto_grading_mobile/structs/pair.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Class.dart';
import 'backendDatabase.dart';
import 'classConverter.dart';

class ClassRepository extends BaseRepository<Class>{
  // private constructor
  ClassRepository._() : super();

  ClassRepository.copy(ClassRepository other): super.copy(other);

  @override
  ClassRepository clone() {
    return ClassRepository.copy(this);
  }


  // singleton
  static final ClassRepository _instance = ClassRepository._();

  static ClassRepository get instance => _instance;

  @override
  add(Class item) async {
    Pair res= await updateClassToDatabase(item);

    if (res.a==false) {
      Fluttertoast.showToast(
        msg: res.b,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else{
      item.setCode(res.b.a); // dat invitation code
      item.dbId=res.b.b;

      super.items.add(item);
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
    dynamic classes = await classesFromJson(map);
    items = classes.toSet();
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

  Class? findByDbId(String dbId) {
    return items.firstWhereOrNull((element) => element.dbId == dbId);
  }


}