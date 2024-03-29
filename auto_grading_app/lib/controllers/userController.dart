import 'dart:convert';

import '../models/User.dart';
import 'package:http/http.dart' as http;
const String serverUrl = "";

void fetchUser(String username, String password, bool login) async {
  var url = Uri.parse(serverUrl); // Connect to the backend server
  Map<String, dynamic>? jsonResponse;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'inputPassword': password,
      }),
    );

    if (response.statusCode == 200) {
      // thanh cong
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      User.instance.username=jsonResponse["username"];
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }
}

void logout(){
  User.instance.username="";

  // xoa nhung thu lien quan toi repo
}