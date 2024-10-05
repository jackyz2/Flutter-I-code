import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/treetest.dart';

class ChoosePage extends StatelessWidget {
  const ChoosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, 
        color: Colors.lightBlue[200], 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Choose your practice type',
                style: TextStyle(
                  color: Color.fromARGB(255, 252, 252, 252),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
            const SizedBox(height: 5), 
            Expanded(
              child: Container(
                width: double.infinity, 
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 232, 231, 231),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(60), 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: <Widget>[
                      // Tree Practice Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TreePage(), 
                            ),
                          );
                        },
                        child: const Text('Tree Practice'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          elevation: 8, 
                          minimumSize: Size(double.infinity, 50), // Flexible size
                        ),
                      ),
                      const SizedBox(height: 60), // Space between buttons
                      // Centering the "Multiple Choice Question" text inside the button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TreePage(), // Route to MCQ (Tree for now)
                            ),
                          );
                        },
                        child: const Text(
                          'Multiple Choice Question',
                          textAlign: TextAlign.center, // Ensure text is centered
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          elevation: 8,
                          minimumSize: Size(double.infinity, 50), // Flexible size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
