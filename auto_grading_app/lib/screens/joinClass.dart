import 'dart:convert';

import 'package:auto_grading_mobile/logic/backendDatabase.dart';
import 'package:auto_grading_mobile/logic/classConverter.dart';
import 'package:auto_grading_mobile/repositories/classRepository.dart';
import 'package:auto_grading_mobile/screens/classManagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../logic/authController.dart';
import '../models/Class.dart';
import '../models/User.dart';



class JoinClassScreen extends ConsumerStatefulWidget {
  @override
  _JoinClassScreenState createState() => _JoinClassScreenState();
}


class _JoinClassScreenState extends ConsumerState<JoinClassScreen> {
  TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
            Container(
              height: MediaQuery.of(context).size.height * 2 / 3, // Adjust as needed
              child: ClassManagementScreen(), // display the class list
            ),
          ],
        ),
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
        final jsonResponse = jsonDecode(response.body);
        final classJson = jsonResponse["class"];
        Class? newClass = await classFromJson(classJson);
        if (newClass != null) {
          await ClassRepository.instance.add(newClass); // them vao repository

          ref.refresh(classesProvider); // refresh lai de hien cap nhat
        }
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
