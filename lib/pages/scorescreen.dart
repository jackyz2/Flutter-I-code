import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScoreScreen extends StatelessWidget {
  final int score;

  const ScoreScreen({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Score')),
      body: Column(children: [
        Text('Your Score: $score', style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/learningpage');
            },
            child: Text('Back to Learning Page'))
      ]),
    );
  }
}