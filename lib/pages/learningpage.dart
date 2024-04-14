import 'package:flutter/material.dart';


class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  @override 
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List _buildList (int count) {
    List <Widget> listItems = [];
    for(int i = 0; i < count; i++) {
      listItems.add( 
        Container( 
          child: Card( 
            color: Colors.grey.shade800,
            child: Text( 
              'Lesson ${count}',
              style: TextStyle( 
                fontSize: 30,
                color: Colors.blue.shade200,
              ),
            ),
          ),
        ),
      );
    };
    return listItems;
  }
  final List<int> entries = <int>[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: CustomScrollView( 
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
            ),
          ),
        ),
        
        
        
        
        
      ]
      )
    );
  }
}