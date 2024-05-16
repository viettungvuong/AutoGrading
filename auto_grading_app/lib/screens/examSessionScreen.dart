import 'package:auto_grading_mobile/screens/specifyTest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../logic/examSessionRepository.dart';
import '../models/examSession.dart';
import '../views/examView.dart';
import '../views/sessionView.dart';
import '../widgets/searchBar.dart';

class ExamSessionScreen extends StatefulWidget { // Convert HomeScreen to StatefulWidget
  @override
  _ExamSessionScreenState createState() => _ExamSessionScreenState();
}

class _ExamSessionScreenState extends State<ExamSessionScreen> {
  Future<List<ExamSession>>? _sessions;

  @override
  void initState() {
    // _loadInitialize();
    super.initState();
    setState(() {
      _sessions = Future.value(ExamSessionRepository.instance.getAll());
    });
  }

  Future<void> _loadInitialize() async {
    // if (User.instance.isStudent==false){
    //   await StudentRepository.instance.initialize();
    //   await ClassRepository.instance.initialize();
    //   await ExamSessionRepository.instance.initialize();
    // }
    // else{
    //   await ExamRepository.instance.initialize();
    // }


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpecifyTestScreen()),
                  );
                },
                child: Text('Start grading'),
              ),
            ),
            SizedBox(height: 20), // Add some space between the buttons
            Search(onSearch: (query) {
              setState(() {
                _sessions = Future.value(ExamSessionRepository.instance.filter(query));
              });
            }),
            Expanded(
              child: FutureBuilder<List<ExamSession>>(
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
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    // Handle the case where snapshot.data is null or empty
                    return Center(
                      child: Text('No sessions available'), // Show a message indicating no sessions available
                    );
                  } else {
                    final sessions = snapshot.data!;
                    return ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        return ExamSessionView(t: sessions[index]);
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