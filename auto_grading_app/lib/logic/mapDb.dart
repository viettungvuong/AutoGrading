class MapDatabase {
  static final MapDatabase _instance = MapDatabase._();

  static MapDatabase get instance => _instance;

  MapDatabase._();

  factory MapDatabase() {
    return _instance;
  }

  Map<dynamic, String> ids = {};
}