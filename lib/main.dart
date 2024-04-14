import 'package:flutter/material.dart';
import 'package:flutter_application_1/dbtest.dart';
import 'package:flutter_application_1/pages/profilepage.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
import 'package:flutter_application_1/pages/registerpage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: MyHomePage(title: 'I-code'),
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
  final screens = [const LearningPage(), const ProfilePage(), RegisterPage()];
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

