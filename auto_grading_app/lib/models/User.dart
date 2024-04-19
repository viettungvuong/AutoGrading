class User {
  String? email;
  bool isStudent=false;

  // Private constructor
  User._privateConstructor();

  static final User _instance = User._privateConstructor();

  static User get instance => _instance;

  bool isSignedIn(){
    return !(email==null);
  }
}
