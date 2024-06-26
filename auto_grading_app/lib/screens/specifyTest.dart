import 'package:auto_grading_mobile/repositories/classRepository.dart';
import 'package:auto_grading_mobile/repositories/examSessionRepository.dart';
import 'package:auto_grading_mobile/models/examSession.dart';
import 'package:auto_grading_mobile/screens/cameraScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Class.dart';
import '../widgets/dropDownRepository.dart';

class SpecifyTestScreen extends StatefulWidget {
  @override
  _SpecifyTestScreenState createState() => _SpecifyTestScreenState();
}

class _SpecifyTestScreenState extends State<SpecifyTestScreen> {
  int _numQuestions = 2;
  int _numChoices = 2;

  TextEditingController _controller=TextEditingController();

  String? _selectedClassId;

  Map<int,int> _answers = {}; // luu lai nhung gi da chon

  ExamSession _ExamSession=ExamSession();
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _numQuestions; i++) {
      _answers[i]=0;
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter the exam session name here",
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: DropdownRepository(repository: ClassRepository.instance, onChanged: (selected){
                _selectedClassId = selected; // callback
                print(_selectedClassId);
                if (_selectedClassId!=null){
                  _ExamSession.setClass(ClassRepository.instance.findById(_selectedClassId!)!);
                }
              }, onAdded: (addedPair){
                // add class moi vao repository

                String name = addedPair.a;
                String id = addedPair.b;
                ClassRepository.instance.add(Class(name,id));
              },),
            ),
            SizedBox(height: 30,),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter the number of questions"
              ),
              onChanged: (value) {
                setState(() {
                  int oldNumQuestions = _numQuestions;
                  _numQuestions = int.tryParse(value) ?? 1;
                  if (_numQuestions > oldNumQuestions) {
                    for (int i = oldNumQuestions; i < _numQuestions; i++) {
                      _answers[i]=0;
                    }
                    print(_answers);
                  }
                  //   for (int i = oldNumQuestions - 1; i >= _numQuestions; i--) {
                  //     _answers.removeLast();
                  //   }
                  //   print(_answers);
                  // }
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Enter the number of available choices"
              ),
              onChanged: (value) {
                setState(() {
                  int oldNumChoices = _numChoices;
                  _numChoices = int.tryParse(value) ?? 1;
                  // if (oldNumChoices < _numChoices) {
                  //   for (int i = 0; i < _numQuestions; i++) {
                  //     if (_answers[i] >= _numChoices) {
                  //       _answers[i]=_numChoices-1;
                  //     }
                  //   }
                  // }
                });
              },
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                ),
                child: Column(
                  children: List.generate(_numQuestions, (questionIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("Question ${questionIndex + 1}:"),
                        ),
                        DropdownButton<int>(
                          value: _answers[questionIndex],
                          onChanged: (newValue) {
                            setState(() {
                              _answers[questionIndex] = newValue ?? 0;
                            });
                          },
                          items: List.generate(_numChoices, (choiceIndex) {
                            return DropdownMenuItem<int>(
                              value: choiceIndex,
                              child: Text("${String.fromCharCode(65 + choiceIndex)}"),
                            );
                          }),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),



            ElevatedButton(
              onPressed: () async {
                if (_numChoices==0||_numQuestions==0||_controller.text.isEmpty){
                  Fluttertoast.showToast(
                    msg: "You have not input sufficient information ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black45,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                _ExamSession.setNumOfQuestions(_numQuestions);
                _ExamSession.setAnswers(_answers);
                _ExamSession.setName(_controller.text);
                _ExamSession.setAvailableChoices(_numChoices);



                // luu vao repository
                bool add = await ExamSessionRepository.instance.add(_ExamSession);

                if (add){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen(examSession: _ExamSession,)),
                  );
                }


              },
              child: Text('Taking picture'),
            ),
          ],
        ),
      ),
    );
  }
}
