import 'dart:convert';

import 'package:auto_grading_mobile/constant.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

Future<Map<String, dynamic>?> ConnectToGrade(XFile image, int availableChoices) async {
  var url = Uri.parse(serverUrl); // ket noi den backend figma
  Map<String,dynamic>? json=null;

  final request = new http.MultipartRequest("POST", url); // gửi qua server để chấm bài
  request.fields['available_choices'] = availableChoices.toString();
  request.files.add(http.MultipartFile.fromPath(
    'file',
    image.path,
    contentType: new MediaType('image','png'),
  ) as http.MultipartFile);
  request.send().then((response) async {
    if (response.statusCode == 200) {
      Response res = await Response.fromStream(response);
      json = jsonDecode(res.body) as Map<String, dynamic>; // doi qua map duoi format json
    };
  });

  return json;
}