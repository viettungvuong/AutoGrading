import 'package:auto_grading_mobile/controllers/userController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../controllers/localPreferences.dart';
import '../main.dart';
import '../structs/pair.dart';
const String prefKey="login";
const String userNameKey="username";
const String passwordKey="password";

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAndSignIn();
  }

  Future<void> checkAndSignIn() async {
    if (Preferences.instance.getBool(prefKey) == true) {
      String? username = Preferences.instance.getString(userNameKey);
      String? password = Preferences.instance.getString(passwordKey);
      if (username != null && password != null) {
        Pair res = await Signin(username, password);
        if (res.a) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      }
    }
  }

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
                  onPressed: () => login(),
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () => register(),
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    String username = _emailController.text;
    String password = _passwordController.text;
    Pair res = await Signin(username, password);

    if (res.a) {
      saveLoginInfo(username, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      showError(res.b);
    }
  }

  Future<void> register() async {
    String username = _emailController.text;
    String password = _passwordController.text;
    Pair res = await Signup(username, password);

    if (res.a) {
      saveLoginInfo(username, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      showError(res.b);
    }
  }

  void saveLoginInfo(String username, String password) {
    Preferences.instance.saveBoolean(prefKey, true);
    Preferences.instance.saveString(userNameKey, username);
    Preferences.instance.saveString(passwordKey, password);
  }

  void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
