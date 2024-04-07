import 'dart:convert';

import 'package:auto_grading_mobile/models/examSession.dart';

import '../models/Exam.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

import '../models/User.dart';
import '../structs/pair.dart';

const String serverUrl="https://autogradingbackend.onrender.com";

// Future<Map<String, dynamic>?> GetExamsFromDatabase() async {
//     final response = await http.get(Uri.parse(serverUrl));
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as Map<String, dynamic>;
//     } else {
//       // Request failed
//       print('Failed with status code: ${response.statusCode}');
//     }
// }
//

Future<Map<String, dynamic>?> GetStudentsFromDatabase() async {
  if (User.instance.isSignedIn()){ //chua signin thi khong lay duoc
    return null;
  }
  final response = await http.get(Uri.parse(serverUrl+"/student"+User.instance.email!));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>?> GetExamSessionsFromDatabase() async {
  if (!User.instance.isSignedIn()){ //chua signin thi khong lay duoc
    return null;
  }

  final response = await http.get(Uri.parse(serverUrl+"/session/"+User.instance.email!));

  if (response.statusCode == 200) {
    print("Okay");
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
  }
}
//
// Future<Map<String, dynamic>?> updateExamToDatabase(Exam exam) async {
//   var url = Uri.parse(serverUrl);
//   Map<String, dynamic>? jsonResponse;
//
//   try {
//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'studentId': exam.getStudent().getStudentId(), // de map student id tim student trong backend
//         'score': exam.getScore().toString(),
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
//     }
//   } catch (e) {
//     print('Error connecting to server: $e');
//   }
//
//   return jsonResponse;
// }

Future<Student?> getStudentFromId(String id) async{
  var url = Uri.parse("$serverUrl/student/byId/$id");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    dynamic json =  jsonDecode(response.body) as Map<String, dynamic>;
    Student student = Student(json["name"],json["studentId"]);
    return student;
  } else {
    return null;
  }
}


Future<Pair> createExamSessionToDatabase(ExamSession session) async {
  var url = Uri.parse(serverUrl+"/session");
  Map<String, dynamic>? jsonResponse;
  print("Updating exam session");


  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': session.getName(),
        'userId': User.instance.email
      }),
    );

    print("Status code: "+response.statusCode.toString());

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(jsonResponse["_id"],""); //tra ve _id
    }
    else{
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(null,jsonResponse["error"]);
    }
  } catch (e) {
    return Pair(null,e);
  }

}

Future<Pair> updateExamSessionToDatabase(ExamSession session, String id) async {
  var url = Uri.parse("$serverUrl/session/$id");
  Map<String, dynamic>? jsonResponse;
  print("Updating exam session");

  List<Map<String,String>> exams=[];
  int n=session.exams.length;
  for (int i=0; i<n; i++){
    String studentId = session.exams[i].getStudent().getUniqueId(); // lay id tren database (k phai mongodb)
    String score = session.exams[i].getScore().toString();
    exams.add({
      'studentId': studentId,
      'score': score,
    });
  } // luu cac bai thi cua session vao trong json

  print(exams);

  try {
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'exams': exams,
        'userId': User.instance.email
      }),
    );

    print("Status code: "+response.statusCode.toString());

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(jsonResponse["_id"],"");
    }
    else{
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Pair(null,jsonResponse["error"]);
    }
  } catch (e) {
    return Pair(null,e);
  }

}

Future<Pair> updateStudentToDatabase(Student student) async {
  var url = Uri.parse(serverUrl+"/student");
  Map<String, dynamic>? jsonResponse;

  print("Updating student");
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'studentId': student.getStudentId(),
        'name': student.getName()
      }),
    );

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      String id = jsonResponse["id"];
      return Pair(true,id);
    }
    else{
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse["error"]);
      return Pair(false,jsonResponse["error"]);
    }
  } catch (e) {
    print(e);
    return Pair(false,e);
  }

}