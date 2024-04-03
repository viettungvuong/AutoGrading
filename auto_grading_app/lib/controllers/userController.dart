import 'dart:convert';

import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/controllers/studentRepository.dart';

import '../models/User.dart';
import 'package:http/http.dart' as http;
const String serverUrl="https://autogradingbackend.onrender.com/login";

Future<bool> login(String username, String password, bool login) async {
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'inputPassword': password,
      }),
    );

    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      User.instance.email=jsonResponse["username"]; // set user
      return true;
    }
    else{
      return false;
    }
  } catch (e) {
    print('Error connecting to server: $e');
    return false;
  }
}

Future<bool> signup(String username, String password, bool login) async {
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'inputPassword': password,
      }),
    );

    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      User.instance.email=jsonResponse["username"]; // set user
      return true;
    }
    else{
      return false;
    }
  } catch (e) {
    print('Error connecting to server: $e');
    return false;
  }
}

void logout(){
  User.instance.email="";

  // xoa nhung thu lien quan toi repo
  ExamSessionRepository.instance.resetAll();
  StudentRepository.instance.resetAll();
}