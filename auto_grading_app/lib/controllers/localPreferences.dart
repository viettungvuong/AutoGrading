import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences _prefs;

  // Private constructor
  Preferences._();

  static final Preferences _instance = Preferences._();

  static Preferences get instance => _instance;

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveString(String key, String value) {
    _prefs.setString(key, value);
  }

  void saveBoolean(String key, bool value){
    _prefs.setBool(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  bool getBool(String key){
    return _prefs.getBool(key)??false;
  }
}
