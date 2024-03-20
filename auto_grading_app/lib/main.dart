import 'package:auto_grading_mobile/screens/grading.dart';
import 'package:auto_grading_mobile/screens/savedSessions.dart';
import 'package:auto_grading_mobile/screens/specifyTest.dart';
import 'package:auto_grading_mobile/widgets/bottomBar.dart';
import 'package:auto_grading_mobile/widgets/cameraScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      home: MainScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpecifyTestScreen()),
                  );
                },
                child: Text('Start grading'),
              ),
              SizedBox(height: 20), // Add some space between the buttons
              ElevatedButton(
                onPressed: () {
                  // cai nay se hien danh sach cac session
                },
                child: Text('Continue old sessions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MainScreen extends ConsumerWidget{
  List<Widget> _screens = [
    HomeScreen(),
    SavedSessionsScreen()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider); // lấy giá trị từ selectedIndexProvider
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: _screens[selectedIndex], // khi bấm thì sẽ đổi screen
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(), // bottom bar
          )

        ],
      ),
    );
  }
}
