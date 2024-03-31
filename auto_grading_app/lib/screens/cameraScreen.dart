
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

import '../models/examSession.dart';
import 'grading.dart';

class CameraScreen extends StatefulWidget {
  ExamSession examSession;
  CameraScreen({required this.examSession});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController? _controller;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    if (cameras.length==0){
      return; // neu khong co camera thi khong initialize
    }
    try{
      _controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
      _controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e){
      print(e);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    _image = pickedImage;
    if (_image!=null){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GradingScreen(
            information: widget.examSession,
            image: _image!,
            availableChoices: 5,

          ),
        ),
      );
    }

  }
  
  Future<void> _takePicture() async {
    try {
      await _controller!.initialize();

      // anh chup
      _image = await _controller!.takePicture();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GradingScreen(
            information: widget.examSession,
            image: _image!,
            availableChoices: 5,
          ),
        ),
      );
      // tạm thời để 5
    } catch (e) {
      // Handle errors that might occur during the process
      print('Error capturing picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (cameras.length == 0 ||
          _controller == null ||
          !_controller!.value.isInitialized)
          ? Center(
        child: Text(
          "Cannot load camera",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      )
          : Column(
        children: [
          (_controller != null)
              ? Container(
            margin: EdgeInsets.all(50),
            child: CameraPreview(_controller!),
          )
              : SizedBox(), // phan camera


          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
               _takePicture();
            },
            child: const Text('Grade now'),
          ),
          ElevatedButton(onPressed: () async {
            _pickImage();
          }, child: const Text('Select image from the gallery'),)
        ],
      ),

    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
