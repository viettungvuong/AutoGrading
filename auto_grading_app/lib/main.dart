import 'package:auto_grading_mobile/controllers/examSessionRepository.dart';
import 'package:auto_grading_mobile/screens/grading.dart';
import 'package:auto_grading_mobile/screens/loginRegister.dart';

import 'package:auto_grading_mobile/screens/specifyTest.dart';
import 'package:auto_grading_mobile/screens/studentManagement.dart';
import 'package:auto_grading_mobile/screens/user.dart';
import 'package:auto_grading_mobile/views/examView.dart';
import 'package:auto_grading_mobile/widgets/bottomBar.dart';
import 'package:auto_grading_mobile/screens/cameraScreen.dart';
import 'package:auto_grading_mobile/widgets/searchBar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/backendDatabase.dart';
import 'controllers/examSessionConverter.dart';
import 'models/User.dart';
import 'models/examSession.dart';

List<CameraDescription> cameras=[];
final selectedIndexProvider = StateProvider<int>((ref) => 0);


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Grading',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginRegisterScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget { // Convert HomeScreen to StatefulWidget
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('List Popup'),
                                    content: Container(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemCount: sessions[index].exams.length,
                                        itemBuilder: (context, indexExam) {
                                          return ExamView(t: sessions[index].exams[indexExam]);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  sessions[index].getName(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
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



class MainScreen extends ConsumerWidget{ // man hinh tong
  List<Widget> _screens = [
    HomeScreen(),
    StudentManagementScreen(),
    UserScreen(user: User.instance,)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              child: _screens[selectedIndex],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomBar(),
            )
          ],
        ),
      ),
    );
  }
}
