import '../structs/pair.dart';

abstract class BaseRepository<T> {
  late List<T> items;
  bool initialized=false;

  BaseRepository() {
    items = [];
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
    return items;
  }

  void resetAll(){
    initialized=false;
    items.clear();
  }

  List<T> filter(String query);

  List<Pair> convertForDropdown();

  BaseRepository clone();
}
