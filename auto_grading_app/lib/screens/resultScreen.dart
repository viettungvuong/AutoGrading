import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late CameraController? controller;

  @override
  void initState() {
    super.initState();
    if (cameras.length==0){
      return;
    }
    try{
      controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
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
    return Scaffold(
      body: (cameras.length == 0 ||
          controller == null ||
          !controller!.value.isInitialized)
          ? Center(
        child: Text(
          "Cannot load camera",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      )
          : Column(
        children: [
          Container(
            margin: EdgeInsets.all(50),
            child: CameraPreview(controller!),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              try {
                // Ensure that the camera is initialized
                await controller!.initialize();

                // Attempt to take a picture and retrieve the path
                final XFile picture = await controller!.takePicture();

                // tạm thời để 5
              } catch (e) {
                // Handle errors that might occur during the process
                print('Error capturing picture: $e');
              }
            },
            child: const Text('Grade now'),
          ),
        ],
      ),

    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
