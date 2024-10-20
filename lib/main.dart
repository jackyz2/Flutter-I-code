import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/pages/authpage.dart';
import 'package:flutter_application_1/pages/gpttestpage.dart';
import 'package:flutter_application_1/pages/profilepage.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
import 'package:flutter_application_1/pages/registerpage.dart';
import 'package:flutter_application_1/pages/loginpage.dart';
import 'package:flutter_application_1/pages/settingspage.dart';
import 'package:flutter_application_1/pages/treetest.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/pages/randomPractice.dart';
//import 'package:flutter_application_1/pages/testpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  bool isAuthenticated = await API.validate();
  runApp(ProviderScope(child: MyApp(isAuthenticated: isAuthenticated)));
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
  final screens = [
    LearningPage(),
    ProfilePage(),
    ChoosePage(),
    GPTChatScreen()
  ];
  
  Color mainColor = Color.fromARGB(255, 91, 112, 204);
  Color secondColor = Color.fromARGB(255, 152, 195, 239);
  Color Background_white = Color.fromARGB(255, 251, 251, 251);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: IndexedStack(
        index: currentPageIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Background_white, 
        selectedItemColor: const Color.fromARGB(255, 26, 26, 26),
        unselectedItemColor: Colors.black54, 
        selectedFontSize: 16,
        unselectedFontSize: 14,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.wechat),
            label: 'Practice',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'AI Chat',
          ),
        ],
      ),
    );
  }
}
