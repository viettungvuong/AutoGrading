class User {
  String username = "";

  // Private constructor
  User._privateConstructor();

  static final User _instance = User._privateConstructor();

  static User get instance => _instance;
}
