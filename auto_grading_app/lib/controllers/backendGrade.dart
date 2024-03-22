import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

const String serverUrl="http://127.0.0.1:8000";

Future<Map<String, dynamic>?> ConnectToGrade(XFile image, int availableChoices) async {
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? json;

  final request = http.MultipartRequest("POST", url); // Send the image to the grading server
  request.fields['available_choices'] = availableChoices.toString();
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    image.path,
    contentType: MediaType('image', 'png'),
  ));

  try {
    final streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      final response = await http.Response.fromStream(streamedResponse);
      json = jsonDecode(response.body) as Map<String, dynamic>; // Convert response to JSON format
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }

  return json;
}