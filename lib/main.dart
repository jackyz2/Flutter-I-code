import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/authpage.dart';
import 'package:flutter_application_1/pages/profilepage.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
import 'package:flutter_application_1/pages/registerpage.dart';
import 'package:flutter_application_1/pages/loginpage.dart';
import 'package:flutter_application_1/pages/settingspage.dart';
import 'package:flutter_application_1/services/api.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isAuthenticated = await API.validate();
  runApp(MyApp(isAuthenticated: isAuthenticated));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isAuthenticated ? MyHomePage(title: 'I-code') : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  final screens = [const LearningPage(), const ProfilePage(), SettingsPage()];
  Color mainColor = const Color(0xFF252C4A);
  Color secondColor = const Color(0xFF117EEB);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: IndexedStack( 
        index: currentPageIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar( 
        onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
        },
        currentIndex: currentPageIndex,
        items: const <BottomNavigationBarItem>[ 
           BottomNavigationBarItem(icon: Icon(Icons.book), label: 'learn',),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile',),
           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings',),
        ],
        
      ),
    );
    
  }

  
}

