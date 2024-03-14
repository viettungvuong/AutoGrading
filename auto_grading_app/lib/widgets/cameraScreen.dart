import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/grading.dart';

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

                // Handle the picture captured, you can save it or do any other operation
                // For example, you can display the picture in a new screen or widget
                // You can use the picture.path to display the image
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: picture.path)));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GradingScreen(
                      image: picture,
                      availableChoices: 5,
                    ),
                  ),
                );
                // tạm thời để 5
              } catch (e) {
                // Handle errors that might occur during the process
                print('Error capturing picture: $e');
              }
            },
            child: const Text('Grade'),
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
