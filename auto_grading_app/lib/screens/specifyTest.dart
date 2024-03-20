import 'package:auto_grading_mobile/widgets/cameraScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecifyTestScreen extends StatefulWidget {
  @override
  _SpecifyTestScreenState createState() => _SpecifyTestScreenState();
}

class _SpecifyTestScreenState extends State<SpecifyTestScreen> {
  int _numQuestions = 2;
  int _numChoices = 2;

  List<int> _answers = []; // luu lai nhung gi da chon

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _numQuestions; i++) {
      _answers.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number of Questions:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  int oldNumQuestions = _numQuestions;
                  _numQuestions = int.tryParse(value) ?? 1;
                  if (_numQuestions > oldNumQuestions) {
                    for (int i = oldNumQuestions; i < _numQuestions; i++) {
                      _answers.add(0);
                    }
                  } else {
                    for (int i = oldNumQuestions - 1; i >= _numQuestions; i--) {
                      _answers.removeLast();
                    }
                  }
                });
              },
            ),
            SizedBox(height: 20),
            Text('Number of Choices:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  int oldNumChoices = _numChoices;
                  _numChoices = int.tryParse(value) ?? 1;
                  if (oldNumChoices < _numChoices) {
                    for (int i = 0; i < _numQuestions; i++) {
                      if (_answers[i] >= _numChoices) {
                        _answers[i]--;
                      }
                    }
                  }
                });
              },
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _numChoices,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                ),
                itemCount: _numQuestions * _numChoices,
                itemBuilder: (BuildContext context, int index) {
                  final questionIndex = index ~/ _numChoices;
                  final choiceIndex = index % _numChoices;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      choiceIndex==0?Text("Question ${questionIndex + 1}:"):Text(""), // Display the question index
                      Row(
                        children: [
                          Text("${String.fromCharCode(65 + choiceIndex)}"),
                          Radio<int>(
                            value: index,
                            groupValue: _answers[questionIndex],
                            onChanged: (value) {
                              setState(() {
                                _answers[questionIndex] = value! ~/ _numChoices;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              },
              child: Text('Taking picture'),
            ),
          ],
        ),
      ),
    );
  }
}
