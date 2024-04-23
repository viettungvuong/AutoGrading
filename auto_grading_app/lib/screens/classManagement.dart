import 'package:auto_grading_mobile/controllers/studentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../controllers/classRepository.dart';
import '../models/Class.dart';
import '../models/Student.dart';
import '../views/classView.dart';
import '../views/studentView.dart';
import '../widgets/searchBar.dart';

class ClassManagementScreen extends StatefulWidget {
  @override
  _ClassManagementScreenState createState() =>
      _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  Future<List<Class>>? _classes;
  TextEditingController _newClassController = TextEditingController(); // for entering ID
  TextEditingController _newClassController2 = TextEditingController(); // for entering name

  Future<void> _loadClasses() async {
    await ClassRepository.instance.initialize();
    setState(() {
      _classes = Future.value(ClassRepository.instance.getAll());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }


  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newClassController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _newClassController2,
                decoration: InputDecoration(
                  labelText: 'Id',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (_newClassController.text.isEmpty || _newClassController2.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please fill in all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );
                }
                setState(() {
                  String name = _newClassController.text;
                  String id = _newClassController2.text;
                  ClassRepository.instance.add(Class(name,id));
                  _newClassController.text = "";
                  _newClassController2.text = "";

                  Navigator.of(context).pop();
                });
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Search(
              onSearch: (query) {
                setState(() {
                  _classes = Future.value(
                      ClassRepository.instance.filter(query));
                });
              },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _showAddDialog();
                });

              },
              icon: Icon(Icons.add),
            ),

            Expanded(
              child: FutureBuilder<List<Class>>(
                future: _classes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No classes available'),
                    );
                  } else {
                    final classes = snapshot.data!;
                    return ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        return ClassView(t: classes[index],);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
