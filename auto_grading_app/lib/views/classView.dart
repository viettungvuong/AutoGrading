import 'package:flutter/cupertino.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import 'View.dart';

class ClassView extends ObjectView<Class>{ // hien bai ktra cua hoc sinh
  ClassView({required super.t});

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