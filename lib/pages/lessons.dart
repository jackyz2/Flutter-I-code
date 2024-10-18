import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/question_model.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
import 'package:flutter_application_1/pages/scorescreen.dart';
import 'package:flutter_application_1/pages/treescreen.dart';

Future<List<Question>>? fetchedQuestions;
List<Question>? questions;
List<Image?> questionImages = [];

Future<List<Question>> fetchQuizQuestions() async {
  var refreshToken = await API.currentUserData.read(key: 'refreshToken');
  var data = {"refreshToken": refreshToken};
  return API.parseQ(data);
}

class ProgressBar extends StatefulWidget {
  final int currentIndex;
  final int totalQuestions;

  const ProgressBar({
    Key? key,
    required this.currentIndex,
    required this.totalQuestions,
  }) : super(key: key);

  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    double progress = widget.currentIndex / widget.totalQuestions;
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(
          const Color.fromARGB(255, 182, 218, 248)),
    );
  }
}

class AnswerCard extends StatelessWidget {
  const AnswerCard(
      {super.key,
      required this.question,
      required this.isSelected,
      required this.currentIndex,
      required this.correctAnswer,
      required this.selectedAnswerIndex,
      required this.check});

  final String question;
  final bool isSelected;
  final String correctAnswer;
  final int? selectedAnswerIndex;
  final int currentIndex;
  final bool check;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double WstretchConstant = screenWidth / 480;
    double HstretchConstant = screenHeight / 932;
    bool isCorrectAnswer = question == correctAnswer;
    bool isWrongAnswer = !isCorrectAnswer && isSelected;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0 * HstretchConstant,
      ),
      child: Container(
        height: 70 * HstretchConstant,
        padding: EdgeInsets.all(16.0 * WstretchConstant),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue[200] : Colors.white,
          borderRadius: BorderRadius.circular(10 * WstretchConstant),
          border: Border.all(
            color: selectedAnswerIndex != null && check
                ? isCorrectAnswer
                    ? Colors.green
                    : isWrongAnswer
                        ? Colors.red
                        : Colors.grey
                : Colors.white,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
            SizedBox(height: 10 * HstretchConstant),
            selectedAnswerIndex == null || !check
                ? const SizedBox.shrink()
                : isCorrectAnswer
                    ? buildCorrectIcon(WstretchConstant)
                    : isWrongAnswer
                        ? buildWrongIcon(WstretchConstant)
                        : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

Widget buildCorrectIcon(double WstretchConstant) => CircleAvatar(
      radius: 15 * WstretchConstant,
      backgroundColor: Colors.green,
      child: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );

Widget buildWrongIcon(double WstretchConstant) => CircleAvatar(
      radius: 15 * WstretchConstant,
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );

class QuizFetchScreen extends StatefulWidget {
  const QuizFetchScreen({super.key});
  @override
  State<QuizFetchScreen> createState() => _QuizFetchScreenState();
}

Future<void> imageListBuilder(List<Question>? questions) async {
  for (var question in questions!) {
    if (question.imageUrl != "") {
      Image? image = await API.parseImage(question.imageUrl);
      questionImages.add(image);
    } else {
      questionImages.add(null);
    }
  }
}

Future<List<Question>?> fetchAndBuildQuiz() async {
  fetchedQuestions = fetchQuizQuestions();
  questions = await fetchedQuestions;
  await imageListBuilder(questions);
  return questions;
}

class _QuizFetchScreenState extends State<QuizFetchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 254, 254, 254),
            Color.fromARGB(255, 164, 191, 233)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FutureBuilder<List<Question>?>(
        future: fetchAndBuildQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            questions = snapshot.data!;
            return QuizScreen();
          } else {
            return Center(child: Text('No questions available'));
          }
        },
      ),
    );
  }
}

class NodeTemplate {
  int id = 0;
  int value = 0;
  bool solid = false;
  Color color = Color.fromARGB(255, 242, 242, 242);
  bool isCorrect = false;

  NodeTemplate();
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int idx = 0;
  int score = 0;
  bool checked = false;
  String buttonText = "Check Answer";
  double screenWidth = 0;
  double screenHeight = 0;
  double WstretchConstant = 0;
  double HstretchConstant = 0;
  late List<NodeTemplate> treeNodes;
  int nodeValue = 0;
  Question currQuestion = questions![0];
  @override
  void initState() {
    super.initState();
    treeNodes = List<NodeTemplate>.generate(15, (_) => NodeTemplate());
  }

  Widget build(BuildContext context) {
    // Screen size adjustments
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    WstretchConstant = screenWidth / 480;
    HstretchConstant = screenHeight / 932;

    // Get the current question
    currQuestion = questions![questionIndex];

    // Main widget layout
    return Padding(
      padding: EdgeInsets.all(24.0),
      //child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ProgressBar and Question Title (common to all question types)
          SizedBox(height: 35 * HstretchConstant),
          ProgressBar(
            currentIndex: questionIndex,
            totalQuestions: questions!.length,
          ),
          SizedBox(
              height: 20 *
                  HstretchConstant), // Add space between ProgressBar and title
          Text(
            currQuestion.questionTitle,
            style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                decoration: TextDecoration.none),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height:
                  30 * HstretchConstant), // Add space before question content

          // Conditional rendering of either Tree question or Multiple Choice question
          if (currQuestion.isTree && currQuestion.options.isNotEmpty)
            buildTreeQuestion(currQuestion.options.map(int.parse).toList())
          else
            //SingleChildScrollView(
            //child:
            buildMultipleChoiceQuestion(currQuestion),
          //)
        ],
      ),
      //),
    );
  }

  Widget buildMultipleChoiceQuestion(Question currQuestion) {
    return Expanded(
      child: SingleChildScrollView(
        // Allows the entire content to scroll
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (questionImages[questionIndex] != null)
                Center(
                  child: SizedBox(
                    child: questionImages[questionIndex],
                    height: 250,
                    width: 250,
                  ),
                ),
              ListView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // Prevent ListView from scrolling independently
                shrinkWrap: true,
                itemCount: currQuestion.options.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAnswerIndex == index;
                  return GestureDetector(
                    onTap: checked
                        ? null
                        : () {
                            setState(() {
                              selectedAnswerIndex = index;
                            });
                          },
                    child: AnswerCard(
                      currentIndex: index,
                      question: currQuestion.options[index],
                      isSelected: isSelected,
                      selectedAnswerIndex: selectedAnswerIndex,
                      correctAnswer: currQuestion.answer,
                      check: checked,
                    ),
                  );
                },
              ),
              SizedBox(height: 30 * HstretchConstant),
              AbsorbPointer(
                absorbing: selectedAnswerIndex == null,
                child: GestureDetector(
                  onTap: !checked
                      ? () {
                          if (selectedAnswerIndex != null) {
                            if (currQuestion.options[selectedAnswerIndex!] ==
                                currQuestion.answer) {
                              ++score;
                            }
                          }
                          setState(() {
                            checked = true;
                            buttonText = "Continue";
                          });
                        }
                      : questionIndex == questions!.length - 1
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScoreScreen(score: score),
                                ),
                              );
                            }
                          : () {
                              setState(() {
                                ++questionIndex;
                                selectedAnswerIndex = null;
                                buttonText = "Check Answer";
                                checked = false;
                                currQuestion = questions![questionIndex];
                              });
                            },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: selectedAnswerIndex == null
                          ? Colors.grey[400]
                          : Colors.lightBlue[200],
                    ),
                    child: Center(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTreeQuestion(List<int> answers) {
    //int nodeValue = 0;
    //treeNodes = List<NodeTemplate>.generate(15, (_) => NodeTemplate());

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.7, // Set a maximum height
        maxWidth:
            MediaQuery.of(context).size.width * 1.5, // Set a maximum width
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tree UI layout
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Level 1 - 1 box
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDragTarget(0, answers),
                  ],
                ),
                SizedBox(
                    height:
                        30.0 * HstretchConstant), // For spacing between levels

                // Level 2 - 2 boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDragTarget(1, answers),
                    SizedBox(width: 100 * WstretchConstant),
                    buildDragTarget(2, answers),
                  ],
                ),
                SizedBox(
                    height:
                        30.0 * HstretchConstant), // For spacing between levels

                // Level 3 - 4 boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDragTarget(3, answers),
                    SizedBox(width: 40 * WstretchConstant),
                    buildDragTarget(4, answers),
                    SizedBox(width: 41 * WstretchConstant),
                    buildDragTarget(5, answers),
                    SizedBox(width: 40 * WstretchConstant),
                    buildDragTarget(6, answers),
                  ],
                ),
                SizedBox(
                    height:
                        30.0 * HstretchConstant), // For spacing between levels

                // Level 4 - 8 boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDragTarget(7, answers),
                    buildDragTarget(8, answers),
                    buildDragTarget(9, answers),
                    buildDragTarget(10, answers),
                    buildDragTarget(11, answers),
                    buildDragTarget(12, answers),
                    buildDragTarget(13, answers),
                    buildDragTarget(14, answers),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30 * HstretchConstant),
          buildDraggableBox(),
          SizedBox(height: 30 * HstretchConstant),
          // FloatingActionButton(
          //   onPressed: () async {
          //     await _showInputDialog(context); // Show the dialog to enter value
          //   },
          //   backgroundColor: Colors.blue,
          //   child: Icon(Icons.add),
          // ),
          FloatingActionButton(
            onPressed: () async {
              int? result = await _showInputDialog(
                  context); // Get the result from the dialog

              if (result != null && mounted) {
                setState(() {
                  nodeValue = result;
                });
              }
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),

          SizedBox(height: 30 * HstretchConstant),
          GestureDetector(
            onTap: !checked
                ? () {
                    checkAnswers();
                    setState(() {
                      checked = true;
                      buttonText = "Continue";
                    });
                  }
                : questionIndex == questions!.length - 1
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScoreScreen(
                                    score: score,
                                  )),
                        );
                      }
                    : () {
                        setState(() {
                          ++questionIndex;
                          selectedAnswerIndex = null;
                          buttonText = "Check Answer";
                          checked = false;
                          currQuestion = questions![questionIndex];
                        });
                      },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: selectedAnswerIndex == null
                    ? Colors.grey[400]
                    : Colors.lightBlue[200],
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDragTarget(int index, List<int> answers) {
    if (treeNodes[index].value == answers[index]) {
      treeNodes[index].isCorrect = true;
    } else {
      treeNodes[index].isCorrect = false;
    }
    double sizeConstant = 1;
    if (index == 0) {
      sizeConstant = 1.5;
    } else if (index == 1 || index == 2) {
      sizeConstant = 1.3;
    } else if (index == 3 || index == 4 || index == 5 || index == 6) {
      sizeConstant = 1.1;
    } else if (index == 7 ||
        index == 8 ||
        index == 9 ||
        index == 10 ||
        index == 11 ||
        index == 12 ||
        index == 13 ||
        index == 14) {
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
            treeNodes[index].color =
                Colors.blue; // Change color when blue box is dropped
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
            width: sizeConstant * 44.0 * WstretchConstant,
            height: sizeConstant * 45.0 * HstretchConstant,
            margin: EdgeInsets.symmetric(horizontal: 4.0 * WstretchConstant),
            decoration: BoxDecoration(
              color: treeNodes[index].color, // Dynamic color based on state
              shape: BoxShape.circle, // Makes the container a circle
            ),
            //color: treeNodes[index].color, // Dynamic color based on state
            child: Center(
              child: Text(
                treeNodes[index].value == 0
                    ? ""
                    : treeNodes[index].value.toString(),
                style: TextStyle(
                    fontSize: 15 * sizeConstant,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDraggableBox() {
    return Draggable<int>(
        data: nodeValue,
        feedback: Container(
          width: 50.0 * WstretchConstant,
          height: 50.0 * HstretchConstant,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Text(
            nodeValue.toString(),
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.none),
          )),
        ),
        childWhenDragging: Container(
          width: 50.0 * WstretchConstant,
          height: 50.0 * HstretchConstant,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        child: Container(
          width: 50.0 * WstretchConstant,
          height: 50.0 * HstretchConstant,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Text(
            nodeValue.toString(),
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.none),
          )),
        ));
  }

  void checkAnswers() {
    int correct = 1;
    setState(() {
      for (var node in treeNodes) {
        if (!node.isCorrect) {
          correct = 0;
          node.color = Colors.red;
        } else {
          node.color = Colors.green;
        }
      }
      score += correct;
    });
  }

//   Future<void> _showInputDialog(BuildContext context) async {
//   TextEditingController controller = TextEditingController();
//   await showDialog(
//     context: context,
//     builder: (dialogContext) {
//       return AlertDialog(
//         title: Text('Enter value for the Node'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(hintText: "Enter value"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (mounted) {
//                 setState(() {
//                   nodeValue = int.tryParse(controller.text) ?? 0;
//                   print('nodeValue set to $nodeValue');
//                     print('Current questionIndex: $questionIndex');
//                     print('Checked status: $checked');
//                 });
//               }
//               Navigator.of(dialogContext).pop();
//             },
//             child: Text('Submit'),
//           ),
//         ],
//       );
//     },
//   );
// }
  Future<int?> _showInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    int? enteredValue;

    await showDialog<int?>(
      context: context,
      builder: (dialogContext) {
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
                enteredValue = int.tryParse(controller.text);
                Navigator.of(dialogContext).pop(enteredValue);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    return enteredValue;
  }
}
