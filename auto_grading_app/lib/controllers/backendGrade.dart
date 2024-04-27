import 'dart:convert';

import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

const String serverUrl="https://viettungvuong.pythonanywhere.com/grade";

Future<Map<String, dynamic>?> ConnectToGrade(XFile image, ExamSession session) async {
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? json;

  Map<int,int> correctAnswers = session.getAnswers();
  int availableChoices = session.getAvailableChoices();

  Map<String,String> convertedAnswers={};
  correctAnswers.forEach((key, value) {
    convertedAnswers['"$key"']="$value";
  });

  final request = http.MultipartRequest("POST", url);
  request.fields['available_choices'] = availableChoices.toString();
  request.fields['right_answers'] = convertedAnswers.toString();
  request.fields['session_id']=session.id!;
  print(convertedAnswers);
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    image.path,
    contentType: MediaType('image', 'png'),
  )); // gui file qua http

  try {
    final streamedResponse = await request.send();
    print(streamedResponse.statusCode);
    if (streamedResponse.statusCode == 200) {
      final response = await http.Response.fromStream(streamedResponse);
      json = jsonDecode(response.body) as Map<String, dynamic>; // chuyen qua json
      print(json);
    }
    else{
      print(streamedResponse.reasonPhrase);
      throw Exception(streamedResponse.headers);
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return json;
}