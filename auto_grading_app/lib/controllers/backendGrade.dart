import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

const String serverUrl="https://viettungvuong.pythonanywhere.com/grade";

Future<Map<String, dynamic>?> ConnectToGrade(XFile image, int availableChoices, Map<int,int> correctAnswers) async {
  var url = Uri.parse(serverUrl); // Connect to the backend server
  print(url);
  Map<String, dynamic>? json;

  final request = http.MultipartRequest("POST", url);
  request.fields['available_choices'] = availableChoices.toString();
  request.fields['right_answers'] = correctAnswers.toString();
  print(correctAnswers.toString());
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    image.path,
    contentType: MediaType('image', 'png'),
  )); // gui file qua http

  try {
    final streamedResponse = await request.send();
    if (streamedResponse.statusCode == 201) {
      final response = await http.Response.fromStream(streamedResponse);
      json = jsonDecode(response.body) as Map<String, dynamic>; // chuyen qua json
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return json;
}