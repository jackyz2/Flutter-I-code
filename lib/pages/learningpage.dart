import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/lessons.dart';
import 'package:flutter_application_1/services/api.dart';
import 'dart:math';

int currentUserLevel = 0;

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  @override 
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  @override
  void initState() {
    super.initState();
    _loadUserLevel();
  }
  Future<void> _loadUserLevel() async {
    String? CUL = await API.currentUserData.read(key: 'level');
    currentUserLevel = CUL != null ? int.parse(CUL) : 0; //numberString != null ? int.parse(numberString) : null;
    setState(() {});  // This call to setState will trigger the widget to rebuild if needed
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: Stack(
        body:CustomScrollView(
          slivers: <Widget>[ 
            SliverAppBar( 
              automaticallyImplyLeading: false,
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
                [lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 0),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 1),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 2),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 3),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 4),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 5),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 6),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 7),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 8),
                lesson('images/es.png',  'Lesson ', Colors.orange[100]!, 9),
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

  Widget lesson(String image, String title, Color color, int level) {
    bool Active = level <= currentUserLevel + 1;
    bool Clickable = level == currentUserLevel + 1;
    String completeTitle = title + level.toString();
    //double circularlevel = 
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
                  value: level <= currentUserLevel ? 1.0 : 0.0,
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
                            if(Clickable) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizFetchScreen()),
                              );
                            }
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
          SizedBox(
            height: 10,
          ),
          Text(
            completeTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}