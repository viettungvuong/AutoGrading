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
            User.instance.username??"",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            if (User.instance.isSignedIn()){

            }
            else{

            }
          }, child: Text(User.instance.isSignedIn()?"Sign out":"Sign in")),
        ],
      ),
    );
  }
}