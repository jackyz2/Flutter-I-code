import 'package:flutter/material.dart';


class TreePage extends StatefulWidget {
  @override
  State<TreePage> createState() => _TreePageState();
}

class NodeTemplate {
  int id = 0;
  int value = 0;
  bool solid = false;
  Color color = Color.fromARGB(255, 242, 242, 242);
  bool isCorrect = false;

  NodeTemplate();
}

class _TreePageState extends State<TreePage> {
  // This list holds the color of each box, initially all are grey.
  int nodeValue = 0;
  //List<Color> boxColors = List<Color>.filled(15, Colors.grey);
  List<NodeTemplate> treeNodes = List<NodeTemplate>.generate(15, (_) => NodeTemplate());
  List<int> answers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  
  double screenWidth = 0;
  double screenHeight = 0;
  double WstretchConstant = 0;
  double HstretchConstant = 0;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    WstretchConstant = screenWidth / 480;
    HstretchConstant = screenHeight / 932;
    //print(screenWidth);
    //print(screenHeight);
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Blue Box'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
        children: [
          // Binary tree structure
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Level 1 - 1 box
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDragTarget(0),
                    ],
                  ),
                  SizedBox(height: 25.0 * HstretchConstant), // For spacing between levels

                  // Level 2 - 2 boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDragTarget(1),
                      SizedBox(width: 100 * WstretchConstant),
                      buildDragTarget(2),
                    ],
                  ),
                  SizedBox(height: 25.0 * HstretchConstant), // For spacing between levels

                  // Level 3 - 4 boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDragTarget(3),
                      SizedBox(width: 41 * WstretchConstant),
                      buildDragTarget(4),
                      SizedBox(width: 41 * WstretchConstant),
                      buildDragTarget(5),
                      SizedBox(width: 41 * WstretchConstant),
                      buildDragTarget(6),
                    ],
                  ),
                  SizedBox(height: 25.0 * HstretchConstant), // For spacing between levels

                  // Level 4 - 8 boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDragTarget(7),
                      buildDragTarget(8),
                      buildDragTarget(9),
                      buildDragTarget(10),
                      buildDragTarget(11),
                      buildDragTarget(12),
                      buildDragTarget(13),
                      buildDragTarget(14),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Draggable blue box at the bottom
          Draggable<int>(
            data: nodeValue,
            feedback: Container(
              width: 50.0 * WstretchConstant,
              height: 50.0 * HstretchConstant,
              color: Colors.blue.withOpacity(0.7),
              child: Center(child: Text(nodeValue.toString())),
            ),
            childWhenDragging: Container(
              width: 50.0 * WstretchConstant,
              height: 50.0 * HstretchConstant,
              color: Colors.blue.withOpacity(0.3),
            ),
            child: Container(
              width: 50.0 * WstretchConstant,
              height: 50.0 * HstretchConstant,
              color: Colors.blue,
              child: Center(child: Text(nodeValue.toString())),
            ),
          ),
          SizedBox(height: 30 * HstretchConstant),
          ElevatedButton(onPressed: checkAnswers, child: Text("Check Answers")),
        ],
      ),
      ),

      // Use the built-in floatingActionButton property
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context); // Show the dialog to enter value
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  void checkAnswers() {
    setState(() {
      for (int i = 0; i < treeNodes.length; i++) {
        if(!treeNodes[i].isCorrect) {
          treeNodes[i].color = Colors.red;
        }
      }
    });
  }

  void _showInputDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter value for the Node'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter value"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  nodeValue = int.tryParse(controller.text) ?? 0; // Parse input or default to 0
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Function to build a DragTarget for the grey boxes
  Widget buildDragTarget(int index) {
    if(treeNodes[index].value == answers[index]) {
      treeNodes[index].isCorrect = true;
    } else {
      treeNodes[index].isCorrect = false;
    }
    double sizeConstant = 1;
    if(index == 0){
      sizeConstant = 1.5;
    }
    else if(index == 1 || index == 2){
      sizeConstant = 1.3;
    }
    else if(index == 3 || index == 4 || index == 5 || index == 6){
      sizeConstant = 1.1;
    }
    else if(index == 7 || index == 8 || index == 9 || index == 10 || index == 11 || index == 12 || index == 13 || index == 14){
      sizeConstant = 1;
    }
    return GestureDetector(
      onLongPress: () {
        setState(() {
          treeNodes[index].id = index;
          treeNodes[index].value = 0;
          treeNodes[index].color = Color.fromARGB(255, 242, 242, 242);
          treeNodes[index].solid = false;
        });
      },
      child: DragTarget<int>(
        onAccept: (data) {
          setState(() {
            treeNodes[index].color = Colors.blue; // Change color when blue box is dropped
            treeNodes[index].value = data;
            treeNodes[index].solid = true;
            if (treeNodes[index].value == answers[index]) {
              treeNodes[index].isCorrect = true;
            } else {
              treeNodes[index].isCorrect = false;
            }
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            
            width: sizeConstant * 50.0 * WstretchConstant,
            height: sizeConstant * 50.0 * HstretchConstant,
            margin: EdgeInsets.symmetric(horizontal: 4.0 * WstretchConstant),
            decoration: BoxDecoration(
            color: treeNodes[index].color, // Dynamic color based on state
            shape: BoxShape.circle, // Makes the container a circle
          ),
            //color: treeNodes[index].color, // Dynamic color based on state
            child: Center(
              child: Text(
                treeNodes[index].value == 0 ? "" : treeNodes[index].value.toString(),
                style: TextStyle(fontSize: 15 * sizeConstant, color: Colors.white),
              ),
            ),
          );
        },
        
      ),
    );
  }
}
