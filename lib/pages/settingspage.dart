import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: API.currentUserData.read(key: "level"),  // This is the Future being awaited
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();  // Show loading while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');  // Handle errors
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('User Level: ${snapshot.data}'),  // Display the data
                ],
              );
            } else {
              return const Text('No data available');  // Handle no data scenario
            }
          },
        ),
      ),
    );
  }
}
