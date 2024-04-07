import 'package:auto_grading_mobile/controllers/backendDatabase.dart';
import 'package:auto_grading_mobile/controllers/examSessionConverter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

import '../models/examSession.dart';

class SavedSessionsScreen extends StatefulWidget {
  @override
  _SavedSessionsScreenState createState() => _SavedSessionsScreenState();
}

class _SavedSessionsScreenState extends State<SavedSessionsScreen> {
  Future<List<ExamSession>>? _sessions;

  @override
  void initState() {
    super.initState(); // Call super.initState() first
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    dynamic map = await GetExamSessionsFromDatabase();
    setState(() {
      _sessions = sessionsFromJson(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beautiful List Screen'),
      ),
      body: FutureBuilder<List<ExamSession>>(
        future: _sessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show a loading indicator while waiting for data
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show error message if fetching data fails
            );
          } else {
            // Data has been successfully fetched
            final sessions = snapshot.data!;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      sessions[index].getName(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

