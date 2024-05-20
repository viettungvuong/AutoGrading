import 'dart:async';
import 'dart:io';

import 'package:auto_grading_mobile/logic/userController.dart';
import 'package:auto_grading_mobile/screens/loginRegister.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart_app/restart_app.dart';

import '../main.dart';
import '../models/Student.dart';
import '../models/User.dart';
import '../structs/pair.dart';

class StudentInfo extends StatelessWidget {
  final Student student;

  StudentInfo({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(50),
      child: Column(
        children: [
          Text(student.getName(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text("Student ID: ${student.getStudentId()}", style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

class UserScreen extends StatefulWidget {
  final User user;

  UserScreen({required this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;

  void _showChangePasswordDialog(BuildContext context) {
    String confirmPassword = '';
    String newPassword = '';
    bool wrongPassword = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration: InputDecoration(labelText: "Confirm password"),
              ),
              (wrongPassword) ? Text("This password does not match with the current password", style: TextStyle(color: Colors.red),) : SizedBox(),
              TextField(
                onChanged: (value) {
                  newPassword = value;
                },
                decoration: InputDecoration(labelText: "New Password"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Set loading state to true
                });

                Pair res = await ChangePassword(User.instance.email!, confirmPassword, newPassword);

                setState(() {
                  _isLoading = false; // Set loading state to false
                });

                if (res.a) {
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  setState(() {
                    wrongPassword = true;
                  });
                  Fluttertoast.showToast(msg: "Wrong password");
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator() // DANG LOAD
                  : Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
            'Do you want to logout?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Logout(); // logout

                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                      (route) => false,
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          User.instance.isStudent ? FutureBuilder<Student?>(
            future: User.instance.toStudent(),
            builder: (BuildContext context, AsyncSnapshot<Student?> snapshot) {
              if (_isLoading) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data == null) {
                  return Text('Student information is not available'); // neu null
                }

                if (User.instance.isStudent) {
                  // If the instance is a student, use the data
                  return StudentInfo(student: snapshot.data!);
                } else {
                  return SizedBox();
                }
              }
            },
          ) : SizedBox(),
          SizedBox(height: 20),
          Text(
            User.instance.email ?? "",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (User.instance.isSignedIn()) {
                _showLogoutDialog(context);
              }
            },
            child: Text(
              User.instance.isSignedIn() ? "Sign out" : "Sign in",
              style: TextStyle(
                color: User.instance.isSignedIn() ? Colors.red : Colors.green,
              ),
            ),
          ),
          SizedBox(height: 20),
          (User.instance.isSignedIn()) ? ElevatedButton(
            onPressed: () {
              _showChangePasswordDialog(context); // Show change password dialog
            },
            child: Text("Change Password"),
          ) : SizedBox(),
        ],
      ),
    );
  }
}
