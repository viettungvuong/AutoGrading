import '../models/Exam.dart';
import '../models/Student.dart';
import 'package:http/http.dart' as http;
const String serverUrl="https://autogradingbackend.onrender.com";
// Future<List<Exam>> getExamsOfStudent(Student student) async{
//   final response = await http.get(Uri.parse("$serverUrl/exams/${student.getStudentId()}"));
//   print("Fetching student $response");
//   if (response.statusCode == 200) {
//     print("Get student successfully");
//     return jsonDecode(response.body) as Map<String, dynamic>;
//   } else {
//     // Request failed
//     print('Failed with status code: ${response.statusCode}');
//   }
// }