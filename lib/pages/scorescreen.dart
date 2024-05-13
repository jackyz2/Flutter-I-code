import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/services/api.dart';

class ScoreScreen extends StatefulWidget {
  final int score;

  const ScoreScreen({Key? key, required this.score}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  late Future<String?> currentLevelFuture;

  @override
  void initState() {
    super.initState();
    // Load current level asynchronously and handle it with FutureBuilder
    currentLevelFuture = API.currentUserData.read(key: 'level');
    
  }
  int IcurrentLevel = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Score')),
      body: Column(children: [
        Text('Your Score: ${widget.score}', style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        FutureBuilder<String?>(
          future: currentLevelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              // Assuming the API returns a valid level as a string.
              IcurrentLevel = int.parse(snapshot.data!);
              IcurrentLevel++;
              return Text('Current Level: $IcurrentLevel', style: TextStyle(fontSize: 20));
            } else {
              // Show a loading spinner while waiting for the data
              return CircularProgressIndicator();
            }
          },
        ),
        ElevatedButton(
            onPressed: () async {
              
              String ScurrentLevel = IcurrentLevel.toString();
              await API.currentUserData.write(key: 'level', value: ScurrentLevel);
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'I-code')),
              );
            },
            child: Text('Back to Learning Page'))
      ]),
    );
  }
}
