import 'package:flutter/material.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      body:  Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Profile',
            ),
            
          ],
        ),
      ),
      
      ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}