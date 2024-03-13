import 'package:auto_grading_mobile/screens/grading.dart';
import 'package:auto_grading_mobile/screens/savedSessions.dart';
import 'package:auto_grading_mobile/widgets/bottomBar.dart';
import 'package:auto_grading_mobile/widgets/cameraScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras=[];
int currentScreenIndex=0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
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
      home: CameraScreen(),
    );
  }
}

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  List<Widget> _screens = [
    CameraScreen(),
    SavedSessionsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _screens[currentScreenIndex], // khi bấm thì sẽ đổi screen
          BottomBar(), // bottom bar
        ],
      ),
    );
  }
}
