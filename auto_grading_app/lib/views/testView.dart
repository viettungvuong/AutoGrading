
import 'package:flutter/cupertino.dart';

class TestView extends StatelessWidget {
  final String name;
  final double score;

  TestView({required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            score.toString(),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}