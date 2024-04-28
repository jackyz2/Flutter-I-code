import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/lesson1.dart';
import 'dart:math';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  @override 
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: Stack(
        body:CustomScrollView(
          slivers: <Widget>[ 
            SliverAppBar( 
              pinned: true,
              floating: true,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar( 
              title: const Text('C++'),
              background: Image.asset( 
              'assets/images/cpp_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
            manyLessons(
                [lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, true),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, false),
                lesson('images/es.png', '3', 'Lessons', Colors.orange[100]!, false),
                ]
              ),
          ])
        );}

  Widget appBarItem(String image, String num, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          image,
          height: 25,
        ),
        Text(
          num,
          style: TextStyle(color: color, fontSize: 16),
        ),
      ],
    );
  }

  Widget manyLessons(List<Widget> lessons) {
     return SliverList(
              delegate: SliverChildListDelegate(
                lessons
              ));

  }

  Widget lesson(String image, String number, String title, Color color, bool Active) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: 3 * pi / 4,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.yellow[600]!),
                  value: Random().nextDouble(),
                  strokeWidth: 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), //or 15.0
                  child: Container(
                    height: 70.0,
                    width: 70.0,
                    color: Color(0xffFF0E58),
                    child:
                        Icon(Icons.star, color: Colors.white, size: 50.0),
                  ),
                ),
                //Square(
                //  backgroundColor: Colors.white,
                // radius: 42,
                //),
              ),
              GestureDetector( 
                onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizFetchScreen()),
                          );
                        },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), //or 15.0
                  
                  child: Container(
                    
                    height: 70.0,
                    width: 70.0,
                    color: Active ? Color(0xffFF0E58) : Colors.grey,
                    child:
                        Icon(Icons.star_rounded, color: Colors.white, size: 50.0),
                  ),
                  
                ),// CircleAvatar(
              //   child: Image.asset(image, height: 50),
              //   radius: 35,
              //   backgroundColor: color,
              // )
              )
              
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              
              Text(
                number,
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}