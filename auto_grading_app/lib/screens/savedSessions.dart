import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

import '../models/examSession.dart';

class SavedSessionsScreen extends StatefulWidget {
  @override
  _SavedSessionsScreenState createState() => _SavedSessionsScreenState();
}

class _SavedSessionsScreenState extends State<SavedSessionsScreen> {
  late List<ExamSession> sessions;

  @override
  void initState() async {
    setState(() async {
      dynamic map = await GetExamSessionsFromDatabase();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beautiful List Screen'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  items[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Add onTap functionality here
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
