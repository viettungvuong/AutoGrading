import 'dart:convert';

import 'package:auto_grading_mobile/logic/studentConverter.dart';

import '../logic/authController.dart';
import '../logic/backendDatabase.dart';
import 'Student.dart';
import 'package:http/http.dart' as http;

class User {
  String? email;
  bool isStudent=false;
  Student? _student;

  // Private constructor
  User._privateConstructor();

  static final User _instance = User._privateConstructor();

  static User get instance => _instance;

  bool isSignedIn(){
    return !(email==null);
  }

  Future<Student?> toStudent() async{
    if (_student!=null){
      return _student;
    }

    final response = await http.get(Uri.parse("$serverUrl/student/byEmail/${User.instance.email!}"),     headers: AuthController.instance.getHeader(),);

    if (response.statusCode == 200) {
      dynamic map = jsonDecode(response.body) as Map<String, dynamic>;

      _student = studentFromJson(map);
      _student?.studentEmail=email!;
      return _student;
    } else {
      return null;
    }
  }

  void resetStudent(){
    _student=null;
  }
}


