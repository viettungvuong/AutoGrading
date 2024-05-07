import 'dart:convert';

import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/authController.dart';
import 'package:auto_grading_mobile/controllers/classRepository.dart';
import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/controllers/localPreferences.dart';

import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/Student.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;

import '../structs/pair.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Notification.dart';
import 'examRepository.dart';

const String serverUrl="$backendUrl/login";

const String prefKey="login";
const String userNameKey="username";
const String passwordKey="password";

Future<void> _entry() async{ // buoc vao app
  await ClassRepository.instance.initialize();
  if (User.instance.isStudent==false){
    await StudentRepository.instance.initialize();
    await ExamSessionRepository.instance.initialize();
  }
  else{
    await ExamRepository.instance.initialize();
  }


}

Future<Pair> Signin(String username, String password) async {
  var url = Uri.parse("$serverUrl/signin"); // Connect to the backend server
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

      print(jsonResponse["isStudent"]);

      // SocketController.instance.emitLogin(username);
      await _entry();

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

Future<Pair> Signup(String name, String username, String password, bool isStudent, String? studentId) async {
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
        'studentId': studentId
      }),
    );


    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      AuthController.instance.setToken(jsonResponse["token"]); //dat token xac thuc
      User.instance.email=username; // set user
      User.instance.isStudent=isStudent;

      // SocketController.instance.emitLogin(username);
      await _entry();

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


    if (response.statusCode == 200) {
      // thanh cong
      // Preferences.instance.saveString(passwordKey,newPassword); // doi password nay luon
      Preferences.instance[passwordKey]=newPassword;
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

void Logout() async{
  User.instance.email="";

  // xoa nhung thu lien quan toi repo
  ExamSessionRepository.instance.resetAll();
  StudentRepository.instance.resetAll();
  ClassRepository.instance.resetAll();

  Preferences.instance[prefKey]=false;
  Preferences.instance[userNameKey]="";
  Preferences.instance[passwordKey]="";

  if (User.instance.isStudent){
    await ExamRepository.instance.clearCache();
  }

  // xoa cache

}
