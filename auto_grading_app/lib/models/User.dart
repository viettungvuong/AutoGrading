import 'dart:convert';

import 'package:auto_grading_mobile/controllers/studentConverter.dart';

import '../controllers/authController.dart';
import '../controllers/backendDatabase.dart';
import 'Student.dart';
import 'package:http/http.dart' as http;

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

  Future<Student?> toStudent() async{
    final response = await http.get(Uri.parse("$serverUrl/student/byEmail/${User.instance.email!}"),     headers: AuthController.instance.getHeader(),);

    if (response.statusCode == 200) {
      dynamic map = jsonDecode(response.body) as Map<String, dynamic>;

      return studentFromJson(map);
    } else {
      return null;
    }
  }
}
