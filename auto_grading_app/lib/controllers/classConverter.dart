import 'dart:convert';

import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/studentConverter.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

import '../models/User.dart';
import 'authController.dart';

Future<Class?> classFromJson(Map<String, dynamic> json) async{
  String code = json["code"];
  String name = json["name"];
  String classId = json["classId"];

  if (User.instance.isStudent==false){
    String id = json["_id"]; // id de tim thong tin
    String serverUrl="$backendUrl/class/byId/$id"; // tìm student của class nay

    final response = await http.get(Uri.parse(serverUrl),      headers: AuthController.instance.getHeader(),);
    if (response.statusCode == 200) {
      dynamic jsonStudents = jsonDecode(response.body) as Map<String, dynamic>;
      List<Student> studentsFetched = studentsFromJson(jsonStudents); // lấy danh sách student từ json

      Class schoolClass = Class(name,classId); // tao class moi
      schoolClass.setCode(code);
      schoolClass.students.addAll(studentsFetched); // thêm các học sinh vào lớp học
      schoolClass.dbId=id;
      return schoolClass;
    } else {
      // Request failed
      print('Failed with status code: ${response.statusCode}');
      return null;
    }
  }
  else{
    Class schoolClass = Class(name,classId); // tao class moi
    schoolClass.setCode(code);
    return schoolClass;
  }


}
Future<List<Class>> classesFromJson(Map<String, dynamic> json) async{
  List<dynamic> jsonArray = json["classes"];
  List<Class> classes  = [];

  for (var element in jsonArray) {
    Class? schoolClass = await classFromJson(element);
    if (schoolClass==null){
      continue;
    }
    classes.add(schoolClass);
  }
  // ClassRepository.instance.addAll(sessions);

  return classes;
}

