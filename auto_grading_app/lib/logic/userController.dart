import 'dart:convert';

import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/logic/authController.dart';
import 'package:auto_grading_mobile/repositories/classRepository.dart';
import 'package:auto_grading_mobile/repositories/examSessionRepository.dart';
import 'package:auto_grading_mobile/logic/localPreferences.dart';
import 'package:auto_grading_mobile/logic/notificationController.dart';

import 'package:auto_grading_mobile/repositories/studentRepository.dart';
import 'package:auto_grading_mobile/models/Notification.dart';
import 'package:flutter/cupertino.dart';

import '../models/Student.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;

import '../repositories/Repository.dart';
import '../structs/pair.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../repositories/examRepository.dart';

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
  else{ // neu la student thi phai lay them notification
    await ExamRepository.instance.initialize();
    await NotificationController.getNotifications();
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
        'email': username.toLowerCase(),
        'password': password,
      }),
    );



    if (response.statusCode == 200) {
      // thanh cong

      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      AuthController.instance.setToken(jsonResponse["token"]); //dat token xac thuc
      User.instance.email=username.toLowerCase(); // set user
      User.instance.isStudent=jsonResponse["isStudent"];


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
        'email': username.toLowerCase(),
        'password': password,
        'isStudent': isStudent,
        'studentId': studentId
      }),
    );


    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      AuthController.instance.setToken(jsonResponse["token"]); //dat token xac thuc
      User.instance.email=username.toLowerCase(); // set user
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
        'email': username.toLowerCase(),
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

void Logout(){
  User.instance.email="";

  // xoa nhung thu lien quan toi repo
  BaseRepository.reset();
  Preferences.instance[prefKey]=false;
  Preferences.instance[userNameKey]=null;
  Preferences.instance[passwordKey]=null;


  if (User.instance.isStudent){
    // await ExamRepository.instance.clearCache();
    ExamNotification.clear(); // xoa notification
    User.instance.resetStudent(); // xoá student liên kết vs user
  }

  User.instance.isStudent=false;

  // xoa cache

}
