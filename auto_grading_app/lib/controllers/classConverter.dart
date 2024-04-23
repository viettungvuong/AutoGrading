import 'dart:convert';

import 'package:auto_grading_mobile/controllers/studentConverter.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

import 'authController.dart';

Future<Class?> classFromJson(Map<String, dynamic> json) async{
  print(json);
  String classId = json["_id"];
  String code = json["code"];
  print("Class id $classId");
  String serverUrl="https://autogradingbackend.onrender.com/class/byId/$classId"; // tìm student của class nay
  print(serverUrl);

  final response = await http.get(Uri.parse(serverUrl),      headers: AuthController.instance.getHeader(),);
  if (response.statusCode == 200) {
    dynamic jsonStudents = jsonDecode(response.body) as Map<String, dynamic>;
    print("jsonstudents $jsonStudents");
    List<Student> studentsFetched = studentsFromJson(jsonStudents); // lấy danh sách student từ json
    print(studentsFetched);

    Class schoolClass = Class(json["name"],json["classId"]);
    schoolClass.setCode(code);
    schoolClass.students.addAll(studentsFetched); // thêm các học sinh vào lớp học
    return schoolClass;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
    return null;
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

