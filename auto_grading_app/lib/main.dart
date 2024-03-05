import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras=[];

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

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController? controller;

  @override
  void initState() {
    super.initState();
    if (cameras.length==0){
      return;
    }
    try{
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    if (cameras.length==0||controller==null||!controller!.value.isInitialized) {
      return Center(
        child: Text("Cannot load camera", style: TextStyle(color: Colors.white, fontSize: 25),)
      );
    }
    return AspectRatio(
      aspectRatio: 16/9,
      child: CameraPreview(controller!),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}