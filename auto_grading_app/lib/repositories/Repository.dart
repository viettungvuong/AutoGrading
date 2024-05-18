import 'package:auto_grading_mobile/repositories/classRepository.dart';
import 'package:auto_grading_mobile/repositories/examRepository.dart';
import 'package:auto_grading_mobile/repositories/examSessionRepository.dart';
import 'package:auto_grading_mobile/repositories/studentRepository.dart';

import '../structs/pair.dart';

abstract class BaseRepository<T> {
  late Set<T> items;
  bool initialized=false;

  BaseRepository() {
    items = Set();
  }

  BaseRepository.copy(BaseRepository<T> other){
    this.items.addAll(other.items);

    this.initialized=other.initialized;
  }

  Future<void> initialize();

  dynamic add(T item);

  void addAll(List<T> items){
    this.items.addAll(items);
  }

  List<T> getAll(){
    return items.toList();
  }

  void resetAll(){
    initialized=false;
    items.clear();
  }

  List<T> filter(String query);

  List<Pair> convertForDropdown();

  BaseRepository clone();

  static void reset(){
    ClassRepository.instance.resetAll();
    ExamRepository.instance.resetAll();
    ExamSessionRepository.instance.resetAll();
    StudentRepository.instance.resetAll();
  }
}
