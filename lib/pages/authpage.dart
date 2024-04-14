/*
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'loginpage.dart';
import 'profilepage.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      body: StreamBuilder<User?> ( 
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ProfilePage();
          }
          else {
            return LoginPage();
          }
        }
      )
    );
  }
}*/