import 'dart:convert';

import 'package:auto_grading_mobile/controllers/authController.dart';
import 'package:auto_grading_mobile/controllers/classRepository.dart';
import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/controllers/localPreferences.dart';
import 'package:auto_grading_mobile/controllers/socket.dart';
import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/Student.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;

import '../structs/pair.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String serverUrl="https://autogradingbackend.onrender.com/login";

const String prefKey="login";
const String userNameKey="username";
const String passwordKey="password";

Future<Pair> Signin(String username, String password) async {
  var url = Uri.parse(serverUrl+"/signin"); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': username,
        'password': password,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      AuthController.instance.setToken(jsonResponse["token"]); //dat token xac thuc
      User.instance.email=username; // set user
      User.instance.isStudent=jsonResponse["isStudent"];

      // SocketController.instance.emitLogin(username);

      return Pair(true,"");
    }
    else{
      // xuat loi ra o day
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(false,jsonResponse["error"]);
    }
  } catch (e) {
    print('Error connecting to server: $e');
    return Pair(false,e);
  }
}

Future<Pair> Signup(String name, String username, String password, bool isStudent) async {
  var url = Uri.parse(serverUrl+"/signup"); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': username,
        'password': password,
        'isStudent': isStudent,
      }),
    );


    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      AuthController.instance.setToken(jsonResponse["token"]); //dat token xac thuc
      User.instance.email=username; // set user
      User.instance.isStudent=isStudent;

      // SocketController.instance.emitLogin(username);

      return Pair(true,"");
    }
    else{
      // xuat loi ra o day
      jsonResponse =jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(false,jsonResponse["error"]);
    }
  } catch (e) {
    print('Error: $e');
    return Pair(false,e);
  }
}

Future<Pair> ChangePassword(String username, String confirmPassword, String newPassword) async {
  var url = Uri.parse(serverUrl+"/change"); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': username,
        'confirmPassword': confirmPassword,
        'newPassword': newPassword
      }),
    );


    print(response.statusCode);

    if (response.statusCode == 200) {
      // thanh cong
      Preferences.instance.saveString(passwordKey,newPassword); // doi password nay luon
      return Pair(true,"");
    }
    else{
      // xuat loi ra o day
      jsonResponse = await jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(false,jsonResponse["error"]);
    }
  } catch (e) {
    print('Error: $e');
    return Pair(false,e);
  }
}

void Logout(){
  User.instance.email="";

  // xoa nhung thu lien quan toi repo
  ExamSessionRepository.instance.resetAll();
  StudentRepository.instance.resetAll();
  ClassRepository.instance.resetAll();

  Preferences.instance.saveBoolean(prefKey, false);
  Preferences.instance.saveString(passwordKey, "");
  Preferences.instance.saveString(userNameKey, "");
}
