import 'package:flutter/material.dart';

class DraggableExample extends StatefulWidget {
  @override
  _DraggableExampleState createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<DraggableExample> {
  @override
  Widget build (BuildContext context) {
    return MaterialApp( 
      home: Scaffold( 
        body: Center(
          child:  Draggable( 
            child: Container( 
              width: 100,
              height: 100,
              color: Colors.blue,
              alignment: Alignment.center,
            ),
            feedback: Container(
              width: 80,
              height: 80,
              color: Colors.blue.withOpacity(0.5),
              alignment: Alignment.center,
            ),
          )

        )
      )
    );
  }
}