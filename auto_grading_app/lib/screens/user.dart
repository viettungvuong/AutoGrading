import 'package:auto_grading_mobile/controllers/userController.dart';
import 'package:auto_grading_mobile/screens/loginRegister.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restart_app/restart_app.dart';

import '../main.dart';
import '../models/User.dart';
import '../structs/pair.dart';

class UserScreen extends StatelessWidget {
  final User user;

  UserScreen({required this.user});

  void _showChangePasswordDialog(BuildContext context) {
    // mo popup doi mat khau
    String confirmPassword = '';
    String newPassword = '';
    bool wrongPassword=false;
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
                  decoration: InputDecoration(labelText: "Confirm password")),
              (wrongPassword)?Text("This password does not match with the current password",style: TextStyle(color: Colors.red),):SizedBox(),
              TextField(
                  onChanged: (value) {
                    newPassword = value;
                  },
                  decoration: InputDecoration(labelText: "New Password")),
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
                Pair res = await ChangePassword(User.instance.email!, confirmPassword, newPassword);
                print(res.a);

                if (res.a){ // true
                  Navigator.of(context).pop(); // Close the dialog
                }
                else{
                  wrongPassword=true;
                }

              },
              child: Text('Change'),
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
                  Logout(); // thoat dang nhap

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                  );
                }

                // chay lai app

              },
              child: Text(
                User.instance.isSignedIn() ? "Sign out" : "Sign in",
                style: TextStyle(
                    color:
                        User.instance.isSignedIn() ? Colors.red : Colors.green),
              )),
          SizedBox(height: 20),
          (User.instance.isSignedIn())?          ElevatedButton(
            onPressed: () {
              _showChangePasswordDialog(context); // Show change password dialog
            },
            child: Text("Change Password"),
          ):SizedBox(),

        ],
      ),
    );
  }
}
