import 'dart:convert';

import 'package:auto_grading_mobile/controllers/studentConverter.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

Future<Class?> classFromJson(Map<String, dynamic> json) async{
  String classId = json["classId"];
  String serverUrl="https://autogradingbackend.onrender.com/class/byId/$classId"; // tìm student của class ny
  List<Student> students = [];

  final response = await http.get(Uri.parse(serverUrl));
  if (response.statusCode == 200) {
    dynamic jsonStudents = jsonDecode(response.body) as Map<String, dynamic>;
    dynamic studentsFetched = studentsFromJson(jsonStudents); // lấy danh sách student từ json
    students.addAll(studentsFetched);
    Class schoolClass = Class(json["name"],json["classId"]);
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

