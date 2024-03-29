import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/profilepage.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: const MyHomePage(title: 'I-code'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  final screens = [LearningPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

