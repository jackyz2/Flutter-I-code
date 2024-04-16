import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'loginpage.dart';
import 'profilepage.dart';
import 'package:flutter_application_1/services/api.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    _validateSession();
  }

  Future<void> _validateSession() async {
    bool isValid = await API.validate();
    
    if (isValid) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage(title: "home")));
      
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // While checking the session, you can display a loading spinner or any other placeholder
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

