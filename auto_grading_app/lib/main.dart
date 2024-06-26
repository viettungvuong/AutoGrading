import 'package:auto_grading_mobile/repositories/classRepository.dart';
import 'package:auto_grading_mobile/repositories/examRepository.dart';
import 'package:auto_grading_mobile/repositories/examSessionRepository.dart';
import 'package:auto_grading_mobile/repositories/studentRepository.dart';
import 'package:auto_grading_mobile/screens/classManagement.dart';
import 'package:auto_grading_mobile/screens/examOverview.dart';
import 'package:auto_grading_mobile/screens/examSessionScreen.dart';
import 'package:auto_grading_mobile/screens/examsStudent.dart';
import 'package:auto_grading_mobile/screens/grading.dart';
import 'package:auto_grading_mobile/screens/joinClass.dart';
import 'package:auto_grading_mobile/screens/loginRegister.dart';

import 'package:auto_grading_mobile/screens/specifyTest.dart';
import 'package:auto_grading_mobile/screens/studentManagement.dart';
import 'package:auto_grading_mobile/screens/user.dart';
import 'package:auto_grading_mobile/theme.dart';
import 'package:auto_grading_mobile/views/examView.dart';
import 'package:auto_grading_mobile/widgets/bottomBar.dart';
import 'package:auto_grading_mobile/screens/cameraScreen.dart';
import 'package:auto_grading_mobile/widgets/searchBar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/backendDatabase.dart';
import 'logic/examSessionConverter.dart';
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
      theme: appTheme(),
      home: LoginScreen(),
    );
  }
}


List<Widget> getScreens(){
  List<Widget> screens = [];

  if (User.instance.isStudent==false){
    screens = [  ExamSessionScreen(),
      ClassManagementScreen(),
      UserScreen(user: User.instance,)];
  }
  else{
    screens = [
      JoinClassScreen(),
      ExamStudentScreen(),
      UserScreen(user: User.instance,)];
  }

  return screens;
}



class MainScreen extends ConsumerWidget{ // man hinh tong
  final List<Widget> _screens = getScreens();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    ref.refresh(classesProvider);
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomBar(),
              ),
              Positioned(
                top: 0,
                bottom: 50,
                left: 0,
                right: 0,
                child: _screens[selectedIndex],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
