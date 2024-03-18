import 'package:flutter/material.dart';

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
      
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  int streak = 0;
  int progress = 0;
  Widget _MainAppBarCPP() {
    return CustomScrollView( 
      slivers: <Widget> [
        SliverAppBar( 
          pinned: true,
          floating: true,
          expandedHeight: 160.0,
          flexibleSpace: FlexibleSpaceBar( 
            title: const Text('Flutter Mapp'),
            background: Image.asset( 
              'cpp.jpg',
              fit: BoxFit.cover,
            )
          ),
        )
      ]
    );
  }
  final List<int> entries = <int>[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      
      body: CustomScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        slivers: <Widget> [
        SliverAppBar( 
          pinned: true,
          floating: true,
          expandedHeight: 160.0,
          flexibleSpace: FlexibleSpaceBar( 
            //backgroundColor: Color(0x349BEB),
            title: const Text('C++'),
            background: Image.asset( 
              'assets/images/cpp_bg.jpg',
              fit: BoxFit.cover,
            )
            
          ),
        ),
        SliverList( 
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
              height: 100,
              child: ListTile( 
              leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                CircleAvatar(backgroundColor: Color(0xFFB74093),
                  radius: 20,),
                  Text('Index: $index'),
              ]
            ),
            
            title: const Text(''),
             
          
            
            trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                     //_onDeleteItemPressed(index);
                },
              ),
          ),
            );
            },
          childCount: entries.length,
            
        ),
        )
      ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
