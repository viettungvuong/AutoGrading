import 'dart:convert';

import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/classRepository.dart';
import 'package:auto_grading_mobile/screens/classManagement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../controllers/authController.dart';
import '../models/User.dart';

class JoinClassScreen extends StatefulWidget {
  @override
  _JoinClassScreenState createState() => _JoinClassScreenState();
}

class _JoinClassScreenState extends State<JoinClassScreen> {
  TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Enter Class Code',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _joinClass,
                      child: Text('Join Class'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ClassManagementScreen(),
            ),
          ],
        ),
    );
  }

  Future<void> _joinClass() async {
    setState(() {
      _isLoading = true;
    });

    String classCode = _codeController.text;

    try {
      final response = await http.post(
          Uri.parse("$serverUrl/class/join"),
          headers: AuthController.instance.getHeader(),
          body: jsonEncode(<String, dynamic>{
            'code': classCode,
            'userId': User.instance.email
          }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Class joined successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // them class vao day

      } else {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['error'];
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      // Show error message
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
