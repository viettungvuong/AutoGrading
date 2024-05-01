import 'dart:convert';

import 'package:auto_grading_mobile/api_url.dart';
import 'package:auto_grading_mobile/controllers/authController.dart';
import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/models/examSession.dart';

import '../models/Class.dart';
import '../models/Exam.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;

import '../models/User.dart';
import '../structs/pair.dart';

const String serverUrl=databaseUrl;

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

Future<Map<String, dynamic>?> GetExamsFromDatabase(String studentEmail) async { // lấy cac bai ktra cua mot hoc sinh
  if (!User.instance.isSignedIn()){ //chua signin thi khong lay duoc
    return null;
  }
  final response = await http.get(Uri.parse("$serverUrl/exam/${studentEmail}"),     headers: AuthController.instance.getHeader(),);
  if (response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>?> GetStudentsFromDatabase() async {
  if (!User.instance.isSignedIn()){ //chua signin thi khong lay duoc
    return null;
  }
  final response = await http.get(Uri.parse("$serverUrl/student/${User.instance.email!}"),     headers: AuthController.instance.getHeader(),);
  print("Fetching student $response");
  if (response.statusCode == 200) {
    print("Get student successfully");
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

  print("fetching exam session");

  final response = await http.get(Uri.parse(serverUrl+"/session/"+User.instance.email!),     headers: AuthController.instance.getHeader(),);

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Request failed
    print('Failed with status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>?> GetClassesFromDatabase() async {
  if (!User.instance.isSignedIn()){ //chua signin thi khong lay duoc
    print("Not sign in");
    return null;
  }

  final response = await http.get(Uri.parse("$serverUrl/class/${User.instance.email!}"),      headers: AuthController.instance.getHeader(),);
  print("fetching classes");
  if (response.statusCode == 200) {
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
  print(response.statusCode);
  if (response.statusCode == 200) {
    dynamic json =  jsonDecode(response.body) as Map<String, dynamic>;
    print(json);
    Student student = Student(json["name"],json["studentId"]);

    return student;
  } else {
    return null;
  }
}


Future<Pair> createExamSessionToDatabase(ExamSession session) async {
  var url = Uri.parse(serverUrl+"/session");
  Map<String, dynamic>? jsonResponse;
  print("Creating exam session");

  Map<String, int> stringKeyAnswers = {
    for (var entry in session.getAnswers().entries) entry.key.toString(): entry.value,
  };

  try {
    final response = await http.post(
      url,
      headers: AuthController.instance.getHeader(),
      body: jsonEncode(<String, dynamic>{
        'name': session.getName(),
        'userId': User.instance.email,
        'classId': session.getClass().getId(),
        'answers': stringKeyAnswers,
        'available_choices': session.getAvailableChoices(),
        'questions': session.getNumOfQuestions()
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
    String studentId = session.exams[i].getStudent().getStudentId(); // lay id tren database (k phai mongodb)
    String score = session.exams[i].getScore().toString();
    String gradedPaperLink = session.exams[i].getGradedPaperLink();
    exams.add({
      'studentId': studentId,
      'score': score,
      'graded_paper_link': gradedPaperLink
    });
  } // luu cac bai thi cua session vao trong json

  print(exams);

  try {
    final response = await http.put(
      url,
      headers: AuthController.instance.getHeader(),
      body: jsonEncode(<String, dynamic>{
        'exams': exams,
        'userId': User.instance.email,
        'classId': session.getClass().getId()
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
      headers: AuthController.instance.getHeader(),
      body: jsonEncode(<String, dynamic>{
        'studentId': student.getStudentId(),
        'name': student.getName(),
        'classId': student.classes.elementAt(student.classes.length-1).getId()
      }),
    );

    print(response.statusCode);

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

Future<Pair> updateClassToDatabase(Class sClass) async {
  var url = Uri.parse(serverUrl+"/class");
  Map<String, dynamic>? jsonResponse;

  print("Updating class");

  try {
    final response = await http.post(
      url,
      headers: AuthController.instance.getHeader(),
      body: jsonEncode(<String, dynamic>{
        'className': sClass.getName(),
        'classId': sClass.getId(),
        'userId': User.instance.email
      }),
    );


    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      String invitationCode = jsonResponse["code"];
      String classDbId = jsonResponse["id"];

      return Pair(true,Pair(invitationCode,classDbId));
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