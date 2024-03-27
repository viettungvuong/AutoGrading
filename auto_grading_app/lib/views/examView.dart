
import 'package:flutter/cupertino.dart';

import '../models/Exam.dart';

class ExamView extends StatelessWidget { // hien bai ktra cua hoc sinh
  final Exam exam;

  ExamView({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            exam.getStudent().getName(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            exam.getScore().toString(),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}