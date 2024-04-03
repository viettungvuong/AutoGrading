import 'dart:convert';

import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/User.dart';
import 'package:http/http.dart' as http;

import '../structs/pair.dart';
const String serverUrl="https://autogradingbackend.onrender.com/login";

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
        'username': username,
        'password': password,
      }),
    );

    jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      // thanh cong
      User.instance.email=jsonResponse["username"]; // set user
      return Pair(true,"");
    }
    else{
      // xuat loi ra o day
      return Pair(false,jsonResponse["error"]);
    }
  } catch (e) {
    print('Error connecting to server: $e');
    return Pair(false,e);
  }
}

Future<Pair> Signup(String username, String password) async {
  var url = Uri.parse(serverUrl+"/signup"); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
      }),
    );

    jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      // thanh cong
      User.instance.email=jsonResponse["username"]; // set user
      return Pair(true,"");
    }
    else{
      // xuat loi ra o day
      return Pair(false,jsonResponse["error"]);
    }
  } catch (e) {
    print('Error connecting to server: $e');
    return Pair(false,e);
  }
}

void Logout(){
  User.instance.email="";

  // xoa nhung thu lien quan toi repo
  ExamSessionRepository.instance.resetAll();
  StudentRepository.instance.resetAll();
}