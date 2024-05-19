import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../logic/localPreferences.dart';
import '../main.dart';
import '../structs/pair.dart';
import '../logic/userController.dart';

Future<void> saveLoginInfo(String username, String password) async {
  await Preferences.instance.initPreferences();
  Preferences.instance[prefKey]=true;
  Preferences.instance[userNameKey]=username.toLowerCase();
  Preferences.instance[passwordKey]=password;

  // Preferences.instance.saveBoolean(prefKey, true);
  // Preferences.instance.saveString(userNameKey, username);
  // Preferences.instance.saveString(passwordKey, password);
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _studentIdController = TextEditingController();
  String _userType = "Teacher";
  bool _isLoading = false;

  final TextStyle style = TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: style,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              style: style,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: style,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _userType,
              items: [
                DropdownMenuItem(child: Text('Teacher'), value: 'Teacher'),
                DropdownMenuItem(child: Text('Student'), value: 'Student'),
              ],
              onChanged: (value) {
                setState(() {
                  _userType = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            _userType=="Student"?TextField( // chi nhap studentId khi chon student
              controller: _studentIdController,
              style: style,
              decoration: InputDecoration(
                labelText: 'Student ID',
              ),
            ):SizedBox(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : register,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void register() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    bool isStudent = _userType == "Student";
    String? studentId = _studentIdController.text;

    Pair res = await Signup(name, email, password, isStudent, studentId);

    setState(() {
      _isLoading = false;
    });

    if (res.a) {
      await saveLoginInfo(email, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      showError(res.b);
    }
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


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkAutoSignIn();
  }

  Future<void> checkAutoSignIn() async {
    await Preferences.instance.initPreferences();
    final autologin = Preferences.instance[prefKey];
    final username = Preferences.instance[userNameKey];
    final password = Preferences.instance[passwordKey];

    if (autologin!=null&&autologin==true) {
      login(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button press
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Column(
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
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => login(
                    _emailController.text, _passwordController.text),
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(String username, String password) async {
    setState(() {
      _isLoading = true;
    });

    Pair res = await Signin(username, password);

    setState(() {
      _isLoading = false;
    });

    if (res.a) {
      await saveLoginInfo(username, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      showError(res.b);
    }
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

