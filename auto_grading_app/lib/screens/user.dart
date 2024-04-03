import 'package:auto_grading_mobile/controllers/userController.dart';
import 'package:auto_grading_mobile/screens/loginRegister.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';


class UserScreen extends StatelessWidget {
  final User user;
  UserScreen({required this.user});
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            User.instance.email??"",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            if (User.instance.isSignedIn()){
              Logout(); // thoat dang nhap
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginRegisterScreen()),
            );
          }, child: Text(User.instance.isSignedIn()?"Sign out":"Sign in")),
        ],
      ),
    );
  }
}