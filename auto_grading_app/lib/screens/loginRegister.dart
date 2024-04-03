import 'package:auto_grading_mobile/controllers/userController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../structs/pair.dart';

class LoginRegisterScreen extends StatelessWidget {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String username = _emailController.text;
                    String password = _passwordController.text;
                    Pair res = await Signup(username, password);

                    if (res.a==true){ // dang nhap thanh cong
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                    else{
                      Fluttertoast.showToast( // nay de ghi ra loi gi luon
                        msg: res.b, // xuat thong bao loi
                        toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be displayed
                        gravity: ToastGravity.BOTTOM, // Position of the toast message
                        timeInSecForIosWeb: 1, // Duration for iOS and web platforms
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                      );
                    }
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String username = _emailController.text;
                    String password = _passwordController.text;
                    Pair res = await Signup(username, password);

                    if (res.a==true){ // dang nhap thanh cong
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: res.b,
                        toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be displayed
                        gravity: ToastGravity.BOTTOM, // Position of the toast message
                        timeInSecForIosWeb: 1, // Duration for iOS and web platforms
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                      );

                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}