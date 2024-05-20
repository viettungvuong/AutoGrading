import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences _prefs;
  bool _initialized = false;

  // Private constructor
  Preferences._();

  static final Preferences _instance = Preferences._();


  static Preferences get instance => _instance;

  Future<void> initPreferences() async {
    if (_initialized){
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    await _prefs.reload();
    _initialized=true;
  }

  void saveString(String key, String value) {
    _prefs.setString(key, value);
  }

  void saveListString(String key, List<String> values){
    _prefs.setStringList(key, values);
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
    if (_initialized==false){
      initPreferences();
    }
    while (_initialized==false){
    }
    if (_prefs.containsKey(key)==false){
      return null;
    }
    dynamic res = _prefs.get(key);

    return res;
  }

  void operator []=(String key, dynamic value) {
    if (_initialized==false){
      initPreferences();
    }
    while (_initialized==false){
    }
    try{
      if (value is bool){
        saveBoolean(key, value);
      }
      else if (value is String){
        saveString(key, value);
      }
      else if (value is DateTime){
        saveString(key, value.toIso8601String());
      }
      else if (value == null){
        _prefs.remove(key);
      }
      else{
        throw Exception("Not supported this type of variable in preferences");
      }

    }
    catch (e){
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

  }


}

