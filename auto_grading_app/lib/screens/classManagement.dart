import 'package:auto_grading_mobile/controllers/studentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
