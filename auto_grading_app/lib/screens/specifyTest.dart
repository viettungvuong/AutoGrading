import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecifyTestScreen extends StatefulWidget{
  @override
  _SpecifyTestScreenState createState() => _SpecifyTestScreenState();
}

class _SpecifyTestScreenState extends State<SpecifyTestScreen>{
  int _numQuestions = 2;
  int _numChoices = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number of Questions:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numQuestions = int.tryParse(value) ?? 0; // nhap so cau hoi
                });
              },
            ),
            SizedBox(height: 20),
            Text('Number of Choices:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numChoices = int.tryParse(value) ?? 0; // nhap so cau tra loi
                });
              },
            ),
            SizedBox(height: 20),
            Text('Grid:'),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _numChoices, // so cot
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: _numQuestions,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.blue[100],
                    alignment: Alignment.center,
                    child: Text(
                      'Q${index + 1}',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}