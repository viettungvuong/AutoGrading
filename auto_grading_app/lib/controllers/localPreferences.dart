import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  dynamic operator [](String key) {
    return _prefs.get(key);
  }

  void operator []=(String key, dynamic value) {
    try{
      if (value is bool){
        saveBoolean(key, value);
      }
      else if (value is String){
        saveString(key, value);
      }
      else{
        throw Exception("Not supported this type of variable in preferences");
      }

    }
    catch (e){
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be visible (either Toast.LENGTH_SHORT or Toast.LENGTH_LONG)
        gravity: ToastGravity.BOTTOM, // The position where the toast should appear on the screen
        timeInSecForIosWeb: 1, // Time for which the toast should be visible on iOS and web
        backgroundColor: Colors.red, // Background color of the toast message
        textColor: Colors.white, // Text color of the toast message
        fontSize: 16.0, // Font size of the toast message
      );
    }

  }


}

