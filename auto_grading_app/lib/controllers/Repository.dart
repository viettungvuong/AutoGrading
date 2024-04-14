import '../structs/pair.dart';

abstract class BaseRepository<T> {
  late List<T> items;
  bool initialized=false;

  BaseRepository() {
    items = [];
  }

  Future<void> initialize();

  dynamic add(T item);

  void addAll(List<T> items){
    this.items.addAll(items);
  }

  List<T> getAll(){
    return items;
  }

  void resetAll(){
    items.clear();
  }

  List<T> filter(String query);

  List<Pair> convertForDropdown();
}
