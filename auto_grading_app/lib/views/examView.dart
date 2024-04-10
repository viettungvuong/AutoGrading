
import 'package:flutter/cupertino.dart';

import '../models/Exam.dart';
import 'View.dart';

class ExamView extends ObjectView<Exam> { // hien bai ktra cua hoc sinh
  ExamView({required super.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            t.getStudent().getName(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            t.getScore().toString(),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}