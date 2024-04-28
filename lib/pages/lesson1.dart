import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/question_model.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/pages/learningpage.dart';

int? selectedAnswerIndex;
  int questionIndex = 0;
  int idx = 0;
  int score = 0;
  bool checked = false;
  String buttonText = "Check Answer";
  Future<List<Question>>? fetchedQuestions;
  List<Question>? questions;

Future<List<Question>> fetchQuizQuestions() async {
    var refreshToken = await API.currentUserData.read(key: 'refreshToken');
    var data = {"refreshToken": refreshToken};
    return API.parseQ(data);
}
class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.question,
    required this.isSelected,
    required this.currentIndex,
    required this.correctAnswer,
    required this.selectedAnswerIndex,
  });

  final String question;
  final bool isSelected;
  final String correctAnswer;
  final int? selectedAnswerIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = question == correctAnswer;
    bool isWrongAnswer = !isCorrectAnswer && isSelected;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      
      child: selectedAnswerIndex != null
          // if one option is chosen
          ? Container(
              height: 70,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorrectAnswer
                      ? Colors.green
                      : isWrongAnswer
                          ? Colors.red
                          : Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isCorrectAnswer
                      ? buildCorrectIcon()
                      : isWrongAnswer
                          ? buildWrongIcon()
                          : const SizedBox.shrink(),
                ],
              ),
            )
          // If no option is selected
          : Container(
              height: 70,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget buildCorrectIcon() => const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.green,
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );

Widget buildWrongIcon() => const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.red,
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );

class QuizFetchScreen extends StatefulWidget {
  const QuizFetchScreen({super.key});
  @override
  State<QuizFetchScreen> createState() => _QuizFetchScreenState();
}
  
class _QuizFetchScreenState extends State<QuizFetchScreen> {
  @override 
  Widget build(BuildContext context) {
    //final question = questions[0];
    
      return Container(
        height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 137, 188, 255), Color(0xFF0652C5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:
      FutureBuilder<List <Question>>(
        future: fetchQuizQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while the data is being fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if something went wrong during the fetch
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Data is fetched successfully and the list is not empty
            //Question currQuestion = snapshot.data![questionIndex]; 
            //bool isLastQuestion = questionIndex == snapshot.data!.length - 1;
            questions = snapshot.data!;
            return QuizScreen();
          } else {
            // Handle the case where there is no data returned
            return Center(child: Text('No questions available'));
          }
        },
      ),
      );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override 
  Widget build(BuildContext context) {
Question currQuestion = questions![questionIndex];
return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    currQuestion.questionTitle,
                    style: const TextStyle( 
                      fontSize: 25,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ), // Display the question
                  ListView.builder( 
                    shrinkWrap: true,
                    itemCount: currQuestion.options.length,
                    itemBuilder: (context, index) {
                      return GestureDetector( 
                        onTap: selectedAnswerIndex == null ?() { 
                          selectedAnswerIndex = index;
                          idx = index;
                         } : null,
                        child: AnswerCard( 
                          currentIndex: index,
                          question: currQuestion.options[index],
                          isSelected: selectedAnswerIndex == index,
                          selectedAnswerIndex: selectedAnswerIndex,
                          correctAnswer: currQuestion.answer,
                        )
                      );
                    },
                  ),
                  const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: selectedAnswerIndex == null ?() { 
                          if(!checked){
                            if(currQuestion.options[idx] == currQuestion.answer) {
                              ++score;
                            }
                            checked = true;
                            buttonText = "Continue";
                          }
                          setState(() {});
                         } : () {
                            ++questionIndex;
                            selectedAnswerIndex = null;
                            buttonText = "Check Answer";
                            checked = false;
                            currQuestion = questions![questionIndex]; 
                            setState(() {});
                          },
                          
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightBlue[200],
                          ),
                          child: Center(
                            child: Text(
                              buttonText,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                
                ],
              ),
      );
  }
}