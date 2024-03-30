class User {
  String? username=null;

  // Private constructor
  User._privateConstructor();

  static final User _instance = User._privateConstructor();

  static User get instance => _instance;

  bool isSignedIn(){
    return !(username==null);
  }
}
