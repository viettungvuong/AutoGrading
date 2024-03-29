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
            user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}