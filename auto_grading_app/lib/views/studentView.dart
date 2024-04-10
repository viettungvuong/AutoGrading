import 'package:flutter/cupertino.dart';

import '../models/Student.dart';
import 'View.dart';

class StudentView extends ObjectView<Student>{ // hien bai ktra cua hoc sinh
  StudentView({required super.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            t.getName(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

        ],
      ),
    );
  }
}