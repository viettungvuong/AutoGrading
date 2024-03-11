import 'package:auto_grading_mobile/constant.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

void ConnectToGrade(XFile image, int availableChoices){
  var url = Uri.parse(serverUrl);

  var request = new http.MultipartRequest("POST", url); // gửi qua server để chấm bài
  request.fields['available_choices'] = availableChoices.toString();
  request.files.add(http.MultipartFile.fromPath(
    'file',
    image.path,
    contentType: new MediaType('image','png'),
  ) as http.MultipartFile);
  request.send().then((response) {
    if (response.statusCode == 200) print("Uploaded!");
  });
}